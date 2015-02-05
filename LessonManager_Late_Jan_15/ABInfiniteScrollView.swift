//
//  ABInfiniteScrollView.swift
//  InfiniteScrollView
//
//  Created by Alex Bechmann on 01/02/2015.
//  Copyright (c) 2015 Alex Bechmann. All rights reserved.
//

import UIKit

enum ABInfiniteScrollDirection:Int{
    case None = 0
    case Left = 1
    case Right = 2
}

protocol ABInfiniteScrollViewDelegate{
    func infiniteScrollViewDidScroll(direction:ABInfiniteScrollDirection)
    func infiniteScrollViewNewView(frame:CGRect, pageFrame:CGRect) -> UIView
}

class ABInfiniteScrollView: UIScrollView, ABInfiniteScrollViewDelegate {
    
    //var colors = [UIColor.yellowColor(), UIColor.blueColor(), UIColor.redColor(), UIColor.yellowColor(), UIColor.blueColor()]
    var views:Array<UIView> = []
    var previousContentOffset:CGPoint = CGPointZero
    var currentViewPositionIndex = 0
    var infinteScrollDelegate:ABInfiniteScrollViewDelegate? = nil
    var setup = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentSize = CGSizeMake(self.bounds.width * 5, self.frame.size.height);
        self.pagingEnabled = true
        
        var startPosition:CGFloat = 0
        for (var i:CGFloat = 0; i < 5; i++){
            var plus:CGFloat = self.bounds.width * i
            var v = UIView(frame: CGRect(x: startPosition + plus, y: 0, width: self.bounds.width, height: self.bounds.height))
            //v.backgroundColor = colors[Int(i)]
            self.views.append(v)
            self.addSubview(v)
        }
        
        self.contentOffset = CGPointMake(self.bounds.width * 2, 0);
        currentViewPositionIndex = 2
        self.infinteScrollDelegate = self
        self.showsHorizontalScrollIndicator = false
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // recenter content periodically to achieve impression of infinite scrolling
    func recenterIfNecessary()
    {
        var currentOffset:CGPoint = self.contentOffset
        var contentWidth:CGFloat = self.contentSize.width
        var centerOffsetX:CGFloat = (contentWidth - self.bounds.size.width) / 2.0
        var distanceFromCenter:CGFloat = fabs(currentOffset.x - centerOffsetX);
        var positionFromCenter:CGFloat = currentOffset.x - centerOffsetX
        
        var direction = ABInfiniteScrollDirection.None
        if self.contentOffset.x > previousContentOffset.x{
            direction = .Right
        }
        else{
            direction = .Left
        }
        
        var o = direction == .Left ? 0 : self.bounds.width - 1
        if distanceFromCenter > self.bounds.width && self.contentOffset.x < (self.contentSize.width / 2){
            self.contentOffset = CGPointMake(self.bounds.width * 4, currentOffset.y);
            for v in self.views[4].subviews{
                v.removeFromSuperview()
            }
            for v in self.views[1].subviews{
                self.views[4].addSubview(v as UIView)
            }
            
        }
        else if distanceFromCenter > self.bounds.width * 2 && self.contentOffset.x > (self.contentSize.width / 2){
            self.contentOffset = CGPointMake(self.bounds.width * 1, currentOffset.y);
            for v in self.views[1].subviews{
                v.removeFromSuperview()
            }
            for v in self.views[4].subviews{
                self.views[1].addSubview(v as UIView)
            }
        }
        
        previousContentOffset = self.contentOffset
        
        var newViewPositionIndex = Int((self.contentOffset.x + o) / self.bounds.width) - 1
        var hasChangedUsefulValue = true
        if newViewPositionIndex == 3 && currentViewPositionIndex == 0{
            hasChangedUsefulValue = false
        }
        if newViewPositionIndex == 0 && currentViewPositionIndex == 3{
            hasChangedUsefulValue = false
        }
        
        if hasChangedUsefulValue && newViewPositionIndex != currentViewPositionIndex && !(newViewPositionIndex < 0) && !(newViewPositionIndex > 3){
            currentViewPositionIndex = newViewPositionIndex
            if setup{
                infinteScrollDelegate?.infiniteScrollViewDidScroll(direction)
            }
            replaceView()
            setup = true
            
        }
        
    }
    
    func replaceView(){
        var oldView = self.views[currentViewPositionIndex + 1]
        oldView.removeFromSuperview()
        var useableFrame = CGRect(x: 0, y: 0, width: oldView.bounds.width, height: oldView.bounds.height)
        var v = infinteScrollDelegate!.infiniteScrollViewNewView(oldView.frame, pageFrame:useableFrame)
        v.frame = oldView.frame
        self.views[currentViewPositionIndex + 1] = v
        self.addSubview(v)
    }
    
    func infiniteScrollViewNewView(frame:CGRect, pageFrame:CGRect) -> UIView {
        var rc = UIView(frame: frame)
        rc.backgroundColor = UIColor.blackColor()
        return rc
    }
    
    override func layoutSubviews() {
        self.recenterIfNecessary()
    }
    
    func infiniteScrollViewDidScroll(direction: ABInfiniteScrollDirection) {
    }
    
}
