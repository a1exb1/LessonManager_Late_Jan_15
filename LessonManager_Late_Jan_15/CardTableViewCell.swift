//
//  CardTableViewCell.swift
//  LessonManager_Dec_14
//
//  Created by Alex Bechmann on 27/12/2014.
//  Copyright (c) 2014 Alex Bechmann. All rights reserved.
//

import UIKit

class CardTableViewCell: UITableViewCell {

    var originalBounds:CGRect? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.backgroundColor = UIColor.groupTableViewBackgroundColor()
    }
    
    override func layoutSubviews()
    {
        let margin:CGFloat = 15
        
        if (originalBounds == nil){
            originalBounds = self.bounds
        }
        
        var width:CGFloat = UIApplication.sharedApplication().keyWindow!.bounds.width  //CGFloat(originalBounds!.size.width)
        
        if width > Tools.MinWidthForStaticSideBar(){
            width = width - Tools.SideBarWidth()
        }
        
        if width > 500{
            width = 500
        }
        
        self.bounds.size.width = width - (margin * 2.00)
        self.bounds.size.height = originalBounds!.size.height - margin
        
        //self.bounds = CGRectZero
        //self.setTranslatesAutoresizingMaskIntoConstraints(false)
        //self.addLeftConstraint(toView: self.superview, attribute: NSLayoutAttribute.Left, relation: NSLayoutRelation.Equal, constant: 30)
        //self.addRightConstraint(toView: self.superview, attribute: NSLayoutAttribute.Right, relation: NSLayoutRelation.Equal, constant: 30)
        
        self.viewForBaselineLayout()!.layer.masksToBounds = false;
        //self.viewForBaselineLayout()!.layer.cornerRadius = 5; // if you like rounded corners
        self.viewForBaselineLayout()!.layer.shadowOffset = CGSize(width: -0.1, height: 0.1)
        self.viewForBaselineLayout()!.layer.shadowRadius = 5
        self.viewForBaselineLayout()!.layer.shadowOpacity = 0.04
        
        //%%% This is a little hard to explain, but basically, it lowers the performance required to build shadows.  If you don't use this, it will lag
        var path:UIBezierPath = UIBezierPath(rect:self.viewForBaselineLayout()!.bounds);
        self.viewForBaselineLayout()!.layer.shadowPath = path.CGPath;
        Tools.AddBorderToView(self.viewForBaselineLayout()!, color: UIColor.lightGrayColor().colorWithAlphaComponent(0.5), width: 0.5)
        
        //self.selectedBackgroundView.layer.cornerRadius = 5
        
        super.layoutSubviews()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
