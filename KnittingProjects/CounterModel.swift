//
//  CounterModel.swift
//  KnittingProjects
//
//  Created by Rebecca Cordingley on 9/07/2014.
//  Copyright (c) 2014 Rebecca Cordingley. All rights reserved.
//

import UIKit
import CoreData
@objc(CounterModel)
class CounterModel: NSManagedObject {
    @NSManaged var name: String
    @NSManaged var notes: String
    @NSManaged var counterOne: Int
    @NSManaged var counterTwo: Int
}
