//
//  ViewController.swift
//  Example
//
//  Created by Petr Palata on 06.02.2022.
//

import UIKit
import SimpleDeviceId

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let simpleDeviceId = SimpleDeviceId()
        NSLog("\(simpleDeviceId.getDeviceId())")
    }


}

