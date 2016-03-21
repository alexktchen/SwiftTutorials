//
//  CollectionViewController.swift
//  MultipleThreadsSample
//
//  Created by Alex Chen on 2016/3/20.
//  Copyright © 2016年 Alex.Chen. All rights reserved.
//

import UIKit

class CollectionViewController: UICollectionViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }



    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 1000
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let reuseIdentifier = "CollectionCell"
        let cell: UICollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath)

        cell.backgroundColor = UIColor.redColor()

        if let imageView = cell.viewWithTag(101) as? UIImageView {
            downloadImage { (img) -> Void in
                imageView.image = img
            }
        }
        return cell
    }

    func downloadImage(image: UIImage -> Void) {

        let checkedUrl = NSURL(string: "https://www.shinobicontrols.com/media/28972/swift_logo.png")

        /*
        // Concurrent Dispatch Queue
        let globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)

        dispatch_async(globalQueue) { () -> Void in

            let data = NSData(contentsOfURL: checkedUrl!)

            dispatch_async(dispatch_get_main_queue(), {
                image(UIImage(data: data!)!)
            })
        }

        let mainqueue = dispatch_get_main_queue()

        dispatch_async(mainqueue) { () -> Void in

            let data = NSData(contentsOfURL: checkedUrl!)

            dispatch_async(dispatch_get_main_queue(), {
                image(UIImage(data: data!)!)
            })
        }*/

        /*
        //Serial Dispatch Queue 一次只執行一個任務
        let serialQueue = dispatch_queue_create("com.Alex.Chen.imagesQueue", DISPATCH_QUEUE_SERIAL)

        dispatch_async(serialQueue) { () -> Void in

            let data = NSData(contentsOfURL: checkedUrl!)
            
            dispatch_async(dispatch_get_main_queue(), {
                image(UIImage(data: data!)!)
            })

        }*/
    }
}
