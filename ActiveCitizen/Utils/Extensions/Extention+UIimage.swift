//
//  Extention+UIimage.swift
//  ActiveCitizen
//
//  Created by Sergey on 22.02.2021.
//  Copyright © 2021 Novotorica. All rights reserved.
//
import UIKit
import Kingfisher


extension String {
    func setImageForTypeActivity(type:ActivityType) -> String {
        var imageName: String
        switch type {
        case .WALKING:
            imageName = "iconWorkoutWalking"       //
        case .RUNNING:
            imageName = "iconRunningMan"           //
        case .ON_BICYCLE:
            imageName = "iconBicycleDriver"        //
        case .SKATES:
            imageName = "iconWorkoutWinterSkating" //
        case .SKI:
            imageName = "iconWorkoutSkiing"        //
        case .WALK_IN_PLACE:
            imageName = "iconWorkoutHomeWalking"   //
        case .RUN_IN_PLACE:
            imageName = "iconWorkoutHomeRunning"   //
        default:
            imageName = "iconWorkoutHomeRunning"
        }
        return imageName
    }
}
extension UIImageView {
    func getImageByURL(url: URL) {
        let processor = DownsamplingImageProcessor(size: CGSize(width: self.frame.size.width, height: self.frame.size.height))
        self.kf.cancelDownloadTask()
        self.kf.setImage(with: url, options: [.processor(processor)])
    }
}
