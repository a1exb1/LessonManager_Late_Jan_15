//
//  AgendaAttendenceCollectionViewCell.swift
//  LessonManager_Late_Jan_15
//
//  Created by Alex Bechmann on 26/01/2015.
//  Copyright (c) 2015 Alex Bechmann. All rights reserved.
//

import UIKit

class AgendaAttendenceCollectionViewCell: UICollectionViewCell, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    var lesson:Lesson = Lesson()
    
    
    func setup(var lesson:Lesson){
        self.lesson = lesson
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.reloadData()
        
        self.segmentedControl.addTarget(self, action: "setAttendance:", forControlEvents: UIControlEvents.ValueChanged)
        var i = lesson.Status.rawValue
        var order = [0, 3, 2, 1]
        self.segmentedControl.selectedSegmentIndex = order[i]
    }
    

    func setAttendance(control:UISegmentedControl){
        var order = [0, 3, 2, 1] // order on db e.g. 1 = present
        var statusid = order[control.selectedSegmentIndex]
        var status = LessonStatus(rawValue: statusid)!
        self.lesson.SetAttendance(status){ response in
            
        }
    }
    
    
    
    //TABLE VIEW
    

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "Cell")
        cell.textLabel!.text = "Present"
        cell.detailTextLabel!.text = "14/15"
        return cell
        
    }
    

}
