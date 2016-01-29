//
//  AFCollectionViewCell.swift
//  AFCollectionView
//
//  Created by Afry on 16/1/24.
//  Copyright © 2016年 AfryMask. All rights reserved.
//

import UIKit

class AFCollectionViewCell: UICollectionViewCell,UIGestureRecognizerDelegate {
    
    var shake:((shake:Bool)->())?
    var iconButton:UIButton?
    var nameLabel:UILabel?
    var leftView:UIView?
    var rightView:UIView?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
//        self.backgroundColor = UIColor(red: CGFloat(random())%256.0/255.0, green: CGFloat(random())%256.0/255.0, blue: CGFloat(random())%256.0/255.0, alpha: 0.6)
        setupUI()
        
    }
    
    
    

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI(){
        let selfWidth = self.frame.size.width
        
        let widthPro:CGFloat = 0.7
        let spacePro:CGFloat = 0.3
        
        func RandomColor() -> UIColor{
            return UIColor(red: CGFloat(random())%256.0/255.0, green: CGFloat(random())%256.0/255.0, blue: CGFloat(random())%256.0/255.0, alpha: 1)
        }
        
        // icon
        let iconFrame = CGRectMake(selfWidth*(1-widthPro)/2, 0, selfWidth*widthPro, selfWidth*widthPro)
        iconButton = UIButton(frame: iconFrame)
        iconButton!.backgroundColor = RandomColor()
        iconButton!.layer.cornerRadius = 10
        iconButton!.clipsToBounds = true
        iconButton!.addTarget(self, action: "iconButtonPress", forControlEvents: .TouchUpInside)
        addSubview(iconButton!)
        
        // name
        let nameFrame = CGRectMake(0, selfWidth*widthPro, selfWidth, selfWidth*(1-widthPro)/2)
        nameLabel = UILabel(frame: nameFrame)
        nameLabel!.text = "123"
        nameLabel!.textAlignment = .Center
        nameLabel!.font = UIFont.systemFontOfSize(13)
        addSubview(nameLabel!)
        
        // left
        let leftFrame = CGRectMake(0, 0, selfWidth*spacePro, selfWidth*widthPro)
        leftView = UIView(frame: leftFrame)
//        leftView!.backgroundColor = RandomColor()
        addSubview(leftView!)
        
        // right
        let rightFrame = CGRectMake(selfWidth*(1-spacePro), 0, selfWidth*spacePro, selfWidth*widthPro)
        rightView = UIView(frame: rightFrame)
//        rightView!.backgroundColor = RandomColor()
        addSubview(rightView!)
        
        let longPress = UILongPressGestureRecognizer(target: self, action: "longPress:")
        longPress.minimumPressDuration = 1;
        longPress.allowableMovement = 80;

        self.iconButton!.addGestureRecognizer(longPress)

    }
    
    @objc func longPress(sender:UILongPressGestureRecognizer){
        shake!(shake:true)
    
    }
    @objc func iconButtonPress(){
        print(nameLabel!.text!)
    }

    
}
