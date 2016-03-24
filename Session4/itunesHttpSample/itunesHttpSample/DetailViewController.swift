//
//  DetailViewController.swift
//  itunesHttpSample
//
//  Created by Alex Chen on 2016/3/23.
//  Copyright © 2016年 Alex.Chen. All rights reserved.
//

import UIKit
import AVFoundation

class DetailViewController: UIViewController, iTunesServiceDeleage {

    @IBOutlet weak var detailDescriptionLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!

    var previewUrl: String?

     var audioPlayer = AVAudioPlayer()
    
    var detailItem: AnyObject? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }

    func configureView() {
        // Update the user interface for the detail item.
        if let detail = self.detailItem {
            if let label = self.detailDescriptionLabel {
                label.text = detail.valueForKey("timeStamp")!.description
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
        iTunesService.sharedInstance.delegate = self
        iTunesService.sharedInstance.download(NSURL(string: self.previewUrl!)!)
    }

    override func viewDidDisappear(animated: Bool) {
        self.audioPlayer.stop()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func downloadProgress(progress: Float) {

        self.progressView.progress = progress
    }

    func didFinishDownloading(url: NSURL) {
        do{
            try audioPlayer = AVAudioPlayer(contentsOfURL: url) //AVAudioPlayer(contentsOfURL: url, error: &error)
            audioPlayer.prepareToPlay()
            audioPlayer.play()
        } catch {
            print(error)
        }
    }
}

