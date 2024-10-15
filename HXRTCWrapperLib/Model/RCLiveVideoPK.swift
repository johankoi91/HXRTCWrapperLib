//
//  RCLiveVideoPK.swift
//  HXRTCWrapperLib
//
//  Created by hanxiaoqing on 2024/10/15.
//

import Foundation

class RCLiveVideoPK {

    var inviterUserId: String?
    var inviterRoomId: String?
    var inviteeUserId: String?
    var inviteeRoomId: String?

    init(inviterUserId: String?, inviterRoomId: String?, inviteeUserId: String?, inviteeRoomId: String?) {
        self.inviterUserId = inviterUserId
        self.inviterRoomId = inviterRoomId
        self.inviteeUserId = inviteeUserId
        self.inviteeRoomId = inviteeRoomId
    }

    func toJSON() -> String? {
        var dict = [String: Any]()
        if let inviterUserId = self.inviterUserId {
            dict["inviterUserId"] = inviterUserId
        }
        if let inviterRoomId = self.inviterRoomId {
            dict["inviterRoomId"] = inviterRoomId
        }
        if let inviteeUserId = self.inviteeUserId {
            dict["inviteeUserId"] = inviteeUserId
        }
        if let inviteeRoomId = self.inviteeRoomId {
            dict["inviteeRoomId"] = inviteeRoomId
        }

        if let data = try? JSONSerialization.data(withJSONObject: dict, options: .fragmentsAllowed) {
            return String(data: data, encoding: .utf8)
        }
        return nil
    }

    static func fromJSON(_ jsonString: String?) -> RCLiveVideoPK? {
        guard let jsonString = jsonString else { return nil }
        guard let data = jsonString.data(using: .utf8) else { return nil }

        if let dict = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] {
            let pkInfo = RCLiveVideoPK(inviterUserId: dict["inviterUserId"] as? String,
                                       inviterRoomId: dict["inviterRoomId"] as? String,
                                       inviteeUserId: dict["inviteeUserId"] as? String,
                                       inviteeRoomId: dict["inviteeRoomId"] as? String)
            return pkInfo
        }
        return nil
    }

    var description: String {
        return "inviterUserId is \(self.inviterUserId ?? ""), inviterRoomId is \(self.inviterRoomId ?? "")"
    }

    var roomId: String? {
        #warning("TOBE")
        return ""
    }

    var roomUserId: String? {
        return RCLiveVideoManager.shared.roomUserId
    }

    var otherRoomId: String? {
        return (self.inviteeRoomId == self.roomId) ? self.inviterRoomId : self.inviteeRoomId
    }

    var otherRoomUserId: String? {
        return (self.inviteeUserId == self.roomUserId) ? self.inviterUserId : self.inviteeUserId
    }
}
