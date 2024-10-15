//
//  RCSLVDataSource.swift
//  HXRTCWrapperLib
//
//  Created by hanxiaoqing on 2024/9/29.
//

import Foundation
//import RongRTCLib
import RongIMLibCore


func RCSRunOnMainQueue(_ block: @escaping () -> Void) {
    if Thread.isMainThread {
        block()
    } else {
        DispatchQueue.main.async {
            block()
        }
    }
}

import Foundation

class RCSLVDataSource: NSObject {

    static let shared = RCSLVDataSource()

    weak var delegate: RCLiveVideoDelegate?
    weak var pkDelegate: RCLiveVideoPKDelegate?
    weak var mixDelegate: RCLiveVideoMixDelegate?
    weak var mixDataSource: RCLiveVideoMixDataSource?

    private override init() {}

    func clean() {
        delegate = nil
        pkDelegate = nil
        mixDelegate = nil
        mixDataSource = nil
    }

    private func RCSRunOnMainQueue(_ block: @escaping () -> Void) {
        if Thread.isMainThread {
            block()
        } else {
            DispatchQueue.main.async {
                block()
            }
        }
    }


    func roomInfoDidSync() {
        RCSRunOnMainQueue {
            self.delegate?.roomInfoDidSync()
        }
    }

    func roomInfoDidUpdate(key: String, value: String) {
        RCSRunOnMainQueue {
            self.delegate?.roomInfoDidUpdate(key: key, value: value)
        }
    }

    func onUserUpdate(joinUserIds: [String], exitUserIds: [String]) {
        RCSRunOnMainQueue {
            self.delegate?.onUserUpdate(joinUserIds: joinUserIds, exitUserIds: exitUserIds)
        }
    }

    // Deprecated compatibility
    @available(*, deprecated)
    func userDidEnter(userId: String, withUserCount count: Int) {
        RCSRunOnMainQueue {
            self.delegate?.userDidEnter(userId: userId, withUserCount: count)
        }
    }

    @available(*, deprecated)
    func userDidExit(userId: String, withUserCount count: Int) {
        RCSRunOnMainQueue {
            self.delegate?.userDidExit(userId: userId, withUserCount: count)
        }
    }

    func userDidKickOut(userId: String, byOperator operatorId: String) {
        RCSRunOnMainQueue {
            self.delegate?.userDidKickOut(userId: userId, byOperator: operatorId)
        }
    }

    func liveVideoUserDidUpdate(userIds: [String]) {
        RCSRunOnMainQueue {
            self.delegate?.liveVideoUserDidUpdate(userIds: userIds)
        }
    }

    func liveVideoRequestDidChange() {
        RCSRunOnMainQueue {
            self.delegate?.liveVideoRequestDidChange()
        }
    }

    func liveVideoRequestDidAccept() {
        RCSRunOnMainQueue {
            self.delegate?.liveVideoRequestDidAccept()
        }
    }

    func liveVideoRequestDidReject() {
        RCSRunOnMainQueue {
            self.delegate?.liveVideoRequestDidReject()
        }
    }

    func liveVideoInvitationDidReceive(inviter: String, atIndex index: Int) {
        RCSRunOnMainQueue {
            self.delegate?.liveVideoInvitationDidReceive(inviter: inviter, atIndex: index)
        }
    }

    func liveVideoInvitationDidCancel() {
        RCSRunOnMainQueue {
            self.delegate?.liveVideoInvitationDidCancel()
        }
    }

    func liveVideoInvitationDidAccept(invitee: String) {
        RCSRunOnMainQueue {
            self.delegate?.liveVideoInvitationDidAccept(invitee: invitee)
        }
    }

    func liveVideoInvitationDidReject(invitee: String) {
        RCSRunOnMainQueue {
            self.delegate?.liveVideoInvitationDidReject(invitee: invitee)
        }
    }

    func liveVideoDidBegin(code: RCLiveVideoCode) {
        RCSRunOnMainQueue {
            self.delegate?.liveVideoDidBegin(code: code)
        }
    }

    func liveVideoDidFinish(reason: RCLiveVideoFinishReason) {
        RCSRunOnMainQueue {
            self.delegate?.liveVideoDidFinish(reason: reason)
        }
    }

    func messageDidReceive(message: RCMessage) {
        RCSRunOnMainQueue {
            self.delegate?.messageDidReceive(message: message)
        }
    }

    func network(delay: Int) {
        RCSRunOnMainQueue {
            self.delegate?.network(delay: delay)
        }
    }

#warning("TOBE")
//    func didOutputFrame(frame: RCRTCVideoFrame) -> RCRTCVideoFrame {
//        return delegate?.didOutputFrame(frame: frame) ?? frame
//    }
//
//    func didReportFirstFrame(stream: RCRTCInputStream, mediaType: RCRTCMediaType) {
//        RCSRunOnMainQueue {
//            self.delegate?.didReportFirstFrame(stream: stream, mediaType: mediaType)
//        }
//    }

    func roomDidClosed() {
        RCSRunOnMainQueue {
            self.delegate?.roomDidClosed()
        }
    }

    func roomMixTypeDidChange(mixType: RCLiveVideoMixType) {
        RCSRunOnMainQueue {
            self.delegate?.roomMixTypeDidChange(mixType: mixType)
        }
    }

//    func didOutputSampleBuffer(_ sampleBuffer: CMSampleBuffer?) -> CMSampleBuffer? {
//        delegate?.didout
//        return delegate?.didOutputSampleBuffer(sampleBuffer) ?? sampleBuffer
//    }

    // MARK: - RCLiveVideoPKDelegate
    func didReceivePKInvitation(from inviterRoomId: String, byUser inviterUserId: String) {
        RCSRunOnMainQueue {
            self.pkDelegate?.didReceivePKInvitation(fromRoom: inviterRoomId, byUser: inviterUserId)
        }
    }

    func didCancelPKInvitation(from inviterRoomId: String, byUser inviterUserId: String) {
        RCSRunOnMainQueue {
            self.pkDelegate?.didCancelPKInvitation(fromRoom: inviterRoomId, byUser: inviterUserId)
        }
    }

    func didAcceptPKInvitation(from inviteeRoomId: String, byUser inviteeUserId: String) {
        RCSRunOnMainQueue {
            self.pkDelegate?.didAcceptPKInvitation(fromRoom: inviteeRoomId, byUser: inviteeUserId)
        }
    }

    func didRejectPKInvitation(from inviteeRoomId: String, byUser inviteeUserId: String, reason: String) {
        RCSRunOnMainQueue {
            self.pkDelegate?.didRejectPKInvitation(fromRoom: inviteeRoomId, byUser: inviteeUserId, reason: reason)
        }
    }

    func didBeginPK(code: RCLiveVideoCode) {
        RCSRunOnMainQueue {
            self.pkDelegate?.didBeginPK(code: code)
        }
    }

    func didFinishPK(code: RCLiveVideoCode) {
        RCSRunOnMainQueue {
            self.pkDelegate?.didFinishPK(code: code)
        }
    }

    // MARK: - RCLiveVideoMixDelegate
    func liveVideoDidLayout(seat: RCLiveVideoSeat, withFrame frame: CGRect) {
        mixDelegate?.liveVideoDidLayout(seat: seat, withFrame: frame)
    }

#warning("TOBE")
//    func roomMixConfigWillUpdate(config: RCRTCMixConfig) {

//        RCSRunOnMainQueue {
//            self.mixDelegate?.roomMixConfigWillUpdate(config: config)
//        }
  //  }

    // MARK: - RCLiveVideoMixDataSource
    func liveVideoPreviewSize() -> CGSize {
        return mixDataSource?.liveVideoPreviewSize() ?? CGSize(width: 0, height: 0)
    }
    
    func liveVideoFrames() -> [CGRect]? {
            guard let mixDataSource = mixDataSource else {
                assertionFailure("liveVideoFrames need implementation")
                return nil
            }
            return mixDataSource.liveVideoFrames()
        }

        func fps() -> Int {
            return mixDataSource?.fps() ?? 15
        }

        func bitrate() -> Int {
            return mixDataSource?.bitrate() ?? 2200
        }

        // MARK: - About RCLiveVideoSeatDelegate

        func seat(_ seat: RCLiveVideoSeat, didLock isLocked: Bool, withDelegate delegate: RCLiveVideoSeatDelegate?) {
            delegate?.seat(seat, didLock: seat.lock)
        }

        func seat(_ seat: RCLiveVideoSeat, didMute isMuted: Bool, withDelegate delegate: RCLiveVideoSeatDelegate?) {
            delegate?.seat(seat, didMute: seat.mute)
        }

        func seat(_ seat: RCLiveVideoSeat, didUserEnableAudio enable: Bool, withDelegate delegate: RCLiveVideoSeatDelegate?) {
            delegate?.seat(seat, didUserEnableAudio: enable)
        }

        func seat(_ seat: RCLiveVideoSeat, didUserEnableVideo enable: Bool, withDelegate delegate: RCLiveVideoSeatDelegate?) {
            delegate?.seat(seat, didUserEnableVideo: enable)
        }

        func seat(_ seat: RCLiveVideoSeat, didSpeak audioLevel: Int, withDelegate delegate: RCLiveVideoSeatDelegate?) {
            delegate?.seat(seat, didSpeak: audioLevel)
        }
}
