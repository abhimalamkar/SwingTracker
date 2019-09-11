//
//  ViewController.swift
//  SwingTracker
//
//  Created by Abhijeet Malamkar on 9/11/19.
//  Copyright © 2019 Abhijeet Malamkar. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let swingTracker = SwingTracker(fromFile: "latestSwing.csv")
        
        let index = swingTracker.searchContinuityAboveValue(data: 0, indexBegin: 0, indexEnd: 0, threshold: 0, winLength: 0)
        
        print(swingTracker.data?[index!],index)
    }
}

