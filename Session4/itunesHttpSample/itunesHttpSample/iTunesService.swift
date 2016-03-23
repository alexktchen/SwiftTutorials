//
//  itunesService.swift
//  itunesHttpSample
//
//  Created by Alex Chen on 2016/3/23.
//  Copyright © 2016年 Alex.Chen. All rights reserved.
//

import Foundation
import UIKit
import CoreData


protocol iTunesServiceDeleage {

}

class iTunesService: NSObject, NSURLSessionDownloadDelegate {

    class var sharedInstance: itunesService {
        struct Singleton {
            static let instance = itunesService()
        }
        return Singleton.instance
    }

    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    let serialQueue = dispatch_queue_create("com.Alex.Chen.imagesQueue", DISPATCH_QUEUE_SERIAL)

    func search(SearchText: String, searchResult: ([Music] -> Void)) {

        let url = NSURL(string: "https://itunes.apple.com/search?media=music&entity=song&term=\(SearchText)")

        let defaultSession = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
        let dataTask = defaultSession.dataTaskWithURL(url!) { data, response, error in

            if error == nil {

                var musics: [Music] = []
                let jsonObjects = JSON(data: data!)

                for var item in jsonObjects["results"].arrayValue {

                    var data: NSData = NSData()
                    let checkedUrl = NSURL(string: item["artworkUrl100"].stringValue)

                    dispatch_async(self.serialQueue) { () -> Void in

                        data = NSData(contentsOfURL: checkedUrl!)!

                        let music = NSEntityDescription.insertNewObjectForEntityForName("Music", inManagedObjectContext: self.managedObjectContext) as! Music

                        music.artistName = item["artistName"].stringValue
                        music.collectionCensoredName = item["collectionCensoredName"].stringValue
                        music.trackCensoredName = item["trackCensoredName"].stringValue
                        music.previewUrl = item["previewUrl"].stringValue
                        music.artworkUrl = data
                        musics.append(music)
                    }
                    print(item)
                }

                dispatch_async(dispatch_get_main_queue()) {
                    searchResult(musics)
                }
            }
        }
        dataTask.resume()
    }


    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didFinishDownloadingToURL location: NSURL) {
        //copy downloaded data to your documents directory with same names as source file

    }

    //this is to track progress
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
    }

    // if there is an error during download this will be called
    func URLSession(session: NSURLSession, task: NSURLSessionTask, didCompleteWithError error: NSError?) {

    }

    //method to be called to download
    func download(url: NSURL) {
        //download identifier can be customized. I used the "ulr.absoluteString"
        let sessionConfig = NSURLSessionConfiguration.backgroundSessionConfigurationWithIdentifier(url.absoluteString)
        let session = NSURLSession(configuration: sessionConfig, delegate: self, delegateQueue: nil)
        let task = session.downloadTaskWithURL(url)
        task.resume()
    }
}