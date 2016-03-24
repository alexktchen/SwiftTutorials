//
//  User.swift
//  CoreDataSample
//
//  Created by Alex Chen on 2016/3/21.
//  Copyright © 2016年 Alex.Chen. All rights reserved.
//

import Foundation
import CoreData

class User: NSManagedObject {

    @NSManaged var id: Int16
    @NSManaged var name: String
}