//
//  ViewController.swift
//  TabBarControllerSample
//
//  Created by Juan Reyes on 11/19/22.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var clockLabel: UILabel!
    let dateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .medium
        
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateLabel), userInfo: nil, repeats:true);
    }
    
    @objc func updateLabel() -> Void {
        clockLabel.text = dateFormatter.string(from: Date());
    }
}

