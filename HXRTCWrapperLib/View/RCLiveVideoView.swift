//
//  RCLiveVideoView.swift
//  HXRTCWrapperLib
//
//  Created by hanxiaoqing on 2024/10/15.
//

import Foundation
protocol RCLiveVideoView: AnyObject {
    
    /// 连麦模式变化时，初始化视频视图
    func reloadVideoView()
    
    /// 准备视图
    /// - Parameter seat: 麦位信息
    func prepare(_ seat: RCLiveVideoSeat)
    
    /// 麦位发生变化时，更新视频布局
    /// - Parameter seats: 麦位信息数组
    func setupVideoView(_ seats: [RCLiveVideoSeat])
}
