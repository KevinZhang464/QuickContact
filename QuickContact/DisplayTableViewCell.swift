//
//  DisplayTableViewCell.swift
//  QuickContact
//
//  Created by Kevin on 20/04/2017.
//  Copyright © 2017 Mother App. All rights reserved.
//

import UIKit

class DisplayTableViewCell: UITableViewCell {

    var viewController: ContactTableViewController?

    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var phoneNumberLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
