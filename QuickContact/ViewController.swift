//
//  ViewController.swift
//  QuickContact
//
//  Created by Kevin on 12/04/2017.
//  Copyright © 2017 Mother App. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var button: UIButton!
    @IBOutlet var textFeild: UITextField!
    
    @IBAction func action(_ sender: Any) {
        print("show button clicked:")
        performSegue(withIdentifier: "showDetailView", sender: self)
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
        print("prepare for segue")
        if (segue.identifier == "showDetailView") {
            print("showDetailView")
            if let detailViewController = segue.destination as? DetailViewController {
                detailViewController.labelString = textFeild.text
            }
        }
    }

}

