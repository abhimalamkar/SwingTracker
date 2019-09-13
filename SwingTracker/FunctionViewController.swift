//
//  FunctionViewController.swift
//  SwingTracker
//
//  Created by Abhijeet Malamkar on 9/13/19.
//  Copyright © 2019 Abhijeet Malamkar. All rights reserved.
//

import UIKit

class FunctionViewController: UIViewController {
    
    var swingTracker:SwingTracker?
    
    var inputs:[String]? = [] {
        didSet {
            //            print(inputs)
        }
    }
    
    var selectedFunctionIndex:Int? = 0
    
    var inputFields:[UITextField] = []
    
    let outputBox:UITextView = {
        let view = UITextView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        view.textColor = .white
        view.text = "For selecting data type one of this (ax,ay,az,wx,wy,wz)"
        return view
    }()
    
    lazy var submitButton:UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .darkGray
        view.setTitle("Call", for: .normal)
        view.addTarget(self, action: #selector(submit), for: .touchUpInside)
        view.layer.cornerRadius = 5
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSwingTracker()
        setupViews()
    }
    
    func setupSwingTracker(){
        swingTracker = SwingTracker(fromFile: "latestSwing.csv")
    }
    
    func setupViews(){
        view.backgroundColor = .white
        view.addSubview(outputBox)
        
        _ = outputBox.anchor(view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: (84), leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 100)
        
        for (index, input) in (inputs ?? []).enumerated() {
            let textField :UITextField = {
                let field = UITextField()
                field.placeholder = input
                field.translatesAutoresizingMaskIntoConstraints = false
                return field
            }()
            
            view.addSubview(textField)
            _ = textField.anchor(outputBox.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 32 + CGFloat(index * 50), leftConstant: 16, bottomConstant: 0, rightConstant: 16, widthConstant: 0, heightConstant: 50)
            
            inputFields.append(textField)
        }
        
        view.addSubview(submitButton)
        
        _ = submitButton.anchor(nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 16, bottomConstant: 16, rightConstant: 16, widthConstant: 0, heightConstant: 50)
    }
    
    @objc func submit(){
        var data:[[Double]] = []
        var threshold:[Double] = []
        var indexBegin = 0
        var indexEnd = 0
        var winLength = 0
        
        for (index,field) in inputFields.enumerated() {
            if inputs?[index].hasPrefix("data") ?? false {
                switch field.text?.lowercased() {
                case "ax":
                    if let d = swingTracker?.data?.map({($0.accelerometerData?.vector3.x)!}) {
                        data.append(d)
                    }
                    break
                case "ay":
                    if let d = swingTracker?.data?.map({($0.accelerometerData?.vector3.y)!}) {
                        data.append(d)
                    }
                    break
                case "az":
                    if let d = swingTracker?.data?.map({($0.accelerometerData?.vector3.z)!}) {
                        data.append(d)
                    }
                    break
                case "wx":
                    if let d = swingTracker?.data?.map({($0.gyroscopeData?.vector3.x)!}) {
                        data.append(d)
                    }
                    break
                case "wy":
                    if let d = swingTracker?.data?.map({($0.gyroscopeData?.vector3.y)!}) {
                        data.append(d)
                    }
                    break
                case "wz":
                    if let d = swingTracker?.data?.map({($0.gyroscopeData?.vector3.z)!}) {
                        data.append(d)
                    }
                    break
                default:
                    if let d = swingTracker?.data?.map({($0.accelerometerData?.vector3.x)!}) {
                        data.append(d)
                    }
                }
            }
            
            if inputs?[index].elementsEqual("indexBegin") ?? false {
                if let text = field.text, let value = Int(text) {
                    indexBegin = value
                }
            }
            
            if inputs?[index].elementsEqual("indexEnd") ?? false {
                if let text = field.text, let value = Int(text) {
                    indexEnd = value
                }
            }
            
            if inputs?[index].hasPrefix("threshold") ?? false {
                if let text = field.text, let value = Double(text) {
                    threshold.append(value)
                }
            }
            
            if inputs?[index].elementsEqual("winLength") ?? false {
                if let text = field.text, let value = Int(text) {
                    winLength = value
                }
            }
        }
        
        
        switch selectedFunctionIndex! {
        case 1:
            let indexOutput = swingTracker?.backSearchContinuityWithinRange(data: data[0], indexBegin: indexBegin, indexEnd: indexEnd, thresholdLo: threshold[0], thresholdHi: threshold[1], winLength: winLength)
            outputBox.text = indexOutput == nil ? "index not found" : indexOutput?.description
            break
        case 2:
            let indexOutput = swingTracker?.searchContinuityAboveValueTwoSignals(data1: data[0], data2: data[1], indexBegin: indexBegin, indexEnd: indexEnd, threshold1: 0, threshold2: 0, winLength: winLength)
            outputBox.text = indexOutput == nil ? "index not found" : indexOutput?.description
            break
        case 3:
            let indexOutput = swingTracker?.searchMultiContinuityWithinRange(data: data[0], indexBegin: indexBegin, indexEnd: indexEnd, thresholdLo: threshold[0], thresholdHi: threshold[1], winLength: winLength)
            outputBox.text = indexOutput == nil ? "index not found" : indexOutput.debugDescription
            break
        default:
            let indexOutput = swingTracker?.searchContinuityAboveValue(data: data[0], indexBegin: indexBegin, indexEnd: indexEnd, threshold: threshold[0], winLength: winLength)
            outputBox.text = indexOutput == nil ? "index not found" : indexOutput?.description
        }
        
        
    }
}
