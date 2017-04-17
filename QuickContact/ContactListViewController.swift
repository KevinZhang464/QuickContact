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

class ContactListViewController: UIViewController {
    
    private var contactTableViewController: ContactTableViewController!
    lazy var coreDataStack = CoreDataStack()

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
            let name = dict.object(forKey: "name") as! String
            let phone = dict.object(forKey: "phone") as! String
            print(name + ": " + phone)
            let employee = NSEntityDescription.insertNewObject(forEntityName: "Employee", into: moc) as! EmployeeMO
            
            employee.displayName = name
            employee.phoneNumber = phone
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

}
