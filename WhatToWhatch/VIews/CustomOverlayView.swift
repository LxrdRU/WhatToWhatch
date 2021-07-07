//
//  CustomOverlayView.swift
//  WhatToWhatch
//
//  Created by Andrey Markov on 2021-07-06.
//

import UIKit
import Koloda

private let overlayRightImageName = "rightOverlayImage"
private let overlayLeftImageName = "leftOverlayImage"

class CustomOverlayView: OverlayView {

    @IBOutlet lazy var overlayImageView: UIImageView! = {
        [unowned self] in
        
        var imageView = UIImageView(frame: superview!.bounds)
        imageView.contentMode = .scaleAspectFill
        self.addSubview(imageView)
        
        return imageView
        }()
    
    override var overlayState: SwipeResultDirection?  {
        didSet {
            switch overlayState {
            case .left? :
                overlayImageView.image = UIImage(named: overlayLeftImageName)
            case .right? :
                overlayImageView.image = UIImage(named: overlayRightImageName)
            default:
                overlayImageView.image = nil
            }
            
        }
    }

}
