//
//  EditingTextFieldTableViewCell.swift
//  LessonManager_Jan_15
//
//  Created by Alex Bechmann on 05/01/2015.
//  Copyright (c) 2015 Alex Bechmann. All rights reserved.
//

import UIKit

class EditingTextFieldTableViewCell: UITableViewCell {

    var textField:UITextField = UITextField()
    
    var containerView:UIView = UIView()
    var indexPath:NSIndexPath = NSIndexPath()
    var numberOfRowsInSection = 0
    var margined:Bool = false
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        var editView:UIView = UIView()
        editView = UIView(frame: CGRect(x: 0, y: 0, width: self.bounds.width - 155, height: self.bounds.height))
        textField = UITextField(frame: CGRect(x: editView.bounds.origin.x, y: editView.frame.origin.y, width: editView.bounds.width - 20, height: editView.bounds.height))
        textField.textAlignment = NSTextAlignment.Right
        //textField.textColor = UIColor.grayColor()
        editView.addSubview(textField)
        self.editingAccessoryView = editView
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func didTransitionToState(state: UITableViewCellStateMask){
        super.didTransitionToState(state)
        self.setNeedsLayout()
        //self.layoutSubviews()
    }
    
    override func layoutSubviews() {
        //margined
        var width:CGFloat = containerView.bounds.width
        if width > Tools.MinWidthForStaticSideBar() && margined{
            self.bounds.size.width = width - (margin * 2.00)
            //self.bounds = CGRect(x: width - ((margin * 2.00) / 2) , y:0, width: width - (margin * 2.00), height:self.bounds.height)
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
            layer.shouldRasterize = true;
            layer.rasterizationScale = UIScreen.mainScreen().scale;
        }

        super.layoutSubviews()
        self.selectionStyle = UITableViewCellSelectionStyle.None
        self.textField.text = self.detailTextLabel?.text
        self.clipsToBounds = true
        
        if self.editing{
            self.detailTextLabel!.alpha = 0
            self.detailTextLabel?.hidden = true
        }
        else{
            self.detailTextLabel?.hidden = false
            UIView.animateWithDuration(0.2, animations: { () -> Void in
                self.detailTextLabel!.alpha = 1
            })
        }
        self.textField.placeholder = "Enter here"
    }
    
    func valueForTextField() -> String{
        return self.textField.text
    }
    
    
}


