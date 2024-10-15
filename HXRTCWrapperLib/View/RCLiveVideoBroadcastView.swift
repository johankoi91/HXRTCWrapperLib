//
//  File.swift
//  HXRTCWrapperLib
//
//  Created by hanxiaoqing on 2024/10/15.
//

import UIKit
//import RongRTCLib

class RCLiveVideoBroadcastView: UIView, RCLiveVideoView {

    private var videoViews: [Int: UIView] = [:]

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.videoViews = [:]
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        for seat in RCLiveVideoManager.shared.seats {
            let frame = RCLiveVideoLayout.convert(seat.frame, to: self)
            videoViews[seat.index]?.frame = frame
        }
    }

    func prepare(_ seat: RCLiveVideoSeat) {
#warning("TOBE")
//        let position = RCRTCEngine.sharedInstance().defaultVideoStream.cameraPosition
//        let needMirror = position == .front
//        RCRTCEngine.sharedInstance().defaultVideoStream.isEncoderMirror = needMirror
//        
//        RCRTCEngine.sharedInstance().defaultVideoStream.setVideoView(videoViews[seat.index])
//        
//        if seat.userEnableVideo {
//            RCRTCEngine.sharedInstance.defaultVideoStream.startCapture()
//        } else {
//            RCRTCEngine.sharedInstance.defaultVideoStream.stopCapture()
//        }
//
//        let isMicDisable = seat.mute || !seat.userEnableAudio
//        RCRTCEngine.sharedInstance.defaultAudioStream.setMicrophoneDisable(isMicDisable)
//        RCRTCEngine.sharedInstance.defaultAudioStream.setAudioQuality(.music, scenario: .musicChatRoom)

        
    }

    func reloadVideoView() {
        for view in videoViews.values {
            view.removeFromSuperview()
        }
#warning("TOBE")
//        var newVideoViews: [Int: RCRTCVideoView] = [:]
//        for seat in RCLiveVideoManager.shared.seats {
//            let frame = RCLiveVideoLayout.convert(seat.frame, to: self)
//            let videoView = RCRTCVideoView()
//            videoView.fillMode = .aspectFill
//            videoView.backgroundColor = .clear
//            videoView.frameAnimated = false
//            videoView.frame = frame
//            self.addSubview(videoView)
//            newVideoViews[seat.index] = videoView
//        }
//        self.videoViews = newVideoViews
    }

    func setupVideoView(_ seats: [RCLiveVideoSeat]) {
#warning("TOBE")
//        guard let localUser = RCRTCEngine.sharedInstance().room?.localUser else { return }
//        
//        for seat in seats {
//            let videoView = videoViews[seat.index]
//            if seat.userId == localUser.userId {
//                
//            }
//            let hidden = seat.userId.isEmpty || !seat.userEnableVideo
//            videoView?.isHidden = hidden
//        }
//
//        let userStreams = RCLiveVideoManager.shared.remoteUserStreams
//        var avStreams: [RCRTCInputStream] = []
//        var tinyStreams: [RCRTCInputStream] = []
//        
//        for seat in seats {
//            guard !seat.userId.isEmpty else { continue }
//            
//            if let streams = userStreams[seat.userId] {
//                for stream in streams {
//                    if let videoStream = stream as? RCRTCVideoInputStream {
//                        if seat.enableTiny {
//                            tinyStreams.append(videoStream)
//                        } else {
//                            avStreams.append(videoStream)
//                        }
//                        videoStream.setVideoView(videoViews[seat.index])
//                    } else if !seat.mute || seat.userEnableAudio {
//                        if seat.enableTiny {
//                            tinyStreams.append(stream)
//                        } else {
//                            avStreams.append(stream)
//                        }
//                    }
//                }
//            }
//        }
//        
// 
//        
//        if avStreams.isEmpty && tinyStreams.isEmpty {
//            return
//        }
//        
//        localUser.subscribeStream(avStreams, tinyStreams: tinyStreams) { isSuccess, code in
//            if code == .success {
//                
//            } else {
//               
//            }
//        }
    }

    deinit {
        print("view dealloc")
    }
}

