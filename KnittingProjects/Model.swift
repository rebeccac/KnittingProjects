//
//  Model.swift
//  KnittingProjects
//
//  Created by Rebecca Cordingley on 7/07/2014.
//  Copyright (c) 2014 Rebecca Cordingley. All rights reserved.
//

import UIKit
import CoreData
@objc(Model)
class Model: NSManagedObject {
    @NSManaged var name: String
    @NSManaged var notes: String
    @NSManaged var counter: Int
}
