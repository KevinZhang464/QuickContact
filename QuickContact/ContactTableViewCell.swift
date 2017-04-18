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
    
    @IBAction func detailClicked(_ sender: Any) {
    }
    
    @IBAction func callBtnClicked(_ sender: Any) {
        let number = phoneNumberLabel.text!
        guard let url = URL(string: "telprompt://" + number) else {
            return
        }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}
