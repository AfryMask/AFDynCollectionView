//
//  AFCollectionView.swift
//  AFCollectionView
//
//  Created by Afry on 16/1/24.
//  Copyright © 2016年 AfryMask. All rights reserved.
//

import UIKit

class AFCollectionView: UICollectionView,UICollectionViewDataSource,UIGestureRecognizerDelegate {
    
    
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        
        // collectionView的初始化设置
        self.backgroundColor = UIColor.whiteColor()
        
        let layout = self.collectionViewLayout as! UICollectionViewFlowLayout
        let itemWidth = self.frame.size.width/4                //4列
        layout.itemSize = CGSizeMake(itemWidth, itemWidth*0.9) //宽高比0.9
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        
        itemCount = 18 //item数量
        
        // 设置拖动view
        moveView = AFCollectionViewCell(frame: CGRectMake(0, 0, layout.itemSize.width, layout.itemSize.height))
        moveView!.iconButton!.backgroundColor = UIColor.redColor()
        moveView!.hidden = true
        moveView!.alpha = 0.8
        addSubview(moveView!)
        
        // 注册cell
        self.registerClass(AFCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        self.dataSource = self
        
        // home按钮
        let homeButton = UIButton(frame: CGRectMake(0, self.frame.size.height-46, self.frame.size.width, 46))
        homeButton.backgroundColor = UIColor.grayColor()
        homeButton.setTitle("HOME", forState: .Normal)
        homeButton.addTarget(self, action: "homeButtonClick", forControlEvents: .TouchUpInside)
        addSubview(homeButton)
        
        
        // 拖拽手势
        let panPress = UIPanGestureRecognizer(target: self, action: "pan:")
        self.addGestureRecognizer(panPress)
        
        // 长按手势
        let longPress = UILongPressGestureRecognizer(target: self, action: "longPress:")
        self.addGestureRecognizer(longPress)
        
    }
    
    @objc func longPress(sender:UILongPressGestureRecognizer){
        
        if sender.state == .Began {
            AFTouchesBegan(sender.locationInView(self))
        }else if sender.state == .Changed{
            AFTouchesMoved(sender.locationInView(self))
        }else if sender.state == .Ended{
            AFTouchesEnded()
        }
    }
    
    @objc func pan(sender:UIPanGestureRecognizer){
        
        if shaking{
            if sender.state == .Began {
                AFTouchesBegan(sender.locationInView(self))
            }else if sender.state == .Changed{
                AFTouchesMoved(sender.locationInView(self))
            }else if sender.state == .Ended{
                AFTouchesEnded()
            }
        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // home键点击，关闭抖动
    func homeButtonClick(){
        shaking = false
    }

    
    // 数据源方法
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemCount
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        collectionView
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! AFCollectionViewCell
        cell.nameLabel!.text = "\(indexPath.item)"
        cell.userInteractionEnabled = false
        // 对cell传入闭包
        
        return cell
    }
    
    // 可动view
    var moveView:AFCollectionViewCell?
    // 被选中的item
    var selectedIndex:NSIndexPath?
    // 光标经过某点的中介值
    var timeIndex:NSIndexPath?
    // 是否正在动画
    var shaking = false {
        didSet{
            for i in 0..<self.visibleCells().count {
                
                let cell = cellForItemAtIndexPath(NSIndexPath(forRow: i, inSection: 0))
                // 根据传入的bool值设置是否开始抖动
                if shaking {
                    
                    // 私有函数，返回根据一个浮点数，返回这个浮点数与其相反数之间的随机数
                    func getRandom(max:CGFloat) -> CGFloat{
                        let firstAnim1 = (CGFloat(random()%100)*0.6 + 40) / 100 * max
                        return firstAnim1 * CGFloat( M_PI_4)
                    }
                    // 私有函数，返回一个随机的正或负
                    func getRandomSymbol() -> CGFloat{
                        return random()%2 == 1 ? 1.0 : -1.0
                    }
                    
                    // 三个方向的动画设定
                    let anim1 = CAKeyframeAnimation()
                    let maxAnim1:CGFloat = 0.05
                    let firstAnim1:CGFloat = getRandom(maxAnim1)
                    let symbol1 = getRandomSymbol()
                    
                    anim1.keyPath = "transform.rotation"
                    anim1.values = [firstAnim1*symbol1, maxAnim1*symbol1, -maxAnim1*symbol1, firstAnim1*symbol1]
                    
                    let anim2 = CAKeyframeAnimation()
                    let maxAnim2:CGFloat = 0.5
                    let firstAnim2:CGFloat = getRandom(maxAnim2)
                    let symbol2 = getRandomSymbol()
                    
                    anim2.keyPath = "transform.translation.y"
                    anim2.values = [firstAnim2*symbol2, maxAnim2*symbol2, -maxAnim2*symbol2, firstAnim2*symbol2]
                    
                    let anim3 = CAKeyframeAnimation()
                    let maxAnim3:CGFloat = 0.5
                    let firstAnim3:CGFloat = getRandom(maxAnim2)
                    let symbol3 = getRandomSymbol()
                    
                    anim3.keyPath = "transform.translation.x"
                    anim3.values = [firstAnim3*symbol3, maxAnim3*symbol3, -maxAnim3*symbol3, firstAnim3*symbol3]
                    
                    let animaGroup = CAAnimationGroup()
                    animaGroup.animations = [anim1, anim2, anim3]
                    animaGroup.repeatCount = Float(INT_MAX)
                    animaGroup.duration = 0.22
                    cell!.layer.addAnimation(animaGroup, forKey: nil)
                    
                }else {
                    // 关闭抖动效果
                    cell!.layer.removeAllAnimations()
                }
                
            }
        
        
        }
    }
    // item数量
    var itemCount = 0
    // 选中的点
    var p:CGPoint = CGPointZero
}

// 触摸事件
extension AFCollectionView{
    

    func AFTouchesBegan(p:CGPoint) {
        print("toubegan")
        
        if let index = self.indexPathForItemAtPoint(p) {

                selectedIndex = index
            
            if let indexPath = self.indexPathForItemAtPoint(p) {
                shaking = true
                
                let cell = self.cellForItemAtIndexPath(indexPath)! as! AFCollectionViewCell
                
                let inFrame = CGRectMake(
                    cell.frame.origin.x+cell.iconButton!.frame.origin.x,
                    cell.frame.origin.y+cell.iconButton!.frame.origin.y,
                    cell.iconButton!.frame.width,
                    cell.iconButton!.frame.height)
                
                if CGRectContainsPoint(inFrame, p){
                    cell.hidden = true
                    
                    moveView!.iconButton!.backgroundColor = cell.iconButton!.backgroundColor
                    
                    moveView!.layer.anchorPoint = CGPointMake(
                        (p.x - cell.frame.origin.x)/cell.frame.width,
                        (p.y - cell.frame.origin.y)/cell.frame.height)
                    
                    
                    moveView!.nameLabel!.text = cell.nameLabel!.text
                    moveView!.center = p
                    moveView!.hidden = false
                    bringSubviewToFront(moveView!)
                }
                
                
            }
        }
        
    }
    

    func AFTouchesMoved(p: CGPoint) {
        
        guard let _ = selectedIndex else {return}
        
        moveView!.hidden = false
        moveView!.center = p
        
        var aimIndex:NSIndexPath?
        
        if let moveIndex = self.indexPathForItemAtPoint(p) {
            
            if moveIndex == self.selectedIndex {return}
            
            let cell = self.cellForItemAtIndexPath(moveIndex)! as! AFCollectionViewCell
            
            
            
            let inLeftFrame = CGRectMake(
                cell.frame.origin.x+cell.leftView!.frame.origin.x,
                cell.frame.origin.y+cell.leftView!.frame.origin.y,
                cell.leftView!.frame.width,
                cell.leftView!.frame.height)
            
            
            
            let inRightFrame = CGRectMake(
                cell.frame.origin.x+cell.rightView!.frame.origin.x,
                cell.frame.origin.y+cell.rightView!.frame.origin.y,
                cell.rightView!.frame.width,
                cell.rightView!.frame.height)
            
            if CGRectContainsPoint(inLeftFrame, p){
                aimIndex = NSIndexPath(forItem: moveIndex.item, inSection: 0)
            }else if CGRectContainsPoint(inRightFrame, p){
                aimIndex = NSIndexPath(forItem: moveIndex.item+1, inSection: 0)
                
            }else{
                aimIndex = self.selectedIndex
            }
            if (self.selectedIndex!.item<aimIndex!.item){
                aimIndex = NSIndexPath(forRow: aimIndex!.row-1, inSection: 0)
            }
        
        }else{
            aimIndex = NSIndexPath(forItem: self.visibleCells().count-1, inSection: 0)
        
        }
   
        self.timeIndex = aimIndex
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (Int64)(0.25 * CGFloat(NSEC_PER_SEC))), dispatch_get_main_queue(), { () -> Void in

            if self.timeIndex == aimIndex && self.selectedIndex!.item != aimIndex!.item{
                
                self.moveItemAtIndexPath(self.selectedIndex!, toIndexPath: aimIndex!)
                
                self.selectedIndex = aimIndex
            }
        })
            
            
        
    }
//
    func AFTouchesEnded() {
        print("touchesEnd")
        guard let _ = selectedIndex else {return}
        let cell = self.cellForItemAtIndexPath(selectedIndex!)!
        
        UIView.animateWithDuration(0.25, animations: { () -> Void in
            
            self.moveView!.layer.anchorPoint = CGPointMake(0.5, 0.5)
            self.moveView!.frame = cell.frame
            
            }) { (_) -> Void in
                cell.hidden = false
                
                self.moveView!.hidden = true
                self.timeIndex = nil
                self.selectedIndex = nil
        }
    }

}
