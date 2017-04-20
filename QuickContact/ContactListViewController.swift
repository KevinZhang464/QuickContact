//
//  ContactListViewController.swift
//  QuickContact
//
//  Created by Kevin on 12/04/2017.
//  Copyright © 2017 Mother App. All rights reserved.
//

import UIKit
import Alamofire

class ContactListViewController: UIViewController {
    
    private var contactTableViewController: ContactTableViewController!
    var employeeDataHelper: EmployeeDataHelper! = EmployeeDataHelper()
    var contactHelper: ContactHelper! = ContactHelper()

    @IBAction func exportBtnClicked(_ sender: Any) {
        contactHelper.requestForAccess(completionHandler: { (accessGranted) -> Void in
            if accessGranted {
                print("kevin: get premiss success")
                self.importContactsToDevice()
            }
        }, showAlertHandler: { () -> Void in
            DispatchQueue.main.async(execute: { () -> Void in
                let message = "Please allow the app to access your contacts through the Settings."
                self.showMessage(message: message)
            })
        })
    }

    @IBAction func refreshBtnClicked(_ sender: Any) {
        getJSON()
    }
    
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
            contactTableViewController.parentVC = self
        }
    }
    
    func setContactDataList(json: [NSDictionary]) {
        for dict in json {
            let givenName = dict.object(forKey: "first_name") as! String
            let familyName = dict.object(forKey: "last_name") as! String
            let phoneNumber = dict.object(forKey: "phone_number") as! String
            print("\(givenName) \(familyName): \(phoneNumber)")
            self.employeeDataHelper.saveEmployee(givenName: givenName,
                                                 familyName: familyName,
                                                 phoneNumber: phoneNumber)
        }
        
        self.contactTableViewController.reloadTableViewData()
    }
    
    func getJSON() {
        let url = "http://192.168.13.61:8001/"
        Alamofire.request(url).responseJSON { response in
//            print(response.request)  // original URL request
//            print(response.response) // HTTP URL response
//            print(response.data)     // server data
//            print(response.result)   // result of response serialization
            
            if let JSON = response.result.value {
                print("JSON: \(JSON)")
            }
            
            guard response.result.isSuccess else {
                print("Error while fetching remote rooms: \(String(describing: response.result.error))")
                return
            }
            
            guard let value = response.result.value as? [NSDictionary] else {
                print("Malformed data received from fetchAllRooms service")
                return
            }
            self.employeeDataHelper.clearAllEmployees()
            self.setContactDataList(json: value)
        }
    }

    func showMessage(message: String) {
        let alertController = UIAlertController(title: "QuickContact", message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        let dismissAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (action) -> Void in
        }
        
        alertController.addAction(dismissAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func importContactsToDevice() {
        let employees = employeeDataHelper.getAllEmployees()
        contactHelper.saveContactWithoutDuplicate(employees: employees)
    }
    
    public func showContactDetail() {
//        navigationController?.performSegue(withIdentifier: "showContactDetail", sender: self)
        performSegue(withIdentifier: "showContactDetail", sender: self)
    }
}
