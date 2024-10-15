//
//  File.swift
//  HXRTCWrapperLib
//
//  Created by hanxiaoqing on 2024/10/15.
//

import Foundation

protocol RCSLivePlayer: RCSProtocol {
    
    /// 开始播放
    /// - Parameter roomId: 房间 ID
    func start(_ roomId: String)
    
    /// 停止播放
    func stop()
}
