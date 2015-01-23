//
//  CalenderControl.swift
//  LessonManager_Jan_15
//
//  Created by Alex Bechmann on 14/01/2015.
//  Copyright (c) 2015 Alex Bechmann. All rights reserved.
//

import UIKit

@objc protocol CalenderControlDelegate{
    optional func calenderControlDidSelectDate(date:NSDate)
    func calenderControlShouldShowIndicator(date:NSDate) -> Bool
    optional func calenderControlDidChangeMonth(toMonth:NSDate)
    optional func calenderControlDidChangeMode()
}

class CalenderControl: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UIPopoverPresentationControllerDelegate {
    var date = NSDate()
    var selectedDate = NSDate()
    
    var monthContainer:UIView = UIView()
    //var monthViews:Array<UIView> = []
    var monthView:UICollectionView? = nil
    
    var weekContainer:UIView = UIView()
    var originView:UIView = UIView()
    var navigationItem:UINavigationItem? = nil
    
    //var monthCollectionViews:Array<UICollectionView> = []
    var firstDateOfMonth = NSDate()
    
    var nav:UINavigationController? = nil
    var popover:UIPopoverPresentationController? = nil
    //var selectedCell:CalenderMonthCollectionViewCell? = nil
    var selectedCellIndexPath:NSIndexPath? = nil
    
    var delegate:CalenderControlDelegate? = nil
    var isMonthMode = false
    var hasLoaded = false
    
    init(origin:UIView, navigationItem:UINavigationItem){
        var frame = CGRect(x: origin.bounds.origin.x, y: origin.bounds.origin.y, width: origin.bounds.width, height: 275)
        super.init(frame:frame)
        originView = origin
        layoutViews(true)
        self.navigationItem = navigationItem
        self.navigationItem?.title = Tools.StringFromDate(date, format: "MMMM, yyyy")
        
        let showGestureRecognizer = UISwipeGestureRecognizer(target: self, action: "handleSwipe:")
        showGestureRecognizer.direction = UISwipeGestureRecognizerDirection.Right
        self.addGestureRecognizer(showGestureRecognizer)
        
        let hideGestureRecognizer = UISwipeGestureRecognizer(target: self, action: "handleSwipe:")
        showGestureRecognizer.direction = UISwipeGestureRecognizerDirection.Left
        self.addGestureRecognizer(hideGestureRecognizer)
        
//        let hideMonthGestureRecognizer = UISwipeGestureRecognizer(target: self, action: "handleSwipe:")
//        showGestureRecognizer.direction = UISwipeGestureRecognizerDirection.Up
//        originView.addGestureRecognizer(hideGestureRecognizer)
//        
//        let showMonthGestureRecognizer = UISwipeGestureRecognizer(target: self, action: "handleSwipe:")
//        showGestureRecognizer.direction = UISwipeGestureRecognizerDirection.Down
//        originView.addGestureRecognizer(hideGestureRecognizer)
        
        
        
        
        firstDateOfMonth = Tools.GetFirstDateOfMonthFromDate(date).dateAtStartOfWeek()
        self.monthView = createCollectionView(frame)
        self.monthContainer.clipsToBounds = true
        
        hasLoaded = true
        
//        self.setTranslatesAutoresizingMaskIntoConstraints(false)
//        monthContainer.setTranslatesAutoresizingMaskIntoConstraints(false)
//        self.addLeftConstraint(toView: self.superview!, attribute: NSLayoutAttribute.Leading, relation:NSLayoutRelation.Equal, constant: 0)
//        self.addRightConstraint(toView: self.superview!, attribute: NSLayoutAttribute.Trailing, relation:NSLayoutRelation.Equal, constant: 0)
//        monthContainer.addLeftConstraint(toView: monthContainer.superview!, attribute: NSLayoutAttribute.Leading, relation:NSLayoutRelation.Equal, constant: 0)
//        monthContainer.addRightConstraint(toView: monthContainer.superview!, attribute: NSLayoutAttribute.Trailing, relation:NSLayoutRelation.Equal, constant: 0)
        
    }
    
    func setIsMonthMode(var b:Bool){
        isMonthMode = b
        if !isMonthMode{
            firstDateOfMonth = selectedDate.dateAtStartOfWeek()
        }
        else{
            firstDateOfMonth = Tools.GetFirstDateOfMonthFromDate(date).dateAtStartOfWeek()
        }
        layoutViews(false)
        monthView?.collectionViewLayout.invalidateLayout()
        monthView?.reloadData()
    }
    
    func createEmptyCollectionView(frame:CGRect) -> UICollectionView{
        var flowLayout = UICollectionViewFlowLayout()
        //flowLayout.scrollDirection = UICollectionViewScrollDirection.Horizontal
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 0
        
        var collectionView = UICollectionView(frame: frame, collectionViewLayout: flowLayout)
        return collectionView
    }
    
    func createCollectionView(frame:CGRect) -> UICollectionView{
        firstDateOfMonth = isMonthMode ? Tools.GetFirstDateOfMonthFromDate(date).dateAtStartOfWeek() : date.dateAtStartOfWeek()
        var flowLayout = UICollectionViewFlowLayout()
        //flowLayout.scrollDirection = UICollectionViewScrollDirection.Horizontal
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 0
        
        var collectionView = UICollectionView(frame: frame, collectionViewLayout: flowLayout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.registerNib(UINib(nibName: "CalenderMonthCellCollectionViewCellXib", bundle: nil), forCellWithReuseIdentifier: "CalenderMonthCollectionViewCell")
        collectionView.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        collectionView.scrollEnabled = false
        self.monthContainer.addSubview(collectionView)
        //collectionView.reloadData()
        collectionView.backgroundColor = UIColor.clearColor()
        return collectionView
    }
    
    func handleSwipe(recognizer:UISwipeGestureRecognizer){
        if(recognizer.direction == UISwipeGestureRecognizerDirection.Right){
            previousMonth()
        }
        else if(recognizer.direction == UISwipeGestureRecognizerDirection.Left){
            nextMonth()
        }
    
    }
    
    func onDidRotate(){
        self.frame = self.isMonthMode ? CGRect(x: 0, y: 0, width: originView.bounds.width, height: 275) : CGRect(x: 0, y: 0, width: self.originView.bounds.width, height: 60);
        self.monthContainer.frame = self.isMonthMode ? CGRect(x: 0, y: 0, width: originView.bounds.width, height: 275) : CGRect(x: 0, y: 0, width: self.originView.bounds.width, height: 60);
        self.reloadActiveCollectionViewData()
    }
    
    func layoutViews(var isFirstTime:Bool){
        if !isFirstTime{
            //monthViews = []
            //monthContainer.removeFromSuperview()
        }
        
        UIView.animateWithDuration(0.6, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.1, options: UIViewAnimationOptions.BeginFromCurrentState, animations: { () -> Void in
            
            self.frame = self.isMonthMode ? CGRect(x: 0, y: 0, width: self.originView.bounds.width, height: 275) : CGRect(x: 0, y: 0, width: self.bounds.width, height: 60);
            self.monthContainer.frame = self.isMonthMode ? CGRect(x: 0, y: 0, width: self.originView.bounds.width, height: 275) : CGRect(x: 0, y: 0, width: self.originView.bounds.width, height: 60);
            
            }, completion: {success in
                //self.delegate?.calenderControlDidChangeMode!()
        })
        
        delegate?.calenderControlDidChangeMode!()
        
        
        
        //weekContainer.frame = CGRect(x: frame.origin.x, y: frame.origin.y, width: frame.width, height: frame.height / 2)
        
        self.backgroundColor = LMColor.purpleColor()
        
        if isFirstTime{
            self.addSubview(monthContainer)

            originView.addSubview(self)
        }
        
        
    }
    
    func previousMonth(){
        date = isMonthMode ? date.dateBySubtractingMonths(1) : date.dateBySubtractingDays(7)
        navigationItem?.title = Tools.StringFromDate(date, format: "MMMM, yyyy")
        
        var newMonthView = self.createCollectionView(CGRect(x: self.frame.origin.x - self.frame.width, y: self.frame.origin.y, width: self.frame.width, height: self.frame.height))
        UIView.animateWithDuration(0.6, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.1, options: UIViewAnimationOptions.BeginFromCurrentState, animations: { () -> Void in
            
            self.monthView!.frame.origin = CGPoint(x: 0 + self.monthView!.frame.width, y: 0)
            newMonthView.frame.origin = CGPoint(x: 0, y: 0)
            
            }, completion: {success in
                self.monthView!.removeFromSuperview()
                self.monthView! = newMonthView
                self.delegate?.calenderControlDidChangeMonth?(self.date)
        })
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), { // bg thread not used right now
            dispatch_async(dispatch_get_main_queue()) {
                
            }
        })
    }
    
    func nextMonth(){
        date = isMonthMode ? date.dateByAddingMonths(1) : date.dateByAddingDays(7)
        navigationItem?.title = Tools.StringFromDate(date, format: "MMMM, yyyy")
        
        
        var newMonthView = createCollectionView(CGRect(x: frame.origin.x + frame.width, y: frame.origin.y, width: frame.width, height: frame.height))
        
        UIView.animateWithDuration(0.6, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.1, options: UIViewAnimationOptions.BeginFromCurrentState, animations: { () -> Void in
            
            self.monthView!.frame.origin = CGPoint(x: 0 - self.monthView!.frame.width, y: 0)
            newMonthView.frame.origin = CGPoint(x: 0, y: 0)
            
            }, completion: {success in
                self.monthView!.removeFromSuperview()
                self.monthView! = newMonthView
                self.delegate?.calenderControlDidChangeMonth?(self.date)
        })
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    /* layout */
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CalenderMonthCollectionViewCell", forIndexPath: indexPath) as CalenderMonthCollectionViewCell
        
        cell.resetCellIndicator()
        
        let cellDate:NSDate = firstDateOfMonth.dateByAddingDays(indexPath.row)
        
        cell.dayLabel.text = Tools.StringFromDate(cellDate, format: "d")
        cell.backgroundColor = UIColor.whiteColor()
        cell.dayLabel.backgroundColor = UIColor.clearColor()
        cell.dayLabel.textColor = UIColor.whiteColor()
        cell.dayLabel.layer.cornerRadius = cell.dayLabel.frame.width / 2;
        cell.dayLabel.layer.masksToBounds = true;
        cell.cellDate = cellDate
        
        if Tools.CompareDates(selectedDate.dateAtStartOfDay(), date2: cellDate.dateAtStartOfDay()) == DateComparison.Same{
            cell.dayLabel.textColor = LMColor.darkPurpleColor()
            cell.dayLabel.backgroundColor = UIColor.whiteColor()
            
            selectedCellIndexPath = indexPath
            
        }
        else if Tools.CompareDates(cellDate.dateAtStartOfDay(), date2: NSDate().dateAtStartOfDay()) == DateComparison.Same{
            cell.dayLabel.backgroundColor = LMColor.lightPurpleColor()
        }
        
        //cell.selectedBackgroundView = UIView(frame: cell.bounds)
        //cell.selectedBackgroundView.backgroundColor = LMColor.darkPurpleColor()
        cell.backgroundColor = UIColor.clearColor()
        
        if cellDate.month() != date.month() && isMonthMode{
            cell.dayLabel.textColor = LMColor.grayedPurpleColor()
        }
        
        if (delegate != nil){
            if delegate!.calenderControlShouldShowIndicator(cellDate){
                cell.addCellIndicator()
            }
        }
        
        return cell
    }

    
    
    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAtIndex section: Int) -> UIEdgeInsets{
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize
    {
        var width:CGFloat = self.bounds.width / 7
        var height:CGFloat = isMonthMode ? self.bounds.height / 6 : self.bounds.height
        return CGSize(width: width , height: height)
        
        //return collectionView.bounds.size
    }
    
    // MARK: UICollectionViewDataSource
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        //#warning Incomplete method implementation -- Return the number of sections
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //#warning Incomplete method implementation -- Return the number of items in the section
        return isMonthMode ? 42 : 7
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        var cell = collectionView.cellForItemAtIndexPath(indexPath) as CalenderMonthCollectionViewCell
        selectedDate = cell.cellDate!
        delegate?.calenderControlDidSelectDate?(date)
        
//        var popoverContent = AgendaMasterTableViewController()
//        popoverContent.date = cell.cellDate!
//        nav = UINavigationController(rootViewController: popoverContent)
//        nav!.view.backgroundColor = UIColor.clearColor()
//        nav!.modalPresentationStyle = UIModalPresentationStyle.Popover
//        popover = nav!.popoverPresentationController
//        popoverContent.preferredContentSize = CGSizeMake(320,480)
//        //popoverContent.tableView.backgroundColor = UIColor.clearColor()
//        popover!.delegate = self
//        popover!.sourceView = collectionView.cellForItemAtIndexPath(indexPath)
//        popover!.sourceRect = collectionView.cellForItemAtIndexPath(indexPath)!.bounds
//        
//        
//        
//        //tap recognizer
//        if 1 == 2 { // self.view.bounds.width < Tools.MinWidthForStaticSideBar(){
//            let tapGesture = UITapGestureRecognizer(target: self, action: "closePopover")
//            tapGesture.numberOfTapsRequired = 2
//            popoverContent.view.addGestureRecognizer(tapGesture)
//            popoverContent.doubleTapEnabled = true
//        }
//        
//        //if self.view.bounds.width > Tools.MinWidthForStaticSideBar(){
//        popoverContent.navigationItem.leftBarButtonItem =
//            UIBarButtonItem(title: "Close", style: .Bordered, target: self, action: "closePopover")
//        Tools.TopMostController().presentViewController(nav!, animated: true, completion: nil)

        //clearFormattingForCollectionViewCells()
        //monthView?.reloadData()
        cell.dayLabel.textColor = LMColor.darkPurpleColor()
        cell.dayLabel.backgroundColor = UIColor.whiteColor()
        
        if self.selectedCellIndexPath != nil{
            //if monthView!.indexPathForCell(self.selectedCell!) != nil{
                monthView?.reloadItemsAtIndexPaths([selectedCellIndexPath!])
            //}
        }
        
        selectedCellIndexPath = indexPath
    }
    
    
    func reloadActiveCollectionViewData(){
        self.monthView!.reloadData()
    }
}
