//
//  ManageLessonSlotsTableViewController.swift
//  LessonManager_Late_Jan_15
//
//  Created by Alex Bechmann on 19/01/2015.
//  Copyright (c) 2015 Alex Bechmann. All rights reserved.
//

import UIKit

class ManageStudentCourseLinksTableViewController: UITableViewController {

    var slots = Dictionary<Int, Array<StudentCourseLink>>()
    var weekDaysWithSlots = Array<Int>()
    var tutor:Tutor? = nil
    
    convenience override init(){
        self.init(style: UITableViewStyle.Grouped)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if tutor == nil{
            tutor = session.tutor
        }
        self.navigationItem.rightBarButtonItems = [UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: "newStudentCourseLink"), self.editButtonItem(),
            UIBarButtonItem(title: "View", style: UIBarButtonItemStyle.Bordered, target: self, action: "changeView")
        ]
        
        self.title = "\(tutor!.Name)'s lesson slots"
    }
    
    func changeView(){
        var v = StudentCourseLinksWebViewController()
        v.tutor = tutor!
        var nav = UINavigationController()
        nav.pushViewController(v, animated: false)
        self.presentViewController(nav, animated: true, completion: nil)
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        getData()
    }
    
    func getData(){
        Tools.AddLoaderToView(self.view)
        self.slots = Dictionary<Int, Array<StudentCourseLink>>()
        self.tableView.reloadData()
        tutor!.GetLessonSlots(){ response in
            self.slots = Dictionary<Int, Array<StudentCourseLink>>()
            self.weekDaysWithSlots = []
            for slot in response{
                if self.slots[slot.LessonTime.Weekday.rawValue] == nil{
                    self.slots[slot.LessonTime.Weekday.rawValue] = [slot]
                    self.weekDaysWithSlots.append(slot.LessonTime.Weekday.rawValue)
                }
                else{
                    self.slots[slot.LessonTime.Weekday.rawValue]!.append(slot)
                }
                
            }
            Tools.HideLoaderFromView(self.view)
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return slots.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        var weekDay = self.weekDaysWithSlots[section]
        return self.slots[weekDay]!.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell =  UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "Cell")
        
        // Configure the cell...
        var weekDay = self.weekDaysWithSlots[indexPath.section]
        var slotsForDay:Array<StudentCourseLink> = self.slots[weekDay]!
        var slot = slotsForDay[indexPath.row]
        cell.textLabel?.text = slot.student.Name
        cell.detailTextLabel?.text = String(format: "%02d", slot.LessonTime.Hour) + ":" + String(format: "%02d", slot.LessonTime.Minute) + " (\(slot.LessonTime.Duration) mins)"

        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        return cell
    }

    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var weekDay = self.weekDaysWithSlots[section]
        return TimeSpan.TitleForDayOfWeek(self.weekDaysWithSlots[section])
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        var s = UIStoryboard(name: "Main", bundle: nil)
        var v = s.instantiateViewControllerWithIdentifier("SaveStudentCourseLinkView") as
        SaveStudentCourseLinkViewController!
        
        var weekDay = self.weekDaysWithSlots[indexPath.section]
        var slotsForDay:Array<StudentCourseLink> = self.slots[weekDay]!
        var slot = slotsForDay[indexPath.row]
        v.slot = slot
        
        self.navigationController?.pushViewController(v, animated: true)
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return .Delete
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete{
            var weekDay = self.weekDaysWithSlots[indexPath.section]
            var slotsForDay:Array<StudentCourseLink> = self.slots[weekDay]!
            var slot = slotsForDay[indexPath.row]
            
            slot.Delete(self.view){ response in
                println("") // this line needed ?!
                //self.getData()
                self.tableView.beginUpdates()
                self.slots[self.weekDaysWithSlots[indexPath.section]]!.removeAtIndex(indexPath.row)
                tableView.deleteRowsAtIndexPaths([NSIndexPath(forRow: indexPath.row, inSection: indexPath.section)], withRowAnimation: UITableViewRowAnimation.Top)
                self.tableView.endUpdates()
            }
        }
    }

    func newStudentCourseLink(){
        var s = UIStoryboard(name: "Main", bundle: nil)
        var v = s.instantiateViewControllerWithIdentifier("SaveStudentCourseLinkView") as
            SaveStudentCourseLinkViewController!
        self.navigationController?.pushViewController(v, animated: true)
    }
    
}
