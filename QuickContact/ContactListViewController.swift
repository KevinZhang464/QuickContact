//
//  ContactListViewController.swift
//  QuickContact
//
//  Created by Kevin on 12/04/2017.
//  Copyright © 2017 Mother App. All rights reserved.
//

import UIKit

class ContactListViewController: UIViewController {
    private var contactTableViewController: ContactTableViewController!

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
            let contactDataList: Array<ContactData>! = getContactDataList()
            contactTableViewController.setTableViewData(contactDataList: contactDataList)
        }
    }
    
    func getContactDataList() -> Array<ContactData> {
        var contactDataList: Array<ContactData>! = []
        for i in 0...9 {
            let contactData: ContactData! = ContactData()
            contactData.displayName = String(format: "%@ %d", "kevin", i)
            contactData.phoneNumber = String(format: "%@%d", "1351351135", i)
            contactDataList.append(contactData)
        }
        return contactDataList
    }

}
