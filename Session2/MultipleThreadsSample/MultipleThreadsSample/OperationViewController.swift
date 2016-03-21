//
//  OperationViewController.swift
//  MultipleThreadsSample
//
//  Created by Alex Chen on 2016/3/21.
//  Copyright © 2016年 Alex.Chen. All rights reserved.
//

import UIKit

class OperationViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!

    var yPosition: CGFloat = 50.0
    var imageCount: CGFloat = 0.0
    let queue = NSOperationQueue()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func startDownloadButtonTouchDown(sender: AnyObject) {


        let time = NSDate().timeIntervalSince1970 * 1000

        let checkedUrl = NSURL(string: "https://www.shinobicontrols.com/media/28972/swift_logo.png?t=\(time)")


        let actInd : UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(0,0, 50, 50)) as UIActivityIndicatorView
        let img = UIImageView()

        actInd.center = img.center
        actInd.hidesWhenStopped = true
        actInd.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        img.addSubview(actInd)
        actInd.startAnimating()
        img.addSubview(actInd)
        let y: CGFloat = (self.yPosition * self.imageCount)
        img.frame = CGRectMake(10, y, 50, 50)
        self.imageCount++
        self.scrollView.addSubview(img)

        // crate NSBlockOperation
        let operation = NSBlockOperation(block: {
            let data = NSData(contentsOfURL: checkedUrl!)

            NSOperationQueue.mainQueue().addOperationWithBlock({

                img.image = UIImage(data: data!)
            })
        })

        operation.completionBlock = {
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                actInd.stopAnimating()
            }
        }

        // add NSBlockOperation to NSOperationQueue
        self.queue.addOperation(operation)
    }
}
