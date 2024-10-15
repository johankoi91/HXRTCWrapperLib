//
//  RCLiveVideoDefine.swift
//  HXRTCWrapperLib
//
//  Created by hanxiaoqing on 2024/9/29.
//

import Foundation


typealias RCLVResult = (RCLiveVideoCode) -> Void

enum RCLiveVideoMixType: Int {
    case `default` = 0
    case oneToOne
    case oneToSix
    case gridTwo
    case gridThree
    case gridFour
    case gridSeven
    case gridNine
    case custom
}

enum RCLiveVideoMixSize: Int {
    case size640x360
    case size1280x720
    case size1920x1080
}

enum RCLiveVideoFinishReason: Int {
    case unknown
    case leave
    case kick
    case mix
}

enum RCLiveVideoPKResponse: Int {
    case accept
    case reject
    case ignore
    case busy
}

enum RCSLiveType: Int {
    case mcu // Default low-latency live stream
    case innerCDN // Built-in CDN
    case thirdCDN // Third-party CDN
}

