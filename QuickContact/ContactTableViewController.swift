//
//  ContactTableViewController.swift
//  QuickContact
//
//  Created by Kevin on 14/04/2017.
//  Copyright © 2017 Mother App. All rights reserved.
//

import UIKit
import CoreData
import MessageUI

class ContactTableViewController: UITableViewController, MFMessageComposeViewControllerDelegate {
    
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
        cell.viewController = self
        
        return cell
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        
        switch (result.hashValue) {
        case MessageComposeResult.cancelled.hashValue:
            print("Message was cancelled")
            self.dismiss(animated: true, completion: nil)
        case MessageComposeResult.failed.hashValue:
            print("Message failed")
            self.dismiss(animated: true, completion: nil)
        case MessageComposeResult.sent.hashValue:
            print("Message was sent")
            self.dismiss(animated: true, completion: nil)
        default:
            break;
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
    
    public func reloadTableViewData() {
        tableViewData = getContactDataList()
        tableView.reloadData()
    }

    public func sendMessage(phoneNumber: String!) {
        if (MFMessageComposeViewController.canSendText()) {
            let messageVC = MFMessageComposeViewController()
            messageVC.body = "Enter a message";
            messageVC.recipients = [phoneNumber]
            messageVC.messageComposeDelegate = self
            self.present(messageVC, animated: false, completion: nil)
        }
    }
}
