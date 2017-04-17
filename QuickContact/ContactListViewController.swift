//
//  ContactListViewController.swift
//  QuickContact
//
//  Created by Kevin on 12/04/2017.
//  Copyright © 2017 Mother App. All rights reserved.
//

import UIKit
import CoreData

class ContactListViewController: UIViewController {
    
    private var contactTableViewController: ContactTableViewController!
    lazy var coreDataStack = CoreDataStack()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "EmbedSegue") {
            let vc = segue.destination as? ContactTableViewController
            contactTableViewController = vc
            let contactDataList: [EmployeeMO]! = getContactDataList()
            contactTableViewController.setTableViewData(contactDataList: contactDataList)
        }
    }
    
    func getContactDataList() -> [EmployeeMO] {
        let moc = coreDataStack.persistentContainer.viewContext
        let employeesFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Employee")
        
        do {
            let fetchedEmployees = try moc.fetch(employeesFetch) as! [EmployeeMO]
            return fetchedEmployees
        } catch {
            fatalError("Failed to fetch employees: \(error)")
        }
        
        return Array<EmployeeMO>()
    }
    
    func setContactDataList() {
        let moc = coreDataStack.persistentContainer.viewContext
        for i in 0...9 {
            let employee = NSEntityDescription.insertNewObject(forEntityName: "Employee", into: moc) as! EmployeeMO
            
            employee.displayName = String(format: "%@ %d", "kevin", i)
            employee.phoneNumber = String(format: "%@%d", "1351351135", i)
            coreDataStack.saveContext()
        }

    }

}
