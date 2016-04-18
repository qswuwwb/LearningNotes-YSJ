//
//  BowTie+CoreDataProperties.swift
//  BowTies
//
//  Created by ysj on 16/4/16.
//  Copyright © 2016年 newbieYin. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension BowTie {

    @NSManaged var name: String?
    @NSManaged var searchKey: String?
    @NSManaged var rating: NSNumber?
    @NSManaged var tintColor: NSObject?
    @NSManaged var imageName: String?
    @NSManaged var lastWorn: NSDate?
    @NSManaged var timesWorn: NSNumber?
    @NSManaged var isFavorite: NSNumber?
    @NSManaged var photoData: NSData?

}
