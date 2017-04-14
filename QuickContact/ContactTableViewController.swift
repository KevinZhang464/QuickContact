//
//  ContactTableViewController.swift
//  QuickContact
//
//  Created by Kevin on 14/04/2017.
//  Copyright © 2017 Mother App. All rights reserved.
//

import UIKit

class ContactTableViewController: UITableViewController {
    
    var tableViewData: Array<ContactData>! = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        for i in 0...9 {
            let contactData: ContactData! = ContactData()
            contactData.displayName = String(format: "%@%d", "kevin ", i)
            contactData.phoneNumber = String(format: "%@%d", "1351351135", i)
            tableViewData.append(contactData)
        }
        
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
    
}
