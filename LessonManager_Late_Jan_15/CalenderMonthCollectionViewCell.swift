//
//  CalenderMonthCollectionViewCell.swift
//  LessonManager_Jan_15
//
//  Created by Alex Bechmann on 03/01/2015.
//  Copyright (c) 2015 Alex Bechmann. All rights reserved.
//

import UIKit

class CalenderMonthCollectionViewCell: UICollectionViewCell {
    
    var cellIndicatorImageView: UIImageView? = nil
    var dayLabel: UILabel? = nil
    var cellDate:NSDate? = nil
    
    func addCellIndicator(){
        var heightAndWidth:CGFloat = 4
        if cellIndicatorImageView == nil{
            cellIndicatorImageView = UIImageView(frame:CGRectMake(0, 0, heightAndWidth, heightAndWidth))
            cellIndicatorImageView!.image = Tools.imageWithColor(UIColor.whiteColor(), size: CGSizeMake(heightAndWidth, heightAndWidth))
            var l:CALayer = cellIndicatorImageView!.layer
            l.masksToBounds = true
            l.cornerRadius = cellIndicatorImageView!.frame.width / 2
            cellIndicatorImageView!.setTranslatesAutoresizingMaskIntoConstraints(false)
            self.addSubview(cellIndicatorImageView!)
            
            cellIndicatorImageView!.addBottomConstraint(toView: cellIndicatorImageView!.superview, attribute: NSLayoutAttribute.Bottom, relation: NSLayoutRelation.Equal, constant: -8)
            cellIndicatorImageView!.addCenterXConstraint(toView: cellIndicatorImageView!.superview)
            
            self.layer.shouldRasterize = true;
            self.layer.rasterizationScale = UIScreen.mainScreen().scale;
        }
    }
    
    func resetCellIndicator(){
        cellIndicatorImageView?.removeFromSuperview()
        cellIndicatorImageView = nil
    }
}
