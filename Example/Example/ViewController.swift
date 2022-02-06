//
//  ViewController.swift
//  Example
//
//  Created by Petr Palata on 06.02.2022.
//

import UIKit
import SimpleDeviceId

class ViewController: UIViewController {
    @IBOutlet var deviceIdLabel: UILabel!
    
    private let deviceIdRetriever = SimpleDeviceId()

    @IBAction func didPressGetDeviceIdButton() {
        if let deviceId = try? deviceIdRetriever.getDeviceId() {
            deviceIdLabel.text = deviceId.uuidString
        } else {
            deviceIdLabel.text = "Failed to retrieve device ID"
        }
    }
}

