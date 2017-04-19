//
//  EmployeeMO.swift
//  QuickContact
//
//  Created by Kevin on 17/04/2017.
//  Copyright © 2017 Mother App. All rights reserved.
//

import UIKit
import CoreData
import Foundation

@objc(EmployeeMO)
class EmployeeMO: NSManagedObject {
    
    @NSManaged var displayName: String?
    @NSManaged var phoneNumber: String?
    
}
