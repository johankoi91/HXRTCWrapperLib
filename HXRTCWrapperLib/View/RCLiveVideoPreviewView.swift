//
//  File.swift
//  HXRTCWrapperLib
//
//  Created by hanxiaoqing on 2024/10/15.
//

import UIKit
//import RongRTCLib

class RCLiveVideoPreviewView: UIView {
    
    private var videoView: (any UIView & RCLiveVideoView)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .black
        self.clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Set the mask layer
        self.layer.mask = maskLayer()
        
        videoView?.frame = self.bounds
        if let delegate = RCSLVDataSource.shared.mixDelegate {
            for seat in RCLiveVideoManager.shared.seats {
                let frame = RCLiveVideoLayout.convert(seat.frame, to: self)
                delegate.liveVideoDidLayout(seat: seat, withFrame: frame)
            }
        }
        
    }

    func reloadView() {
        // Remove the existing video view
        videoView?.removeFromSuperview()
        videoView = nil
        if RCLiveVideoManager.shared.role == .audience {
            videoView = RCLiveVideoAudienceView()
        } else {
            videoView = RCLiveVideoBroadcastView()
        }
        
        videoView?.frame = self.bounds
        if let videoView = videoView {
            self.addSubview(videoView)
            videoView.reloadVideoView()
        }
    }

    func prepare(_ seat: RCLiveVideoSeat?) {
        guard let seat = seat else { return }
        videoView?.prepare(seat)
    }

    func updateLayout() {
        updateLayout(with: RCLiveVideoManager.shared.seats)
    }
    
    private func updateLayout(with seatInfos: [RCLiveVideoSeat]) {
        videoView?.setupVideoView(seatInfos)
        
        if let delegate = RCSLVDataSource.shared.mixDelegate {
            for seat in seatInfos {
                let frame = RCLiveVideoLayout.convert(seat.frame, to: self)
                delegate.liveVideoDidLayout(seat: seat, withFrame: frame)
            }
            
        }
        
        self.layer.mask = maskLayer()
        self.layoutIfNeeded()
    }

    private func maskLayer() -> CAShapeLayer {
        let shaperLayer = CAShapeLayer()
        shaperLayer.fillColor = UIColor.black.cgColor
        shaperLayer.frame = self.bounds
        
        let path = UIBezierPath()
        for seat in RCLiveVideoManager.shared.seats {
            guard seat.userId != nil, seat.userEnableVideo else { continue }
            let frame = RCLiveVideoLayout.convert(seat.frame, to: self)
            path.move(to: frame.origin)
            path.addLine(to: CGPoint(x: frame.maxX, y: frame.minY))
            path.addLine(to: CGPoint(x: frame.maxX, y: frame.maxY))
            path.addLine(to: CGPoint(x: frame.minX, y: frame.maxY))
            path.close()
        }
        shaperLayer.path = path.cgPath
        return shaperLayer
    }

    func clear() {
        videoView?.removeFromSuperview()
        videoView = nil
    }
}
