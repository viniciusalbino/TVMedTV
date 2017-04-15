//
//  VideoPlayerController.swift
//  TVMed
//
//  Created by Vinicius de Moura Albino on 15/04/17.
//  Copyright © 2017 tvMed. All rights reserved.
//

import Foundation
import UIKit
import AVKit

class VideoPlayerController: AVPlayerViewController, AVPlayerViewControllerDelegate {
    
    func loadVideo(url: String) {
        player = AVPlayer(url: URL(string: url)!)
        player?.play()
    }
}
