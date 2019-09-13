//
//  ViewController.swift
//  SwingTracker
//
//  Created by Abhijeet Malamkar on 9/11/19.
//  Copyright © 2019 Abhijeet Malamkar. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    
    let inputs = [["data","indexBegin","indexEnd", "threshold","winLength"],
                  ["data", "indexBegin","indexEnd", "thresholdLo", "thresholdHi", "winLength"],
                  ["data1","data2","indexBegin","indexEnd","threshold1","threshold2", "winLength"],
                  ["data", "indexBegin","indexEnd","thresholdLo","thresholdHi","winLength"]]
    
    let collectionViewData = ["searchContinuityAboveValue",
                              "backSearchContinuityWithinRange",
                              "searchContinuityAboveValueTwoSignals",
                              "searchMultiContinuityWithinRange"]
    
    lazy var collectionView: UICollectionView =  {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: view.frame.width, height: 50)
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = .lightGray
        cv.delegate = self
        cv.dataSource = self
        return cv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }
    
    func setupViews(){
        view.backgroundColor = .white
        
        view.addSubview(collectionView)
        collectionView.anchorToTop(view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)
        
        collectionView.register(TextCell.self, forCellWithReuseIdentifier: "\(TextCell.self)")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionViewData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(TextCell.self)", for: indexPath) as? TextCell
        cell?.titleLabel.text = collectionViewData[indexPath.item]
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let controller = FunctionViewController()
        controller.inputs = inputs[indexPath.item]
        controller.selectedFunctionIndex = indexPath.item
        navigationController?.pushViewController(controller, animated: true)
    }
}

class TextCell: UICollectionViewCell {
    
    var titleLabel:UILabel = {
        let view = UILabel()
        view.textAlignment = .center
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    func setupViews(){
        backgroundColor = .white
        addSubview(titleLabel)
        
        titleLabel.anchorWithConstantsToTop(topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 16, leftConstant: 16, bottomConstant: 16, rightConstant: 16)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
