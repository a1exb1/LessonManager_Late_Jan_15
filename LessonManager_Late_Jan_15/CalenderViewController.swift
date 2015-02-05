//
//  CalenderViewController.swift
//  LessonManager_Late_Jan_15
//
//  Created by Alex Bechmann on 29/01/2015.
//  Copyright (c) 2015 Alex Bechmann. All rights reserved.
//

import UIKit

class CalenderViewController: UIViewController {

    var toolbar = UIToolbar()
    var calenderModeControl = UISegmentedControl()
    let timeBarWidth:CGFloat = 45
    var scrollView = UIScrollView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
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
        
        //SCROLLVIEW
        scrollView = UIScrollView(frame: CGRect(x: 0, y: 64, width: self.view.bounds.width, height: self.view.bounds.height-self.toolbar.bounds.height - self.navigationController!.navigationBar.bounds.height))
        scrollView.contentSize = CGSize(width: self.view.bounds.width * 2, height: self.view.bounds.height-self.toolbar.bounds.height - self.navigationController!.navigationBar.bounds.height)
        self.view.addSubview(scrollView)
        scrollView.pagingEnabled = true

        var timeBar = UIView(frame: CGRect(x: 0, y: 0, width: timeBarWidth, height: self.view.bounds.height-self.toolbar.bounds.height - self.navigationController!.navigationBar.bounds.height))
        timeBar.backgroundColor = UIColor.grayColor()
        self.scrollView.addSubview(timeBar)
        
        for (var i:CGFloat = 0; i<7; i++){
            var w:CGFloat = (self.view.bounds.width - timeBarWidth) / 7
            var dayView = UIView(frame: CGRect(x: (i * w) + timeBarWidth, y: 0, width: w, height: self.view.bounds.height - self.toolbar.bounds.height - self.navigationController!.navigationBar.bounds.height - 65))
            //dayView.contentSize = CGSize(width: w*2, height: 1000)
            self.scrollView.addSubview(dayView)
            dayView.backgroundColor = UIColor.yellowColor().colorWithAlphaComponent(0.2)
            dayView.tag = Int(i)
            dayView.accessibilityValue = "dayView"
            
            var agendaItem = UIView(frame: CGRectZero)
            agendaItem.backgroundColor = LMColor.coldBlueColor()
            agendaItem.setTranslatesAutoresizingMaskIntoConstraints(false)
            dayView.addSubview(agendaItem)
            
            agendaItem.addLeftConstraint(toView: agendaItem.superview, relation: .Equal, constant: 0)
            agendaItem.addRightConstraint(toView: agendaItem.superview, relation: .Equal, constant: 0)
            agendaItem.addHeightConstraint(relation: .Equal, constant: 70)
            var o:CGFloat = i * 20
            agendaItem.addTopConstraint(toView: agendaItem.superview, relation: .Equal, constant: 250 + o)
        }
    }
    
    override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
        for v in self.scrollView.subviews{
            if v is UIView{
                var view = v as UIView
                if view.accessibilityValue != nil{
                    if view.accessibilityValue == "dayView"{
                        var w:CGFloat = (self.view.bounds.width - timeBarWidth) / 7
                        var i:CGFloat = CGFloat(v.tag)
                        view.frame = CGRect(x: (i * w) + timeBarWidth, y: 0, width: w, height: self.view.bounds.height - self.navigationController!.navigationBar.bounds.height)
                    }
                }
                
            }
            
        }
    }
    
    func calenderMode(control:UISegmentedControl){
        self.dismissViewControllerAnimated(false, completion: nil)
    }

}
