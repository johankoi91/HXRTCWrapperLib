//
//  File.swift
//  HXRTCWrapperLib
//
//  Created by hanxiaoqing on 2024/10/15.
//

import Foundation
import RongIMLibCore
import RongChatRoom

class RCLiveVideoEngine: NSObject, RCIMClientReceiveMessageDelegate, RCChatRoomStatusDelegate {
    func onChatRoomJoining(_ chatroomId: String) {
        <#code#>
    }
    
    func onChatRoomJoined(_ chatroomId: String, response: RCJoinChatRoomResponse) {
        <#code#>
    }
    
    func onChatRoomJoined(_ chatroomId: String) {
        <#code#>
    }
    
    func onChatRoomJoinFailed(_ chatroomId: String, errorCode: RCErrorCode) {
        <#code#>
    }
    
    func onChatRoomReset(_ chatroomId: String) {
        <#code#>
    }
    
    func onChatRoomQuited(_ chatroomId: String) {
        <#code#>
    }
    
    func onChatRoomDestroyed(_ chatroomId: String, type: RCChatRoomDestroyType) {
        <#code#>
    }
    

    static let liveVideoLibName = "livevideolib"
    static let liveVideoLibVersion = "2.1.4.1"
    
    static let shared = RCLiveVideoEngine()
    
    // MARK: - Properties
    var roomId: String? {
        return RCLiveVideoSync.roomId()
    }
    
    var currentRole: RCRTCLiveRoleType {
        return RCLiveVideoManager.shared.role
    }
    
    var currentMixType: RCLiveVideoMixType {
        return RCLiveVideoManager.shared.mixType
    }
    
    var currentSeats: [RCLiveVideoSeat] {
        return RCLiveVideoManager.shared.seats
    }
    
    weak var delegate: RCLiveVideoDelegate?
    weak var pkDelegate: RCLiveVideoPKDelegate?
    weak var mixDelegate: RCLiveVideoMixDelegate?
    weak var mixDataSource: RCLiveVideoMixDataSource?
    
    // 用户进出房间是否发送消息，默认 NO
    var enableInOutRoomEvent: Bool = false
    
    var pkInfo: RCLiveVideoPK? {
        return self.PK
    }

    private var PK: RCLiveVideoPK?
    private var otherRoom: RCRTCOtherRoom?

    private override init() {
        super.init()
        setupDelegates()
    }

    // MARK: - Setup
    private func setupDelegates() {
        RCRTCEngine.sharedInstance().statusReportDelegate = self
        RCCoreClient.shared().add(self)
        RCChatRoomClient.shared().setChatRoomStatusDelegate(self)
        RCChatRoomClient.sharedChatRoomClient().setRCChatRoomKVStatusChangeDelegate(self)
        RCChatRoomClient.sharedChatRoomClient().setMemberDelegate(self)
    }

    // MARK: - Methods

    // 房主准备直播，视频流回调
    func prepare() {
        RCLiveVideoManager.shared.roomUserId = currentUserId
        RCLiveVideoManager.shared.role = .broadcaster
        RCLiveVideoManager.shared.mixType = .oneToOne
        reloadVideoView()
    }

    // 房主开始或恢复直播
    func begin(roomId: String, completion: @escaping (RCLiveVideoCode) -> Void) {
        DispatchQueue.global().async {
            // Clean up, reset PK state, etc.
            self.PK = nil
            self.otherRoom = nil
            
            let semaphore = DispatchSemaphore(value: 0)
            
            // Join live room
            let config = RCRTCRoomConfig()
            config.roomType = .live
            
            var rtcRoom: RCRTCRoom?
            var rtcCode: RCRTCCode = .success
            RCRTCEngine.sharedInstance().joinRoom(roomId, config: config) { room, code in
                rtcRoom = room
                rtcCode = code
                semaphore.signal()
            }
            semaphore.wait()
            
            guard rtcCode == .success, let room = rtcRoom else {
                print("Join room failed")
                completion(.roomJoinError)
                return
            }
            
            // Publish audio/video stream
            var liveInfo: RCRTCLiveInfo?
            room.localUser.publishDefaultLiveStreams { success, code, info in
                liveInfo = info
                rtcCode = code
                semaphore.signal()
            }
            semaphore.wait()
            
            guard rtcCode == .success, liveInfo != nil else {
                print("Publish stream failed")
                completion(.streamPublishError)
                return
            }
            
            room.delegate = self
            RCLiveVideoLayout.liveInfo = liveInfo
            RCRTCEngine.sharedInstance().enableSpeaker(true)
            RCLiveVideoManager.shared.role = .broadcaster
            
            // Join chatroom
            var chatroomCode: RCErrorCode = .success
            RCChatRoomClient.sharedChatRoomClient().joinChatRoom(roomId, messageCount: -1) {
                semaphore.signal()
            } error: { status in
                chatroomCode = status
                semaphore.signal()
            }
            semaphore.wait()
            
            if chatroomCode != .success {
                print("Join chatroom failed")
                completion(.roomJoinError)
                return
            }
            
            completion(.success)
        }
    }

    func leaveRoom(completion: @escaping (RCLiveVideoCode) -> Void) {
        guard !isNotInRoom else {
            completion(.roomStateError)
            return
        }
        
        DispatchQueue.global().async {
            let group = DispatchGroup()
            
            // Leave seat if on it
            if self.currentRole == .broadcaster, let seat = RCLiveVideoManager.shared.seat(withUserId: self.currentUserId) {
                group.enter()
                seat.setValue("", forKey: "userId")
                RCLiveVideoSync.updateKV(seat.kvKey, value: seat.JSONString) { code in
                    group.leave()
                }
                RCRTCEngine.sharedInstance().defaultVideoStream().stopCapture()
            }
            
            // Leave RTC room
            group.enter()
            RCRTCEngine.sharedInstance().leaveRoom { isSuccess, code in
                group.leave()
            }
            
            group.wait()
            
            // Leave chatroom
            group.enter()
            var liveVideoCode: RCLiveVideoCode = .success
            RCChatRoomClient.sharedChatRoomClient().quitChatRoom(self.roomId) {
                group.leave()
            } error: { status in
                print("Leave chatroom failed: \(status)")
                liveVideoCode = .roomLeaveError
                group.leave()
            }
            
            group.wait()
            
            DispatchQueue.main.async {
                self.clear()
                completion(liveVideoCode)
            }
        }
    }

    // Helper Functions
    private func reloadVideoView() {
        RCLiveVideoManager.shared.videoView.reloadView()
    }

    private func clear() {
        self.PK = nil
        self.otherRoom = nil
        RCLiveVideoManager.shared.videoView.clear()
    }
    
    var currentUserId: String
