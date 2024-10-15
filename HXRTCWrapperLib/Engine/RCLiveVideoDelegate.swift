//
//  RCLiveVideoDelegate.swift
//  HXRTCWrapperLib
//
//  Created by hanxiaoqing on 2024/9/29.
//

import Foundation
import RongIMLibCore

protocol RCLiveVideoDelegate: RCSProtocol {
    func roomInfoDidSync()
    func roomInfoDidUpdate(key: String, value: String)
    func onUserUpdate(joinUserIds: [String], exitUserIds: [String])
    func userDidEnter(userId: String, withUserCount count: Int)
    func userDidExit(userId: String, withUserCount count: Int)
    
    func userDidKickOut(userId: String, byOperator operatorId: String)
    func liveVideoUserDidUpdate(userIds: [String])
    func liveVideoRequestDidChange()
    func liveVideoRequestDidAccept()
    func liveVideoRequestDidReject()
    func liveVideoInvitationDidReceive(inviter: String, atIndex index: Int)
    func liveVideoInvitationDidCancel()
    func liveVideoInvitationDidAccept(invitee: String)
    func liveVideoInvitationDidReject(invitee: String)
    func liveVideoDidBegin(code: RCLiveVideoCode)
    func liveVideoDidFinish(reason: RCLiveVideoFinishReason)
    func messageDidReceive(message: RCMessage)
    func network(delay: Int)
#warning("TOBE")
//    func didOutputFrame(frame: RCRTCVideoFrame) -> RCRTCVideoFrame?
//    func didReportFirstFrame(stream: RCRTCInputStream, mediaType: RCRTCMediaType)
    func roomDidClosed()
    func roomMixTypeDidChange(mixType: RCLiveVideoMixType)
}

protocol RCLiveVideoPKDelegate: RCSProtocol {
    func didReceivePKInvitation(fromRoom inviterRoomId: String, byUser inviterUserId: String)
    func didCancelPKInvitation(fromRoom inviterRoomId: String, byUser inviterUserId: String)
    func didAcceptPKInvitation(fromRoom inviteeRoomId: String, byUser inviteeUserId: String)
    func didRejectPKInvitation(fromRoom inviteeRoomId: String, byUser inviteeUserId: String, reason: String)
    func didBeginPK(code: RCLiveVideoCode)
    func didFinishPK(code: RCLiveVideoCode)
}

protocol RCLiveVideoMixDataSource: RCSProtocol {
    func liveVideoPreviewSize() -> CGSize
    func liveVideoFrames() -> [CGRect]
    func fps() -> Int
    func bitrate() -> Int
}

protocol RCLiveVideoMixDelegate: RCSProtocol {
    func liveVideoDidLayout(seat: RCLiveVideoSeat, withFrame frame: CGRect)
#warning("TOBE")
//    func roomMixConfigWillUpdate(config: RCRTCMixConfig)
}

protocol RCSCDNDataSource: RCSProtocol {
    func liveType() -> RCSLiveType
#warning("TOBE")
//    func innerCDNFPS() -> RCRTCVideoFPS?
//    func innerCDNPreset() -> RCRTCVideoSizePreset?
    func thirdCDNPlayer() -> (UIView & RCLiveVideoView)?
}
