//
//  ContactTableViewCell.swift
//  QuickContact
//
//  Created by Kevin on 14/04/2017.
//  Copyright © 2017 Mother App. All rights reserved.
//

import UIKit
import MessageUI

class ContactTableViewCell: UITableViewCell {
    
    var viewController: ContactTableViewController?
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var phoneNumberLabel: UILabel!
    
    @IBAction func smsBtnClicked(_ sender: Any) {
        viewController?.sendMessage(phoneNumber: phoneNumberLabel.text)
    }
    
}
