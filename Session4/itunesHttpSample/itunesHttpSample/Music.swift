//
//  Music.swift
//  itunesHttpSample
//
//  Created by Alex Chen on 2016/3/23.
//  Copyright © 2016年 Alex.Chen. All rights reserved.
//

import Foundation
import CoreData

class Music: NSManagedObject {


    @NSManaged var collectionCensoredName: String
    @NSManaged var previewUrl: String
    @NSManaged var artworkUrl: NSData
    @NSManaged var artistName: String
    @NSManaged var trackCensoredName: String


}