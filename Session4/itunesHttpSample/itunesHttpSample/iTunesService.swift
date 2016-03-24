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

    func downloadProgress(progress: Float)
    func didFinishDownloading(url: NSURL)
}

class iTunesService: NSObject, NSURLSessionDownloadDelegate {

    class var sharedInstance: iTunesService {
        struct Singleton {
            static let instance = iTunesService()
        }
        return Singleton.instance
    }

    var delegate: iTunesServiceDeleage?

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

    lazy var downloadsSession: NSURLSession = {
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: configuration, delegate: self, delegateQueue: nil)
        return session
    }()

    //method to be called to download
    func download(url: NSURL) {

        let task = downloadsSession.downloadTaskWithURL(url)
        task.resume()
    }

    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didFinishDownloadingToURL location: NSURL) {


        if let originalURL = downloadTask.originalRequest?.URL?.absoluteString,
            destinationURL = localFilePathForUrl(originalURL) {

                print(destinationURL)

                // 2
                let fileManager = NSFileManager.defaultManager()
                do {
                    try fileManager.removeItemAtURL(destinationURL)
                } catch {
                    // Non-fatal: file probably doesn't exist
                }
                do {
                    try fileManager.copyItemAtURL(location, toURL: destinationURL)

                    dispatch_async(dispatch_get_main_queue()) {
                        self.delegate?.didFinishDownloading(destinationURL)
                    }
                } catch let error as NSError {
                    print("Could not copy file to disk: \(error.localizedDescription)")
                }
        }
    }

    //this is to track progress
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {

        dispatch_async(dispatch_get_main_queue()) {
            self.delegate?.downloadProgress(Float(totalBytesWritten)/Float(totalBytesExpectedToWrite))
        }
    }
    
    // if there is an error during download this will be called
    func URLSession(session: NSURLSession, task: NSURLSessionTask, didCompleteWithError error: NSError?) {


    }

    func localFilePathForUrl(previewUrl: String) -> NSURL? {
        let documentsPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as NSString
        if let url = NSURL(string: previewUrl), lastPathComponent = url.lastPathComponent {
            let fullPath = documentsPath.stringByAppendingPathComponent(lastPathComponent)
            return NSURL(fileURLWithPath:fullPath)
        }
        return nil
    }


}