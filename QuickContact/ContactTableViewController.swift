//
//  ContactTableViewController.swift
//  QuickContact
//
//  Created by Kevin on 14/04/2017.
//  Copyright © 2017 Mother App. All rights reserved.
//

import UIKit
import MessageUI

class ContactTableViewController: UITableViewController, MFMessageComposeViewControllerDelegate {
    
    var tableViewData: [EmployeeMO]! = []
    var employeeDataHelper: EmployeeDataHelper! = EmployeeDataHelper()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tableViewData = employeeDataHelper.getAllEmployees()
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
        if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "displayTableViewCell") as! DisplayTableViewCell
            
            let contactData = tableViewData[indexPath.row]
            cell.nameLabel?.text = "\(contactData.givenName!) \(contactData.familyName!)"
            cell.phoneNumberLabel?.text = contactData.phoneNumber
            cell.viewController = self
            
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "contactTableViewCell") as! ContactTableViewCell
        
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

    public func reloadTableViewData() {
        tableViewData = employeeDataHelper.getAllEmployees()
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
    
    public func makeCall(phoneNumber: String!) {
        guard let url = URL(string: "telprompt://" + phoneNumber) else {
            return
        }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}
