//
//  EmployeeDataHelper.swift
//  QuickContact
//
//  Created by Kevin on 18/04/2017.
//  Copyright © 2017 Mother App. All rights reserved.
//

import Foundation
import CoreData

class EmployeeDataHelper: NSObject {

    lazy var coreDataStack = CoreDataStack()

    func getAllEmployees() -> [EmployeeMO] {
        let moc = coreDataStack.persistentContainer.viewContext
        let employeesFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Employee")

        do {
            guard let fetchedEmployees = try moc.fetch(employeesFetch) as? [EmployeeMO] else {
                return [EmployeeMO]()
            }
            return fetchedEmployees
        } catch {
            fatalError("Failed to fetch employees: \(error)")
        }
        return [EmployeeMO]()
    }

    func clearAllEmployees() {
        let moc = coreDataStack.persistentContainer.viewContext
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Employee")
        let request = NSBatchDeleteRequest(fetchRequest: fetch)

        do {
            try moc.execute(request)
        } catch let error as NSError {
            fatalError("Unresolved error \(error), \(error.userInfo)")
        }
    }

    func saveEmployee(givenName: String!, familyName: String!, phoneNumber: String!) {
        let moc = coreDataStack.persistentContainer.viewContext

        guard let employee = NSEntityDescription.insertNewObject(forEntityName: "Employee",
                                                                 into: moc) as? EmployeeMO else {
            return
        }
        employee.givenName = givenName
        employee.familyName = familyName
        employee.phoneNumber = phoneNumber
        coreDataStack.saveContext()
    }
}
