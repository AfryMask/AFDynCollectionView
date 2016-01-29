//
//  ViewController.swift
//  AFCollectionView
//
//  Created by Afry on 16/1/24.
//  Copyright © 2016年 AfryMask. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let layout = UICollectionViewFlowLayout()
        
        let colFrame = CGRectMake(0, 20, self.view.frame.width, self.view.frame.height-20)
        let colView = AFCollectionView(frame: colFrame, collectionViewLayout: layout)
        view.addSubview(colView)
    }
}

