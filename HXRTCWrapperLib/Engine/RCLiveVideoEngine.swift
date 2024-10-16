//
//  File.swift
//  HXRTCWrapperLib
//
//  Created by hanxiaoqing on 2024/10/15.
//

import Foundation
import RongIMLibCore
import RongChatRoom
import AgoraRtcKit


class RCLiveVideoEngine: NSObject, RCIMClientReceiveMessageDelegate {
    
    let semaphore = DispatchSemaphore(value: 0)
    static let liveVideoLibName = "HXRTCWrapperLib"
    static let liveVideoLibVersion = "1.0"
    
    static let shared = RCLiveVideoEngine()
    
    let videoManager = RCLiveVideoManager.shared
    
    var agoraKit: AgoraRtcEngineKit!
    
    var roomId: String? {
        return RCLiveVideoSync.currentRoomId
    }
    
    var currentUserId: UInt = 0
    var token: String = ""
    
    var previewView: UIView? {
        RCLiveVideoManager.shared.videoView
    }
    
    var currentRole: AgoraClientRole {
        return RCLiveVideoManager.shared.role
    }
    
    var currentMixType: RCLiveVideoMixType {
        return RCLiveVideoManager.shared.mixType
    }
    
    var currentSeats: [RCLiveVideoSeat] {
        return RCLiveVideoManager.shared.seats
    }
    
    var liveVideoUserIds: [UInt] {
        return RCLiveVideoManager.shared.liveUserIds()
    }
    
    var delegate: RCLiveVideoDelegate? {
        return RCSLVDataSource.shared.delegate
    }
    
    var pkDelegate: RCLiveVideoPKDelegate? {
        return RCSLVDataSource.shared.pkDelegate
    }
    
    var mixDelegate: RCLiveVideoMixDelegate? {
        return RCSLVDataSource.shared.mixDelegate
    }
    
    var mixDataSource: RCLiveVideoMixDataSource? {
        return RCSLVDataSource.shared.mixDataSource
    }
    
    // 用户进出房间是否发送消息，默认 NO
    var enableInOutRoomEvent: Bool = false
    
    var pkInfo: RCLiveVideoPK? {
        return self.PK
    }
    
    private var PK: RCLiveVideoPK?
    
    
    var videoView: RCLiveVideoPreviewView? {
        return RCLiveVideoManager.shared.videoView
    }
    
    private override init() {
        super.init()
        setupDelegates()
    }
    
    // MARK: - Setup
    private func setupDelegates() {
        RCCoreClient.shared().add(self)
        RCChatRoomClient.shared().setChatRoomStatusDelegate(self)
        RCChatRoomClient.shared().setRCChatRoomKVStatusChangeDelegate(self)
        RCChatRoomClient.shared().memberDelegate = self
        
        let config = AgoraRtcEngineConfig()
        config.appId = ""
        config.areaCode = .CN
        config.channelProfile = .liveBroadcasting
        agoraKit = AgoraRtcEngineKit.sharedEngine(with: config, delegate: self)
        
        
        agoraKit.enableVideo()
        agoraKit.enableAudio()
        agoraKit.setVideoEncoderConfiguration(
            AgoraVideoEncoderConfiguration(size: CGSize(width: 720, height: 1080),
                                           frameRate: .fps15,
                                           bitrate: AgoraVideoBitrateStandard,
                                           orientationMode: .adaptative,
                                           mirrorMode: .auto))
    }
    
    
    // 房主准备直播，视频流回调
    func prepare() {
        videoManager.role = .broadcaster
        videoManager.roomUserId = currentUserId
        videoManager.mixType = .oneToOne
        
        videoView?.reloadView()
        videoView?.prepare(videoManager.seats.first)
        
        let videoCanvas = AgoraRtcVideoCanvas()
        videoCanvas.uid = currentUserId
        // the view to be binded
        videoCanvas.view = videoView
        videoCanvas.renderMode = .hidden
        agoraKit.setupLocalVideo(videoCanvas)
        agoraKit.startPreview()
        agoraKit.setDefaultAudioRouteToSpeakerphone(true)
        
    }
    
    // 房主开始或恢复直播
    func begin(roomId: String, completion: @escaping (RCLiveVideoCode) -> Void) {
        DispatchQueue.global().async {
            self.PK = nil
            
            self.agoraKit.setClientRole(self.currentRole)
            
            let option = AgoraRtcChannelMediaOptions()
            option.publishCameraTrack = true
            option.publishMicrophoneTrack = true
            option.clientRoleType = self.currentRole
            
            let result = self.agoraKit.joinChannel(byToken: self.token, channelId: roomId, uid: 0, mediaOptions: option)  { channel, uid, elapsed in
                self.semaphore.signal()
            }
            
            self.semaphore.wait()
            
            if result == 0 {
                print("Join room failed")
                completion(.roomJoinError)
            }
            
            // Join chatroom
            var chatroomCode: RCErrorCode = .RC_SUCCESS
            RCChatRoomClient.shared().joinChatRoom(roomId, messageCount: -1, extra: "") { res in
                self.semaphore.signal()
            } errorBlock: { code in
                chatroomCode = code
                self.semaphore.signal()
            }
            
            self.semaphore.wait()
            
            if chatroomCode != .RC_SUCCESS {
                completion(.roomJoinError)
                return
            }
            
            if chatroomCode != .RC_KEY_NOT_EXIST {
                completion(.roomInfoGetError)
                return
            }
            
            var dict = [String: String]()
            dict[RCLVRRoomUserIdKey] = "\(self.currentUserId)"
            dict[RCLVRRoomMixTypeKey] = "\(RCLiveVideoMixType.oneToOne.rawValue)"
            for (index, seatInfo) in self.videoManager.seats.enumerated() {
                let key = RCLVRSeatInfoPreKey + "\(index)"
                dict[key] = seatInfo.JSONString()
            }
            RCLiveVideoSync.updateKVs(entries: dict) {_ in }
            
            RCLiveVideoSync.currentRoomId = roomId
            
            completion(.success)
        }
    }
    
    
    
    func leaveRoom(completion: @escaping (RCLiveVideoCode) -> Void) {
        DispatchQueue.global().async {
            let group = DispatchGroup()
            
            // Leave seat if on it
            if self.currentRole == .broadcaster, let seat = self.videoManager.seat(withUserId: self.currentUserId) {
                group.enter()
                seat.userId = nil
                RCLiveVideoSync.updateKV(key: seat.kvKey, value: seat.JSONString() ?? "nil") { code in
                    group.leave()
                }
                self.agoraKit.disableAudio()
                self.agoraKit.disableVideo()
                self.agoraKit.stopPreview()
            }
            
            if let roomId = self.roomId {
                group.enter()
                RCChatRoomClient.shared().getChatRoomInfo(roomId, count: 0, order: RCChatRoomMemberOrder.chatRoom_Member_Asc, success: { chatRoomInfo in
                    var data = "\(self.currentUserId)"
                    data += RCLVRSegment
                    data += "\(chatRoomInfo.totalMemberCount - 1)"
                    RCLiveVideoSync.sendCommand(name: RCLVRCommandUserExitKey, data: data) { code in
                        group.leave()
                    }
                }, error: { status in
                    group.leave()
                })
            }
            
            // Leave RTC room
            group.enter()
            self.agoraKit.leaveChannel { stats in
                group.leave()
            }
            
            group.wait()
            
            var liveVideoCode: RCLiveVideoCode = .success
            
            // Leave chatroom
            if let roomId = self.roomId {
                group.enter()
                RCChatRoomClient.shared().quitChatRoom(roomId) {
                    group.leave()
                } error: { status in
                    print("Leave chatroom failed: \(status)")
                    liveVideoCode = .roomLeaveError
                    group.leave()
                }
            }
            
            group.wait()
            
            DispatchQueue.main.async {
                self.clear()
                completion(liveVideoCode)
            }
        }
    }
    
    
    private func clear() {
        self.PK = nil
        RCLiveVideoManager.shared.videoView.clear()
    }
    
}


extension RCLiveVideoEngine: AgoraRtcEngineDelegate {
    
}

extension RCLiveVideoEngine: RCChatRoomKVStatusChangeDelegate {
    func chatRoomKVDidSync(_ roomId: String) {
        
    }
    
    func chatRoomKVDidUpdate(_ roomId: String, entry: [String : String]) {
        
    }
    
    func chatRoomKVDidRemove(_ roomId: String, entry: [String : String]) {
        
    }
    
}

extension RCLiveVideoEngine: RCChatRoomStatusDelegate, RCChatRoomMemberDelegate {
    func onChatRoomJoining(_ chatroomId: String) {
        
    }
    
    func onChatRoomJoined(_ chatroomId: String, response: RCJoinChatRoomResponse) {
        
    }
    
    func onChatRoomJoined(_ chatroomId: String) {
        
    }
    
    func onChatRoomJoinFailed(_ chatroomId: String, errorCode: RCErrorCode) {
        
    }
    
    func onChatRoomReset(_ chatroomId: String) {
        
    }
    
    func onChatRoomQuited(_ chatroomId: String) {
        
    }
    
    func onChatRoomDestroyed(_ chatroomId: String, type: RCChatRoomDestroyType) {
        
    }
    
    /// RCChatRoomMemberDelegate
    func memberDidChange(_ members: [RCChatRoomMemberAction], inRoom roomId: String) {
        
    }
    
    func memberDidChange(_ actionModel: RCChatRoomMemberActionModel) {
        
    }
}
