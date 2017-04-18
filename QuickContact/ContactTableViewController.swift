//
//  ContactTableViewController.swift
//  QuickContact
//
//  Created by Kevin on 14/04/2017.
//  Copyright © 2017 Mother App. All rights reserved.
//

import UIKit
import CoreData

class ContactTableViewController: UITableViewController {
    
    var tableViewData: [EmployeeMO]! = []
    lazy var coreDataStack = CoreDataStack()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tableViewData = getContactDataList()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let number = tableViewData.count
        return number
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "contactTableViewCell", for: indexPath) as! ContactTableViewCell
        
        let contactData = tableViewData[indexPath.row]
        cell.nameLabel?.text = "\(contactData.givenName!) \(contactData.familyName!)"
        cell.phoneNumberLabel?.text = contactData.phoneNumber
        
        return cell
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
    
    public func reloadTableViewData() {
        tableViewData = getContactDataList()
        tableView.reloadData()
    }
}
