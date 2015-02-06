//
//  ViewController.swift
//  FinallyLearnStoryboards
//
//  Created by Elliot Fiske on 2/3/15.
//  Copyright (c) 2015 Elliot Fiske. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBAction func refreshButtonPressed(sender: AnyObject) {
        if sender is UIButton {
            let button = sender as UIButton
            button.setTitle("Bruh", forState: .Normal)
        }
    }
    
    @IBOutlet weak var posLabel: UILabel!
    @IBOutlet weak var magLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        posLabel.text = "HAHAHAHAHA";
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

