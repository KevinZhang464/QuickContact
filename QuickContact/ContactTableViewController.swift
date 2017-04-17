//
//  ContactTableViewController.swift
//  QuickContact
//
//  Created by Kevin on 14/04/2017.
//  Copyright © 2017 Mother App. All rights reserved.
//

import UIKit

class ContactTableViewController: UITableViewController {
    
    var tableViewData: [EmployeeMO]! = []
    lazy var coreDataStack = CoreDataStack()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
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
        cell.nameLabel?.text = contactData.displayName
        cell.phoneNumberLabel?.text = contactData.phoneNumber
        
        return cell
    }
    
    public func setTableViewData(contactDataList: [EmployeeMO]) {
        tableViewData = contactDataList
    }
}
