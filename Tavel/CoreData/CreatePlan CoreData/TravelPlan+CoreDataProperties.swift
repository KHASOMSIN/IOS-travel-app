//
//  TravelPlan+CoreDataProperties.swift
//  Tavel
//
//  Created by user245540 on 8/12/24.
//
//

import Foundation
import CoreData

extension TravelPlan {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TravelPlan> {
        return NSFetchRequest<TravelPlan>(entityName: "TravelPlan")
    }

    @NSManaged public var planName: String?
    @NSManaged public var placeName: String?
    @NSManaged public var date: String?
    @NSManaged public var tripMember: String?
    @NSManaged public var planID: String?
    @NSManaged public var planDetail: Set<PlanDetails>?

}

