//
//  RCLiveVideoCode.swift
//  HXRTCWrapperLib
//
//  Created by hanxiaoqing on 2024/9/29.
//

import Foundation

enum RCLiveVideoCode: Int {
    /// 操作成功
    case success = 80000
    
    /// 加入房间失败
    case roomJoinError = 80101
    
    /// 离开房间失败
    case roomLeaveError = 80102
    
    /// 没有加入房间
    case roomStateError = 80103
    
    /// 发布直播流失败
    case streamPublishError = 80201
    
    /// 订阅分流失败
    case streamSubscribeError = 80202
    
    /// CDN订阅流失败
    case cdnStreamSubscribeError = 80203
    
    /// CDN设置流参数失败
    case cdnStreamConfigError = 80204
    
    /// 获取房间信息失败
    case roomInfoGetError = 80301
    
    /// 更新房间信息失败
    case roomInfoSetError = 80302
    
    /// 加入连麦失败
    case linkMicJoinError = 80401
    
    /// 离开连麦失败
    case linkMicLeaveError = 80402
    
    /// 连麦状态错误
    case linkMicStateError = 80403
    
    /// 角色切换失败，已被踢出房间
    case linkMicKickError = 80404
    
    /// 申请连麦失败
    case linkMicRequestError = 80411
    
    case linkMicRequestFull = 80412
    case linkMicRequestConnecting = 80413
    case linkMicRequestAcceptError = 80414
    case linkMicRequestRejectError = 80415
    
    /// 麦位
    case seatInvalid = 80501
    case seatIsFull = 80502
    case seatIsLock = 80503
    case seatUserExist = 80504
    
    /// 设置了相同的连麦类型
    case mixSame = 80601
    
    /// PK
    case pking = 80700
    case pkStateError = 80701
    case pkSendError = 80702
    case pkCancelError = 80703
    case pkResponseError = 80704
    case pkBeginError = 80705
    case pkQuitError = 80706
    
    case pkMuteOtherRoomError = 80707
    
    /// 信息发送失败
    case messageSendError = 81001
    
    /// 权限错误
    case permissionError = 82001
    
    /// 参数错误
    case parameterError = 83001
}
