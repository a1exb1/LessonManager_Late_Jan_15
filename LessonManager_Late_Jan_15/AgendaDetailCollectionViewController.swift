//
//  AgendaCollectionViewController.swift
//  LessonManager_Jan_15
//
//  Created by Alex Bechmann on 01/01/2015.
//  Copyright (c) 2015 Alex Bechmann. All rights reserved.
//

import UIKit

class AgendaDetailCollectionViewController: UICollectionViewController, SessionDelegate, AgendaAttendenceCollectionViewCellDelegate {

    var lesson:Lesson? = nil
    //var splitView:SplitView? = nil
    //var masterView:AgendaMasterTableViewController? = nil
    var lessonCount:Int = 0
    var viewDidAppear:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView?.backgroundColor = UIColor.groupTableViewBackgroundColor();
 
        collectionView!.registerNib(UINib(nibName: "AgendaStudentCollectionViewCellXib", bundle: nil), forCellWithReuseIdentifier: "StudentCollectionViewCell")
        collectionView!.registerNib(UINib(nibName: "AgendaLessonCollectionViewCellXib", bundle: nil), forCellWithReuseIdentifier: "LessonCollectionViewCell")
        collectionView!.registerNib(UINib(nibName: "AgendaAttendenceCollectionViewCellXib", bundle: nil), forCellWithReuseIdentifier: "AttendenceCollectionViewCell")

        //self.navigationItem.rightBarButtonItems =
//        [UIBarButtonItem(image: UIImage(named: "766-arrow-right-toolbar"), style: UIBarButtonItemStyle.Bordered, target: self, action: ""),
//        UIBarButtonItem(image: UIImage(named: "765-arrow-left-toolbar"), style: UIBarButtonItemStyle.Bordered, target: self, action: "")]
        
        self.navigationController?.navigationBar.translucent = false
        session.agendaDetailDelegate = self
    }
    
    func detailNeedsUpdate(){
        reload(false)
    }
    
    func reload(var triggerMaster:Bool){
        lesson?.Load(){ response in
            println("")
            self.collectionView?.reloadData()
            if triggerMaster{
                if Tools.Device() == .Pad{
                    session.agendaMasterDelegate?.masterNeedsUpdate?()
                }
            }
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        //splitView?.addDetailMenuButtonToNavigationBar(self.navigationItem, button: UIBarButtonItem(title: "Agenda", style: UIBarButtonItemStyle.Bordered, target: nil, action: nil))
        
        super.viewDidAppear(animated)
        reload(viewDidAppear)
        self.viewDidAppear = true
    }
    
    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAtIndex section: Int) -> UIEdgeInsets{
            return UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
    }
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        //#warning Incomplete method implementation -- Return the number of sections
        return self.lesson == nil ? 0 : 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //#warning Incomplete method implementation -- Return the number of items in the section
        return lesson == nil ? 0 : 3
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        var cell:UICollectionViewCell = UICollectionViewCell()
        
        var borderHeight:CGFloat = 3
        
        switch indexPath.row{
        
        case 0:
            cell = collectionView.dequeueReusableCellWithReuseIdentifier("LessonCollectionViewCell", forIndexPath: indexPath) as AgendaLessonCollectionViewCell
            cell.backgroundColor = UIColor.whiteColor()
            (cell as AgendaLessonCollectionViewCell).setup(lesson!)
            Tools.AddTopBorderToView(cell.viewForBaselineLayout()!, color:LMColor.maroonColor(), height:borderHeight)
            break
            
        case 1:
            cell = collectionView.dequeueReusableCellWithReuseIdentifier("StudentCollectionViewCell", forIndexPath: indexPath) as AgendaStudentCollectionViewCell
            
            //Tools.AddShadowToView(cell.viewForBaselineLayout()!)
            cell.backgroundColor = UIColor.whiteColor()
            (cell as AgendaStudentCollectionViewCell).setup(lesson!.student)
            Tools.AddTopBorderToView(cell.viewForBaselineLayout()!, color:LMColor.navyColor(), height:borderHeight)
            (cell as AgendaStudentCollectionViewCell).tableView.reloadData()
            break
            
        case 2:
            cell = collectionView.dequeueReusableCellWithReuseIdentifier("AttendenceCollectionViewCell", forIndexPath: indexPath) as UICollectionViewCell
            cell.backgroundColor = UIColor.whiteColor()
            (cell as AgendaAttendenceCollectionViewCell).setup(lesson!)
            (cell as AgendaAttendenceCollectionViewCell).delegate = self
            Tools.AddTopBorderToView(cell.viewForBaselineLayout()!, color:LMColor.greenColor(), height:borderHeight)
            break
            
        default:
            
            
            break
        }
        
        return cell
    }

    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize
    {
        var height:CGFloat = 200
        
        if indexPath.row == 0{
            //height = 90
        }
        
        //return CGSize(width: 220, height: 160)
        if (self.view.bounds.width < 500){
            return CGSize(width: self.view.bounds.width - 30, height: height)
        }
        else{
            var boundsWidth:CGFloat = self.view.bounds.width
            var width:CGFloat = 300
            width = (boundsWidth / 2) - 20;
//            if boundsWidth < 700{
//                width = (boundsWidth / 2) - 20;
//            }
//            else{
//                width = (boundsWidth / 3) - 20;
//            }
            return CGSize(width: width, height: height)
        }
        
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.row{
        case 0: editLesson(); break
        case 1: editStudent(); break

        default:
            break
        }
    }

    
    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
    
    }
    */
    
    func selectLesson(lesson:Lesson, index:Int){
        self.lesson = lesson
        self.title = "Lesson " + String(index + 1) + " of " + String(lessonCount)
        collectionView?.reloadData()
        //scrollToTop()
        //masterView?.tableView.selectRowAtIndexPath(NSIndexPath(forRow: index, inSection: 0), animated: true, scrollPosition: UITableViewScrollPosition.None)
        
    }
    
    func scrollToTop(){
        var compensateHeight:CGFloat = -(self.navigationController!.navigationBar.bounds.size.height + UIApplication.sharedApplication().statusBarFrame.size.height);
        collectionView?.setContentOffset(CGPointMake(0, compensateHeight), animated: true)
    }
    
    override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
        collectionView?.collectionViewLayout.invalidateLayout()
    }
    
    func editStudent(){
        var navigationController = UINavigationController()
        var view:SaveStudentTableViewController = SaveStudentTableViewController()
        view.student = lesson!.student
        self.navigationController?.pushViewController(view, animated: true)
        
    }
    
    func editLesson(){
        var s = UIStoryboard(name: "Main", bundle: nil)
        var v = s.instantiateViewControllerWithIdentifier("SaveLessonView") as
            SaveLessonViewController!
        v.lesson = lesson!
        self.navigationController?.pushViewController(v, animated: true)
        
    }
    
    func agendaAttendenceCellDidChangeAttendence(status:LessonStatus){
        lesson?.Status = status
        reload(false)
    }

}
