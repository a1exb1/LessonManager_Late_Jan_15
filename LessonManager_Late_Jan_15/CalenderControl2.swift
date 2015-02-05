//
//  CalenderControl2.swift
//  LessonManager_Late_Jan_15
//
//  Created by Alex Bechmann on 01/02/2015.
//  Copyright (c) 2015 Alex Bechmann. All rights reserved.
//

import UIKit

@objc protocol CalenderControlDelegate{
    optional func calenderControlDidSelectDate(date:NSDate)
    func calenderControlShouldShowIndicator(date:NSDate) -> Bool
    optional func calenderControlDidChangeMonth(toMonth:NSDate)
    optional func calenderControlDidChangeMode()
}

class CalenderControl2: ABInfiniteScrollView, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var date = NSDate()
    var selectedDate = NSDate()
    var firstDateOfMonth = NSDate()
    var isMonthMode = true
    var calenderControlDelegate:CalenderControlDelegate? = nil
    var originView = UIView()
    
    var selectedCellIndexPath:NSIndexPath? = nil
    var navigationItem:UINavigationItem? = nil
    var monthView:UICollectionView? = nil
    
    convenience init(origin:UIView, navigationItem:UINavigationItem){
        var frame = CGRect(x: origin.bounds.origin.x, y: origin.bounds.origin.y, width: origin.bounds.width, height: 275)
        self.init(frame: frame)

        self.originView = origin
        self.navigationItem = navigationItem
        self.originView.addSubview(self)
        self.backgroundColor = LMColor.purpleColor()
        self.navigationItem?.title = Tools.StringFromDate(date, format: "MMMM, yyyy")
    }
    
    override func infiniteScrollViewDidScroll(direction: ABInfiniteScrollDirection) {
        for view in self.views{
            //do what you want with hidden views
        }
        
        date = direction == .Left ? date.dateBySubtractingMonths(1) : date.dateByAddingMonths(1)
        firstDateOfMonth = Tools.GetFirstDateOfMonthFromDate(date).dateAtStartOfWeek()
        navigationItem?.title = Tools.StringFromDate(date, format: "MMMM, yyyy")
    }
    
    override func infiniteScrollViewNewView(frame:CGRect, pageFrame:CGRect) -> UIView {
        var rc = UIView(frame: frame)
        
        //monthView?.removeFromSuperview()
        //Tools.AddLoaderToView(rc)
        self.monthView = self.createCollectionView(pageFrame)
        rc.addSubview(self.monthView!)
        //Tools.HideLoaderFromView(rc)

        return rc
    }
    
    func selectDate(date: NSDate){
        println("not implemeted")
    }
    
    func nextMonth(){
        
    }
    
    func previousMonth(){
        
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
        //collectionView.registerNib(UINib(nibName: "CalenderMonthCellCollectionViewCellXib", bundle: nil), forCellWithReuseIdentifier: "CalenderMonthCollectionViewCell")
        collectionView.registerClass(CalenderMonthCollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        collectionView.scrollEnabled = false
        //self.monthContainer.addSubview(collectionView)
        //collectionView.reloadData()
        collectionView.backgroundColor = UIColor.clearColor()
        return collectionView
    }
    
    //COLLECTION VIEW DELEGATE
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as CalenderMonthCollectionViewCell

        let cellDate:NSDate = firstDateOfMonth.dateByAddingDays(indexPath.row)
        cell.cellDate = cellDate
        //var padding:CGFloat = 5
        
        cell.resetCellIndicator()
        if cell.dayLabel == nil{
            cell.dayLabel = UILabel(frame:CGRect(x: 0, y: 0, width: 30, height: 30))
            cell.dayLabel!.textAlignment = NSTextAlignment.Center
            cell.dayLabel!.setTranslatesAutoresizingMaskIntoConstraints(false)
            cell.addSubview(cell.dayLabel!)
            cell.dayLabel!.addCenterXConstraint(toView: cell.dayLabel!.superview)
            cell.dayLabel!.addCenterYConstraint(toView: cell.dayLabel!.superview)
            cell.dayLabel!.addHeightConstraint(relation: NSLayoutRelation.Equal, constant: 30)
            cell.dayLabel!.addWidthConstraint(relation: NSLayoutRelation.Equal, constant: 30)
            //cell.dayLabel!.setNeedsUpdateConstraints()
            cell.layer.shouldRasterize = true
            cell.layer.rasterizationScale = UIScreen.mainScreen().scale
        }
        
        cell.dayLabel!.backgroundColor = UIColor.clearColor()
        cell.dayLabel!.textColor = UIColor.whiteColor()
        cell.dayLabel!.text = Tools.StringFromDate(cellDate, format: "d")
        
        if cellDate.month() != date.month() && isMonthMode{
            cell.dayLabel!.textColor = LMColor.grayedPurpleColor()
        }
        
        if Tools.CompareDates(selectedDate.dateAtStartOfDay(), date2: cellDate.dateAtStartOfDay()) == DateComparison.Same{
            cell.dayLabel!.textColor = LMColor.darkPurpleColor()
            cell.dayLabel!.backgroundColor = UIColor.whiteColor()
            cell.dayLabel!.layer.cornerRadius = cell.dayLabel!.frame.width / 2;
            cell.dayLabel!.layer.masksToBounds = true;
            selectedCellIndexPath = indexPath
            
        }
        else if Tools.CompareDates(cellDate.dateAtStartOfDay(), date2: NSDate().dateAtStartOfDay()) == DateComparison.Same{
            cell.dayLabel!.backgroundColor = LMColor.lightPurpleColor()
            cell.dayLabel!.textColor = UIColor.whiteColor()
            cell.dayLabel!.layer.cornerRadius = cell.dayLabel!.frame.width / 2;
            cell.dayLabel!.layer.masksToBounds = true;
        }

        cell.backgroundColor = UIColor.clearColor()
        
        if (calenderControlDelegate != nil){
            if calenderControlDelegate!.calenderControlShouldShowIndicator(cellDate){
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
        calenderControlDelegate?.calenderControlDidSelectDate?(date)

        collectionView.deselectItemAtIndexPath(indexPath, animated: false)
        
        if self.selectedCellIndexPath != nil{
            //if monthView!.indexPathForCell(self.selectedCell!) != nil{
            if selectedCellIndexPath! != indexPath{
                monthView?.reloadItemsAtIndexPaths([selectedCellIndexPath!, indexPath])
            }
            
            //}
        }
        selectedCellIndexPath = indexPath
        //self.monthView?.reloadData()
        //reloadActiveCollectionViewData()
    }
    
    
    func reloadActiveCollectionViewData(){
        if monthView != nil{
            var superview:UIView = monthView!.superview!
            monthView!.removeFromSuperview()
            monthView = createCollectionView(CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height))
            superview.addSubview(monthView!)
        }
    }
    
    func onDidRotate(){
        self.frame = self.isMonthMode ? CGRect(x: 0, y: 0, width: originView.bounds.width, height: 275) : CGRect(x: 0, y: 0, width: self.originView.bounds.width, height: 60);
        //self.monthContainer.frame = self.isMonthMode ? CGRect(x: 0, y: 0, width: originView.bounds.width, height: 275) : CGRect(x: 0, y: 0, width: self.originView.bounds.width, height: 60);
        self.reloadActiveCollectionViewData()
    }
}
