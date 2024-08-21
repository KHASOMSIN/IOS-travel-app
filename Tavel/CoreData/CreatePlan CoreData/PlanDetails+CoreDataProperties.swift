//
//  PlanDetails+CoreDataProperties.swift
//  Tavel
//
//  Created by user245540 on 8/12/24.
//
//

import Foundation
import CoreData


extension PlanDetails {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PlanDetails> {
        return NSFetchRequest<PlanDetails>(entityName: "PlanDetails")
    }

    @NSManaged public var titleItems: String?
    @NSManaged public var amount: Int16
    @NSManaged public var prices: Double
    @NSManaged public var itemId: String?
    @NSManaged public var travelPlan: TravelPlan?

}
