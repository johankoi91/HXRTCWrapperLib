//
//  RCRTCVideoView.swift
//  HXRTCWrapperLib
//
//  Created by hanxiaoqing on 2024/10/15.
//


import UIKit
//import RongRTCLib

class RCLiveVideoAudienceView: UIView, RCLiveVideoView {
    
    weak var playerView: (UIView & RCSLivePlayer)?

    // 设置 playerView 并将其添加到视图中
    func setPlayerView(_ playerView: (UIView & RCSLivePlayer)?) {
        self.playerView?.removeFromSuperview()
        self.playerView = playerView
        guard let playerView = playerView else { return }
        setupPlayerFrame()
        addSubview(playerView)
    }

    // 设置 playerView 的布局
    func setupPlayerFrame() {
        guard let playerView = playerView else { return }
        playerView.frame = RCLiveVideoLayout.convert(CGRect(x: 0, y: 0, width: 1, height: 1), to: self)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        setupPlayerFrame()
    }

    func prepare(_ seat: RCLiveVideoSeat) {
        // 预留实现：准备视频播放
    }

    func reloadVideoView() {
        // 预留实现：重新加载视频视图
    }

    // 配置视频视图
#warning("TOBE")
    func setupVideoView(_ seats: [RCLiveVideoSeat]) { }

//        guard let userId = RCCoreClient.shared().currentUserInfo?.userId else { return }
//        if let seat = RCLiveVideoManager.shared.seat(withUserId: userId) {
//            return
//        }
//
//        let completion: (RCLiveVideoCode) -> Void = { code in
//        
//        }
//
//        guard let room = RCRTCEngine.sharedInstance().room else { return }
//
//        if !RCLiveVideoManager.shared.CDNInfo.responds(to: #selector(getter: RCLiveVideoCDNInfo.liveType)) {
//            subscribeLiveStream(room, completion: completion)
//            return
//        }
//
//        switch RCLiveVideoManager.shared.CDNInfo?.liveType {
//        case .MCU:
//            subscribeLiveStream(room, completion: completion)
//        case .innerCDN:
//            subscribeCDNStream(room, completion: completion)
//        case .thirdCDN:
//            subscribeThirdCDNStream(room, completion: completion)
//        @unknown default:
//            break
//        }
//}
    
    
#warning("TOBE")
    // 订阅内置 CDN 流
    //func subscribeCDNStream(_ room: RCRTCRoom, completion: @escaping (RCLiveVideoCode) -> Void) {

//        guard let stream = room.getCDNStream() else {
//            completion(.CDNStreamSubscribeError)
//            return
//        }
//
//        let videoView = RCRTCVideoView()
//        videoView.frameAnimated = false
//        playerView = videoView
//        stream.setVideoView(videoView)
//
//        setCDNStreamConfig(stream) { code in
//            if code == .success {
//                room.localUser.subscribeStream([stream], tinyStreams: []) { isSuccess, code in
//                    if code == .success {
//                        completion(.success)
//                    } else {
//                        completion(.CDNStreamSubscribeError)
//                    }
//                }
//            } else {
//                completion(.CDNStreamSubscribeError)
//            }
//        }
 //   }
#warning("TOBE")

    // 设置 CDN 流配置
    //  func setCDNStreamConfig(_ stream: RCRTCCDNInputStream, completion: @escaping (RCLiveVideoCode) -> Void) {

//        guard RCLiveVideoManager.shared().innerCDNConfigurable() else {
//            completion(.success)
//            return
//        }
//
//        let currentFPS = RCLiveVideoManager.shared.CDNInfo.innerCDNFPS()
//        let currentPreset = RCLiveVideoManager.shared.CDNInfo.innerCDNPreset()
//
//        let maxPreset = stream.getHighestResolution()
//        let maxFPS = stream.getHighestFPS()
//
//        let preset = min(currentPreset, maxPreset)
//        let FPS = min(currentFPS, maxFPS)
//
//        if preset == stream.getVideoResolution() && FPS == stream.getVideoFps() {
//            completion(.success)
//            return
//        }
//
//        stream.setVideoConfig(preset, fpsValue: FPS) { isSuccess, code in
//            if code == .success {
//                completion(.success)
//            } else {
//                completion(.CDNStreamConfigError)
//            }
//        }
//}
#warning("TOBE")
    // 订阅第三方 CDN 流
//    func subscribeThirdCDNStream(_ room: RCRTCRoom, completion: @escaping (RCLiveVideoCode) -> Void) {
//
//
//        guard let view = RCLiveVideoManager.shared.CDNInfo?.thirdCDNPlayer() else { return }
//        if playerView === view { return }
//        view.start(room.roomId)
//        playerView = view
//        completion(.success)
//    }

#warning("TOBE")
    // 订阅普通直播流
   //func subscribeLiveStream(_ room: RCRTCRoom, completion: @escaping (RCLiveVideoCode) -> Void) {

//        guard let streams = room.getLiveStreams() else {
//            completion(.StreamSubscribeError)
//            return
//        }
//
//        for stream in streams {
//            if let videoStream = stream as? RCRTCVideoInputStream {
//                let videoView = RCRTCVideoView()
//                videoView.frameAnimated = false
//                playerView = videoView
//                videoStream.setVideoView(videoView)
//                break
//            }
//        }
//
//        room.localUser.subscribeStream(streams, tinyStreams: []) { isSuccess, code in
//            if code == .success {
//                completion(.success)
//            } else {
//                completion(.StreamSubscribeError)
//            }
//        }
//      }

    deinit {
        playerView?.stop()
    }

}


