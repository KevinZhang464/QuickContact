//
//  ContactListViewController.swift
//  QuickContact
//
//  Created by Kevin on 12/04/2017.
//  Copyright © 2017 Mother App. All rights reserved.
//

import UIKit
import CoreData
import Alamofire
import Contacts

class ContactListViewController: UIViewController {
    
    private var contactTableViewController: ContactTableViewController!
    lazy var coreDataStack = CoreDataStack()
    var contactStore = CNContactStore()
    var contacts = [CNContact]()

    @IBAction func exportBtnClicked(_ sender: Any) {
        requestForAccess { (accessGranted) -> Void in
            if accessGranted {
                print("kevin: get premiss success")
                self.getAllContacts()
            }
        }
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
        }
    }
    
    func clearContactDataList() {
        let moc = coreDataStack.persistentContainer.viewContext
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Employee")
        let request = NSBatchDeleteRequest(fetchRequest: fetch)
        
        do {
            try moc.execute(request)
        } catch let error as NSError {
            fatalError("Unresolved error \(error), \(error.userInfo)")
        }
    }
    
    func setContactDataList(json: [NSDictionary]) {
        
        let moc = coreDataStack.persistentContainer.viewContext
        
        for dict in json {
            let givenName = dict.object(forKey: "first_name") as! String
            let familyName = dict.object(forKey: "last_name") as! String
            let phoneNumber = dict.object(forKey: "phone_number") as! String
            print("\(givenName) \(familyName): \(phoneNumber)")
            let employee = NSEntityDescription.insertNewObject(forEntityName: "Employee", into: moc) as! EmployeeMO
            
            employee.givenName = givenName
            employee.familyName = familyName
            employee.phoneNumber = phoneNumber
            coreDataStack.saveContext()
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
            
            guard ((response.result.value as? [NSDictionary]) != nil) else {
                print("Malformed data received from fetchAllRooms service")
                return
            }
            
            let value = response.result.value as! [NSDictionary]
            self.clearContactDataList()
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
    
    func requestForAccess(completionHandler: @escaping (_ accessGranted: Bool) -> Void) {
        let authorizationStatus = CNContactStore.authorizationStatus(for: CNEntityType.contacts)
        
        switch authorizationStatus {
        case .authorized:
            completionHandler(true)
            
        case .denied, .notDetermined:
            self.contactStore.requestAccess(for: CNEntityType.contacts, completionHandler: { (access, accessError) -> Void in
                if access {
                    completionHandler(access)
                } else {
                    if authorizationStatus == CNAuthorizationStatus.denied {
                        DispatchQueue.main.async(execute: { () -> Void in
                            let message = "\(accessError!.localizedDescription)\n\nPlease allow the app to access your contacts through the Settings."
                            self.showMessage(message: message)
                        })
                    }
                }
            })
            
        default:
            completionHandler(false)
        }
    }
    
    func getAllContacts () {
        
        let keysToFetch = [
            CNContactGivenNameKey,
            CNContactFamilyNameKey,
            CNContactPhoneNumbersKey
        ]
        let request = CNContactFetchRequest(keysToFetch: keysToFetch as [CNKeyDescriptor])
        self.contacts = []
        do {
            try self.contactStore.enumerateContacts(with: request) { contact, stop in
                self.contacts.append(contact)
            }
            
            for contact in self.contacts {
                print("contact:\(contact)")
                
                let firstName=String(format:"%@",contact.givenName)
                print("first:\(firstName)")
                
                let lastName=String(format:"%@",contact.familyName)
                print("last:\(lastName)")
                
                //get all phone numbers
                // for ContctNumVar: CNLabeledValue in contact.phoneNumbers
                // {
                //     let MobNumVar  = (ContctNumVar.value ).value(forKey: "digits") as? String
                //     print("ph no:\(MobNumVar!)")
                // }
                
                // get one phone number
                let MobNumVar = (contact.phoneNumbers[0].value ).value(forKey: "digits") as! String
                print("mob no:\(MobNumVar)")
                
            }
            
            DispatchQueue.main.async(execute: {
            })
            
            
        } catch {
            print(error)
        }
    }

}
