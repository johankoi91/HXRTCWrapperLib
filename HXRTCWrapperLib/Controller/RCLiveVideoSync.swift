//
//  File.swift
//  HXRTCWrapperLib
//
//  Created by hanxiaoqing on 2024/9/29.
//

import Foundation
import RongChatRoom


class RCLiveVideoSync {
    
    static var currentRoomId: String?
    
    class func updateKV(key: String, value: String, completion: RCLVResult? = nil) {
        updateKV(key: key, value: value, autoDelete: false, completion: completion)
    }
    
    class func updateKV(key: String, value: String, autoDelete: Bool, completion: RCLVResult?) {
        guard let roomId = self.currentRoomId else {
            completion?(.roomStateError)
            return
        }
        RCChatRoomClient.shared().forceSetChatRoomEntry(roomId, key: key, value: value, sendNotification: false, autoDelete: autoDelete, notificationExtra: "") {
            DispatchQueue.main.async {
                completion?(.success)
            }
        } error: { errorCode in
            DispatchQueue.main.async {
                completion?(.roomInfoSetError)
            }
        }
    }
    
    class func updateKVs(entries: [String: String], completion: RCLVResult?) {
        
        guard let roomId = self.currentRoomId else {
            completion?(.roomStateError)
            return
        }
        RCChatRoomClient.shared().setChatRoomEntries(roomId, entries: entries, isForce: true, autoDelete: false) {
            DispatchQueue.main.async {
                completion?(.success)
            }
        } error: { errorCode, _ in
            DispatchQueue.main.async {
                completion?(.roomInfoSetError)
            }
        }
    }
    
    class func removeKV(key: String, completion: RCLVResult? = nil) {
        guard let roomId = currentRoomId else {
            completion?(.roomStateError)
            return
        }
        RCChatRoomClient.shared().forceRemoveChatRoomEntry(roomId, key: key, sendNotification: false, notificationExtra: "") {
            DispatchQueue.main.async {
                completion?(.success)
            }
        } error: { errorCode in
            DispatchQueue.main.async {
                completion?(.roomInfoSetError)
            }
        }
    }
    
    class func removeKVs(keys: [String], completion: RCLVResult?) {
        guard let roomId = self.currentRoomId else {
            completion?(.roomStateError)
            return
        }
        RCChatRoomClient.shared().removeChatRoomEntries(roomId, keys: keys, isForce: true) {
            DispatchQueue.main.async {
                completion?(.success)
            }
        } error: { errorCode, _ in
            DispatchQueue.main.async {
                completion?(.roomInfoSetError)
            }
        }
    }
    
    class func sendCommand(name: String, data: String, completion: RCLVResult? = nil) {
        let message = RCCommandMessage(name: name, data: data)
        sendMessage(content: message, completion: completion)
    }
    
    class func sendMessage(content: RCMessageContent, completion: RCLVResult?) {
        guard let roomId = currentRoomId else {
            completion?(.roomStateError)
            return
        }
        RCCoreClient.shared().sendMessage(.ConversationType_CHATROOM, targetId: roomId, content: content, pushContent: "", pushData: "", success: { messageId in
            DispatchQueue.main.async {
                completion?(.success)
            }
        }, error: { errorCode, _ in
            DispatchQueue.main.async {
                completion?(.messageSendError)
            }
        })
    }
    
    class func sendCommand(to userId: String, name: String, data: String, completion: RCLVResult? = nil) {
        let message = RCCommandMessage(name: name, data: data)
        sendMessage(to: userId, content: message, completion: completion)
    }
    
    class func sendMessage(to userId: String, content: RCMessageContent, completion: RCLVResult?) {
        guard let roomId = currentRoomId else {
            completion?(.roomStateError)
            return
        }
        RCCoreClient.shared().sendMessage(.ConversationType_PRIVATE, targetId: userId, content: content, pushContent: "", pushData: "", success: { messageId in
            DispatchQueue.main.async {
                completion?(.success)
            }
        }, error: { errorCode, _ in
            DispatchQueue.main.async {
                completion?(.messageSendError)
            }
        })
    }
}
