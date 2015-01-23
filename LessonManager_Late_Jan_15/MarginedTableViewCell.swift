//
//  MarginedTableViewCell.swift
//  LessonManager_Jan_15
//
//  Created by Alex Bechmann on 05/01/2015.
//  Copyright (c) 2015 Alex Bechmann. All rights reserved.
//

import UIKit

let margin:CGFloat = 30

class MarginedTableViewCell: UITableViewCell {
    
    var containerView:UIView = UIView()
    var indexPath:NSIndexPath = NSIndexPath()
    var numberOfRowsInSection = 0
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

//    init(style: UITableViewCellStyle, reuseIdentifier: String?, indexPath:NSIndexPath, numberOfRowsInSection:Int) {
//        
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        
//        self.indexPath = indexPath
//        self.numberOfRowsInSection = numberOfRowsInSection
//    }
//
//    required init(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    override func layoutSubviews(){
        var width:CGFloat = containerView.bounds.width // UIApplication.sharedApplication().keyWindow!.bounds.width
    
        if width > Tools.MinWidthForStaticSideBar(){
            self.bounds.size.width = width - (margin * 2.00)
            var cornerRadius:CGFloat = 5.0;
            
            if indexPath.row < numberOfRowsInSection-1 && self.bounds.width > 400
            {
                var seperator:UIView = UIView(frame: CGRect(x: 15, y: self.bounds.height - 0.5, width: self.bounds.width - CGFloat(15), height: 0.5))
                seperator.backgroundColor = UITableView().separatorColor
                self.addSubview(seperator)
            }
            
            if indexPath.row == 0{
                let maskLayer = CAShapeLayer()
                maskLayer.path = UIBezierPath(roundedRect: bounds, byRoundingCorners: .TopLeft | .TopRight, cornerRadii: CGSize(width: cornerRadius, height: cornerRadius)).CGPath
                layer.mask = maskLayer;
                
            }
            if indexPath.row == numberOfRowsInSection-1{
                let maskLayer = CAShapeLayer()
                maskLayer.path = UIBezierPath(roundedRect: bounds, byRoundingCorners: .BottomLeft | .BottomRight, cornerRadii: CGSize(width: cornerRadius, height: cornerRadius)).CGPath
                layer.mask = maskLayer;
            }
            if indexPath.row == 0 && indexPath.row == numberOfRowsInSection-1{
                let maskLayer = CAShapeLayer()
                maskLayer.path = UIBezierPath(roundedRect: bounds, byRoundingCorners: .TopLeft | .TopRight | .BottomLeft | .BottomRight, cornerRadii: CGSize(width: cornerRadius, height: cornerRadius)).CGPath
                layer.mask = maskLayer;
                
            }
        }
        
        
        
        //self.selectedBackgroundView = testView.mutableCopy() as UIView
        //self.selectedBackgroundView.backgroundColor = UIColor.blueColor()
        
        super.layoutSubviews()
        
        //var indexPath:NSIndexPath = (self.superview! as UITableView).indexPathForCell(self)!
    }
    
    class func HeaderViewForCell(tableView:UITableView, section:Int, title:String, style:String?) -> UIView{
        var m = tableView.bounds.width > Tools.MinWidthForStaticSideBar() ? margin : 15
        
        var container = UIView(frame: CGRect(x: m, y: 0, width: tableView.frame.size.width - (m * 2), height: 50))
        var sectionView:UITableViewHeaderFooterView = UITableViewHeaderFooterView(frame: CGRect(x: 0, y: 0, width: container.frame.size.width, height: 50))
        
        var offset:CGFloat = section == 0 ? 0 : CGFloat(1) * 18
        var sectionHeader = UILabel(frame: CGRect(x: m, y: (15 - offset), width: sectionView.frame.size.width, height: 50))
        
        if style == nil{
            sectionHeader.text = title.uppercaseString
            sectionHeader.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 13)
            sectionHeader.font = UIFont.systemFontOfSize(13)
        }
        else{
            sectionHeader.text = title
            sectionHeader.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 15)
        }
        
        sectionHeader.textColor = UIColor.darkGrayColor()
        sectionView.addSubview(sectionHeader)
        container.addSubview(sectionView)
        
        return container;
    }
    
    class func ApplyTableViewStyles(tableView:UITableView){
        if tableView.bounds.width > Tools.MinWidthForStaticSideBar(){
            tableView.separatorColor = UIColor.clearColor()
        }
        else{
            tableView.separatorColor = UITableView().separatorColor
        }
        
        //tableView.frame = CGRect(x: tableView.frame.origin.x + 30, y: tableView.frame.origin.y, width: tableView.frame.width - 60, height: tableView.frame.height)
        //tableView.superview?.backgroundColor = UIColor.groupTableViewBackgroundColor()
    }
    
}
