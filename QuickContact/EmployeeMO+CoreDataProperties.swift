//
//  EmployeeMO+CoreDataProperties.swift
//  QuickContact
//
//  Created by Kevin on 20/04/2017.
//  Copyright © 2017 Mother App. All rights reserved.
//

import Foundation
import CoreData

extension EmployeeMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<EmployeeMO> {
        return NSFetchRequest<EmployeeMO>(entityName: "Employee")
    }

    @NSManaged public var familyName: String?
    @NSManaged public var givenName: String?
    @NSManaged public var phoneNumber: String?

}
