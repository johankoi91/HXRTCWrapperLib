//
//  File.swift
//  HXRTCWrapperLib
//
//  Created by hanxiaoqing on 2024/9/29.
//

import UIKit
//import RongRTCLib

class RCLiveVideoManager {
    
    // 用户 ID
    var userId: String {
        // Implement getter
        return "" // Placeholder
    }
    
    // 用户在房间中的角色，默认为观众
#warning("TOBE")
    var role: Int = 1
    
    // 房间 ID
    var roomUserId: String?
    
    // 房间连麦类型
    var mixType: RCLiveVideoMixType = .oneToOne {
        didSet {
            updateSeats()
        }
    }
    
    var mixSize: RCLiveVideoMixSize = .size640x360
    var canvasSize: CGSize {
        switch mixType {
        case .default, .oneToOne:
            return CGSize(width: 720, height: 1280)
        case .oneToSix:
            return CGSize(width: 930, height: 1260)
        case .gridTwo, .gridThree, .gridFour, .gridSeven, .gridNine:
            return CGSize(width: 720, height: 720)
        default:
            return RCSLVDataSource.shared.liveVideoPreviewSize()
        }
    }
    
    private(set) var seats: [RCLiveVideoSeat] = []
    
    // 申请上麦的用户，本地存储
    var requestUserIds: Set<String> = []
    
    // 邀请上麦的用户，本地存储
    var invitationUserIds: Set<String> = []
    
    weak var CDNInfo: RCSCDNDataSource?
    var videoView: RCLiveVideoPreviewView?
    
    static let shared = RCLiveVideoManager()
    
    private init() {
        // Initialization
        self.requestUserIds = []
        self.invitationUserIds = []
        self.mixType = .oneToOne
    }
    
    func liveUserIds() -> [String] {
        return seats.compactMap { $0.userId }
    }
    
    func availableSeat() -> Int? {
        for seat in seats {
            if !seat.lock && seat.userId.isEmpty {
                return seat.index
            }
        }
        return nil
    }
    
    func seat(withUserId userId: String) -> RCLiveVideoSeat? {
        guard !userId.isEmpty else { return nil }
        return seats.first { $0.userId == userId }
    }
    
    private func updateSeats() {
        // Update seats based on mixType
        var updatedSeats: [RCLiveVideoSeat] = []
        let frames = self.frames()
        
        for (index, frame) in frames.enumerated() {
            let seatInfo = RCLiveVideoSeat(frame: frame, index: index)
            updatedSeats.append(seatInfo)
        }
        
        if let firstSeat = updatedSeats.first {
            firstSeat.userId = roomUserId ?? ""
            if mixType == .oneToOne || mixType == .oneToSix {
                firstSeat.enableTiny = false
            }
        }
        
        self.seats = updatedSeats
    }
    
    private func frames() -> [CGRect] {
        switch mixType {
        case .default, .oneToOne:
            return [
                
                CGRect(x: 0, y: 0, width: 1, height: 1),
                CGRect(x: 0.6833, y: 0.6906, width: 0.3000, height: 0.1688)
            ]
        case .oneToSix:
            return [
                CGRect(x: 0, y: 0, width: 0.7742, height: 1),
                CGRect(x: 0.7742, y: 0, width: 0.2258, height: 0.1667),
                CGRect(x: 0.7742, y: 0.1667, width: 0.2258, height: 0.1667),
                CGRect(x: 0.7742, y: 0.3334, width: 0.2258, height: 0.1667),
                CGRect(x: 0.7742, y: 0.5000, width: 0.2258, height: 0.1667),
                CGRect(x: 0.7742, y: 0.6667, width: 0.2258, height: 0.1667),
                CGRect(x: 0.7742, y: 0.8335, width: 0.2258, height: 0.1667)
            ]
        case .gridTwo:
            return [
                CGRect(x: 0, y: 0, width: 0.5, height: 1),
                CGRect(x: 0.5, y: 0, width: 0.5, height: 1)
            ]
        case .gridThree:
            return [
                CGRect(x: 0.25, y: 0, width: 0.5, height: 0.5),
                CGRect(x: 0, y: 0.5, width: 0.5, height: 0.5),
                CGRect(x: 0.5, y: 0.5, width: 0.5, height: 0.5)
            ]
        case .gridFour:
            return [
                CGRect(x: 0, y: 0, width: 0.5, height: 0.5),
                CGRect(x: 0.5, y: 0, width: 0.5, height: 0.5),
                CGRect(x: 0, y: 0.5, width: 0.5, height: 0.5),
                CGRect(x: 0.5, y: 0.5, width: 0.5, height: 0.5)
            ]
        case .gridSeven:
            let length = 1.0 / 3
            return [
                CGRect(x: length * 0.0, y: length * 0.0, width: length, height: length),
                CGRect(x: length * 0.0, y: length * 1.0, width: length, height: length),
                CGRect(x: length * 1.0, y: length * 1.0, width: length, height: length),
                CGRect(x: length * 2.0, y: length * 1.0, width: length, height: length),
                CGRect(x: length * 0.0, y: length * 2.0, width: length, height: length),
                CGRect(x: length * 1.0, y: length * 2.0, width: length, height: length),
                CGRect(x: length * 2.0, y: length * 2.0, width: length, height: length)
            ]
        case .gridNine:
            let length = 1.0 / 3
            return [
                CGRect(x: length * 0.0, y: length * 0.0, width: length, height: length),
                CGRect(x: length * 1.0, y: length * 0.0, width: length, height: length),
                CGRect(x: length * 2.0, y: length * 0.0, width: length, height: length),
                CGRect(x: length * 0.0, y: length * 1.0, width: length, height: length),
                CGRect(x: length * 1.0, y: length * 1.0, width: length, height: length),
                CGRect(x: length * 2.0, y: length * 1.0, width: length, height: length),
                CGRect(x: length * 0.0, y: length * 2.0, width: length, height: length),
                CGRect(x: length * 1.0, y: length * 2.0, width: length, height: length),
                CGRect(x: length * 2.0, y: length * 2.0, width: length, height: length)
            ]
        default:
            return RCSLVDataSource.shared.liveVideoFrames() ?? [CGRect()]
        }
    }
    
    func clear() {
#warning("TOBE")
       // self.otherRoom = nil
        self.requestUserIds.removeAll()
        self.invitationUserIds.removeAll()
    }
#warning("TOBE")
//    private var otherRoom: RCRTCOtherRoom?
    
#warning("TOBE")
//    var remoteUserStreams: [String: [RCRTCInputStream]] {
//
//        var dict: [String: [RCRTCInputStream]] = [:]
//        let remoteUsers = RCRTCEngine.sharedInstance().room?.remoteUsers
//        let users = otherRoom?.remoteUsers ?? remoteUsers
//        
//        for user in users {
//            dict[user.userId] = user.remoteStreams
//        }
//        return dict
//    }
}
