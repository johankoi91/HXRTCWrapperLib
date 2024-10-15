//
//  File.swift
//  HXRTCWrapperLib
//
//  Created by hanxiaoqing on 2024/10/15.
//

import UIKit
//import RongRTCLib

class RCLiveVideoLayout: NSObject {
    
#warning("TOBE")
    
//    static var liveInfo: RCRTCLiveInfo? {
//        get {
//            return currentLiveInfo
//        }
//        set {
//            currentLiveInfo = newValue
//        }
//    }
//
//    private static var currentLiveInfo: RCRTCLiveInfo?

    // Convert frame from one view's coordinate system to another
    static func convert(_ frame: CGRect, to view: UIView) -> CGRect {
        // Canvas size
        let canvasSize = RCLiveVideoManager.shared.canvasSize
        
        let rx = floor(frame.origin.x * canvasSize.width) / canvasSize.width
        let ry = floor(frame.origin.y * canvasSize.height) / canvasSize.height
        let rw = floor(frame.size.width * canvasSize.width) / canvasSize.width
        let rh = floor(frame.size.height * canvasSize.height) / canvasSize.height

        // Virtual view size
        let viewW = view.bounds.size.width
        let viewH = viewW / canvasSize.width * canvasSize.height
        
        let x = rx * viewW
        let y = ry * viewH
        let w = rw * viewW
        let h = rh * viewH
        
        return CGRect(x: floor(x), y: floor(y), width: floor(w) + 1, height: floor(h) + 1)
    }

    // Layout with completion
    static func layout(completion: ((Bool) -> Void)? = nil) {
        print("Layout begins")
        layout { success in
            print(success ? "Layout success" : "Layout failed")
            completion?(success)
        }
    }

    private static func layout(completion: @escaping (Bool) -> Void) { }
#warning("TOBE")
 
}
