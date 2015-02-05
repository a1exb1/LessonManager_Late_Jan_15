//
//  CalenderWeekWebViewController.swift
//  LessonManager_Late_Jan_15
//
//  Created by Alex Bechmann on 02/02/2015.
//  Copyright (c) 2015 Alex Bechmann. All rights reserved.
//

import UIKit

protocol CalenderWeekWebViewDelegate{
    func calenderWeekWebViewDidChangeDate(date: NSDate)
}

class CalenderWeekWebViewController: UIViewController, CalenderScrollViewDelegate {

    var toolbar = UIToolbar()
    var scrollView:CalenderScrollView? = nil
    var calenderModeControl = UISegmentedControl()
    var tutor = Tutor()
    var selectedDate = NSDate()
    var delegate:CalenderWeekWebViewDelegate? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.toolbar.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.view.addSubview(toolbar)
        toolbar.addBottomConstraint(toView: toolbar.superview, relation: NSLayoutRelation.Equal, constant: 0)
        toolbar.addLeftConstraint(toView: toolbar.superview, relation: NSLayoutRelation.Equal, constant: 0)
        toolbar.addRightConstraint(toView: toolbar.superview, relation: NSLayoutRelation.Equal, constant: 0)
        self.view.backgroundColor = UIColor.whiteColor()
        
        calenderModeControl.frame = CGRect(x: 8, y: 8, width: 180, height: 44 - 16)
        calenderModeControl.insertSegmentWithTitle("Agenda", atIndex: 0, animated: false)
        calenderModeControl.insertSegmentWithTitle("Week", atIndex: 1, animated: false)
        calenderModeControl.addTarget(self, action: "calenderMode:", forControlEvents: UIControlEvents.ValueChanged)
        calenderModeControl.selectedSegmentIndex = 1
        toolbar.addSubview(calenderModeControl)
        
        self.navigationController?.navigationBar.translucent = false
        self.view.bringSubviewToFront(toolbar)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if scrollView == nil{
            scrollView = CalenderScrollView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height - self.navigationController!.navigationBar.bounds.height), tutor: tutor, date:selectedDate)
            scrollView!.calenderScrollViewDelegate = self
            self.view.addSubview(scrollView!)
        }
    }
    
    func calenderMode(control:UISegmentedControl){
        self.dismissViewControllerAnimated(false, completion: nil)
    }

    func calenderScrollViewDidChangeDate(date: NSDate) {
        self.selectedDate = date
        setTitle()
    }
    
    func setTitle(){
        var startDate = selectedDate.dateAtStartOfWeek()
        var endDate = selectedDate.dateAtEndOfWeek()
        self.title = "\(Tools.StringFromDate(startDate, format: LMDateFormat.Date.rawValue)) - \(Tools.StringFromDate(endDate, format: LMDateFormat.Date.rawValue))"
    }
}
