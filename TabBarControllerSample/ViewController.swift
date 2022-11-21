//
//  ViewController.swift
//  TabBarControllerSample
//
//  Created by Juan Mueller on 11/19/22.
//  www.ajourneyforwisdom.com

import UIKit

class ViewController: UIViewController {
    // Outlet for label
    @IBOutlet weak var clockLabel: UILabel!
    // Date formatter
    let dateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        // Call the viewdidload super
        super.viewDidLoad()
        // Configure date formatter
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .medium
        // Schedule a timer to trigger every second to invoke method updateLabel
        Timer.scheduledTimer(timeInterval: 1,
                             target: self,
                             selector: #selector(updateLabel),
                             userInfo: nil,
                             repeats:true);
    }
    
    // Method that updates the label text witht he current date time
    @objc func updateLabel() -> Void {
        // Update the text of the clock label with the time of the current date
        clockLabel.text = dateFormatter.string(from: Date());
    }
}

