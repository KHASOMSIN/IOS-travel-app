//
//  SavedTrip+CoreDataProperties.swift
//  Tavel
//
//  Created by user245540 on 8/14/24.
//
//

import Foundation
import CoreData


extension SavedTrip {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SavedTrip> {
        return NSFetchRequest<SavedTrip>(entityName: "SavedTrip")
    }

    @NSManaged public var savedTitle: String?
    @NSManaged public var savedDescription: String?
    @NSManaged public var savedImage: Data?
    @NSManaged public var isSavedTrip: Bool

}
