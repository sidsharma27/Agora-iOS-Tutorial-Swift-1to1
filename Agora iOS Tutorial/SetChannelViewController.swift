//
//  SetChannelViewController.swift
//  Agora iOS Tutorial
//
//  Created by Sidharth Sharma on 1/10/18.
//  Copyright © 2018 Agora.io. All rights reserved.
//

import Foundation
import UIKit

class SetChannelViewController: UIViewController {

    @IBOutlet weak var channelName: UITextField!
    
    @IBAction func startCall(_ sender: UIButton) {
        if (channelName.text?.isEmpty)! {
            print("Enter Channel Name")
        } else {
            self.performSegue(withIdentifier: "startCall", sender: self)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let viewController = segue.destination as? VideoCallViewController {
            viewController.channel = channelName.text!
        }
    }
    
}
