//
//  RCLiveVideoSeat.swift
//  HXRTCWrapperLib
//
//  Created by hanxiaoqing on 2024/10/15.
//

import Foundation
import RongChatRoom
import CoreGraphics

protocol RCLiveVideoSeatDelegate: AnyObject {
    /// 麦位锁定状态更新
    func seat(_ seat: RCLiveVideoSeat, didLock isLocked: Bool)
    
    /// 麦位静音状态更新
    func seat(_ seat: RCLiveVideoSeat, didMute isMuted: Bool)
    
    /// 麦位用户音频状态更新
    func seat(_ seat: RCLiveVideoSeat, didUserEnableAudio enable: Bool)
    
    /// 麦位用户视频状态更新
    func seat(_ seat: RCLiveVideoSeat, didUserEnableVideo enable: Bool)
    
    /// 麦位声音状态更新
    func seat(_ seat: RCLiveVideoSeat, didSpeak audioLevel: Int)
}

class RCLiveVideoSeat {

    weak var delegate: RCLiveVideoSeatDelegate?
    
    /// 麦位上的用户
    var userId: String
    
    /// 麦上用户是否开启音频
    private(set) var userEnableAudio: Bool
    
    /// 麦上用户是否开启视频
    private(set) var userEnableVideo: Bool
    
    /// 麦位是否静音
    private(set) var mute: Bool
    
    /// 麦位是否锁住
    private(set) var lock: Bool
    
    /// 麦位在视频中的相对位置
    private(set) var frame: CGRect
    
    /// 麦位序号
    private(set) var index: Int
    
    /// 控制本端订阅分流时是否采用小流，默认为 true
    var enableTiny: Bool = true
    
    init(frame: CGRect, index: Int) {
        self.userId = ""
        self.mute = false
        self.lock = false
        self.frame = frame
        self.index = index
        self.userEnableAudio = true
        self.userEnableVideo = true
    }
    
    init(userId: String, mute: Bool, lock: Bool, frame: CGRect, index: Int, userEnableAudio: Bool, userEnableVideo: Bool) {
        self.userId = userId
        self.mute = mute
        self.lock = lock
        self.frame = frame
        self.index = index
        self.userEnableAudio = userEnableAudio
        self.userEnableVideo = userEnableVideo
    }

    var currentUserId: String {
#warning("TOBE")
//      return RCRTCEngine.sharedInstance().room?.localUser.userId ?? ""
        return ""
    }


    func setLock(_ lock: Bool, completion: RCLVResult?) {
        self.lock = lock
        self.userId = ""
        self.userEnableAudio = true
        self.userEnableVideo = true
        RCLiveVideoSync.updateKV(key: self.kvKey(), value: self.toJSONString(), completion: completion)
        RCSLVDataSource.shared.seat(self, didLock: lock, withDelegate: self.delegate)
    }

    func setMute(_ mute: Bool, completion: RCLVResult?) {
        self.mute = mute
        RCLiveVideoSync.updateKV(key: kvKey(), value: self.toJSONString(), completion: completion)
        self.updateAudioStreamStateIfNeeded()
        RCSLVDataSource.shared.seat(self, didMute: mute, withDelegate: self.delegate)
    }

    func setUserEnableAudio(_ enable: Bool, completion: RCLVResult?) {
        self.userEnableAudio = enable
        RCLiveVideoSync.updateKV(key: kvKey(), value: self.toJSONString(), completion: completion)
        self.updateAudioStreamStateIfNeeded()
        RCSLVDataSource.shared.seat(self, didUserEnableAudio: enable, withDelegate: self.delegate)
    }

    func setUserEnableVideo(_ enable: Bool, completion: RCLVResult?) {
        self.userEnableVideo = enable
        RCLiveVideoSync.updateKV(key: kvKey(), value: self.toJSONString(), completion: completion)
        self.updateVideoStreamStateIfNeeded()
#warning("TOBE")
        //RCLiveVideoManager.shared.videoView?.updateLayout(with: [self])
//        RCLiveVideoLayout.layout()
    }

    func updateAudioStreamStateIfNeeded() {
        guard self.userId == self.currentUserId else { return }
#warning("TOBE")
//        if mute {
//            RCRTCEngine.sharedInstance().defaultAudioStream.setMicrophoneDisable(true)
//        } else {
//            RCRTCEngine.sharedInstance().defaultAudioStream.setMicrophoneDisable(!userEnableAudio)
//        }
    }

    func updateVideoStreamStateIfNeeded() {
        guard self.userId == self.currentUserId else { return }
#warning("TOBE")
//        if userEnableVideo {
//            RCRTCEngine.sharedInstance().defaultVideoStream.startCapture()
//        } else {
//            RCRTCEngine.sharedInstance().defaultVideoStream.stopCapture()
//        }
    }

    func setEnableTiny(_ enableTiny: Bool) {
        self.enableTiny = enableTiny
#warning("TOBE")
//        if RCLiveVideoManager.shared.role == .audience {
//            return
//        }
//        RCLiveVideoManager.shared.videoView?.updateLayout(withSeatInfos: [self])
    }

    func toJSONString() -> String {
        // Convert this object's properties to a JSON string as needed
        // Implement the necessary JSON serialization
        return ""
    }
}



extension RCLiveVideoSeat {
    
    static func seat(withJSON JSONString: String?) -> RCLiveVideoSeat? {
        guard let JSONString = JSONString else { return nil }
        
        guard let data = JSONString.data(using: .utf8),
              let JSON = try? JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed) as? [String: Any] else {
            print("RCLiveVideoSeat decode fail")
            return nil
        }
        
        let userId = JSON["userId"] as? String ?? ""
        let mute = (JSON["mute"] as? Bool) ?? false
        let lock = (JSON["lock"] as? Bool) ?? false
        let index = (JSON["index"] as? Int) ?? 0
        let frame = NSCoder.cgRect(for: JSON["frame"] as? String ?? "")
        let userEnableAudio = (JSON["userEnableAudio"] as? Bool) ?? true
        let userEnableVideo = (JSON["userEnableVideo"] as? Bool) ?? true
        
        return RCLiveVideoSeat(userId: userId, mute: mute, lock: lock, frame: frame, index: index, userEnableAudio: userEnableAudio, userEnableVideo: userEnableVideo)
    }
    
    func JSONString() -> String? {
        var dict = [String: Any]()
        dict["userId"] = self.userId
        dict["mute"] = self.mute
        dict["lock"] = self.lock
        dict["index"] = self.index
        dict["frame"] = NSCoder.string(for: self.frame)
        dict["userEnableAudio"] = self.userEnableAudio
        dict["userEnableVideo"] = self.userEnableVideo
        
        guard let data = try? JSONSerialization.data(withJSONObject: dict, options: .fragmentsAllowed) else {
            print("RCLiveVideoSeat encode fail")
            return nil
        }
        
        return String(data: data, encoding: .utf8)
    }
    
    
    func kvKey() -> String {
        return "\(RCLVRSeatInfoPreKey)\(index)"
    }
    
    
    func merge(_ seat: RCLiveVideoSeat?) {
        guard let seat = seat, seat.index == self.index else { return }
        
        self.userId = seat.userId
        
        if self.lock != seat.lock {
            self.lock = seat.lock
            RCSLVDataSource.shared.seat(self, didLock: seat.lock, withDelegate: self.delegate)
        }
        
        if self.mute != seat.mute {
            self.mute = seat.mute
            updateAudioStreamStateIfNeeded()
            RCSLVDataSource.shared.seat(self, didMute: seat.mute, withDelegate: self.delegate)
        }
        
        if self.userEnableAudio != seat.userEnableAudio {
            self.userEnableAudio = seat.userEnableAudio
            updateVideoStreamStateIfNeeded()
            RCSLVDataSource.shared.seat(self, didUserEnableAudio: seat.userEnableVideo, withDelegate: self.delegate)
        }
        
        if self.userEnableVideo != seat.userEnableVideo {
            self.userEnableVideo = seat.userEnableVideo
            updateVideoStreamStateIfNeeded()
            RCSLVDataSource.shared.seat(self, didUserEnableVideo: seat.userEnableVideo, withDelegate: self.delegate)
        }
    }
    
    func audioLevelDidChange(_ audioLevel: Int) {
        RCSLVDataSource.shared.seat(self, didSpeak: audioLevel, withDelegate: self.delegate)
    }
}
