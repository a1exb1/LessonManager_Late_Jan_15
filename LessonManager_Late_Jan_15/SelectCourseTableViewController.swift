////
////  SelectCourseTableViewController.swift
////  LessonManager_Late_Jan_15
////
////  Created by Alex Bechmann on 22/01/2015.
////  Copyright (c) 2015 Alex Bechmann. All rights reserved.
////
//
//import UIKit
//
//
//
//class SelectCourseTableViewController: UITableViewController {
//
//    var delegate:SelectCourseDelegate? = nil
//    var currentCourse:Course? = nil
//    
//    convenience override init(){
//        self.init(style: UITableViewStyle.Grouped)
//    }
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        //self.navigationItem.rightBarButtonItems = [self.editButtonItem(),
//            //UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: "newStudent")]
//        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Manage", style: UIBarButtonItemStyle.Bordered, target: self, action: "manage")
//        self.tableView.allowsSelectionDuringEditing = true
//    }
//    
//    func manage(){
//        var v = ManageCoursesDetailTableViewController()
//        self.navigationController?.pushViewController(v, animated: true)
//    }
//    
//    override func viewDidAppear(animated: Bool) {
//        super.viewDidAppear(animated)
//        session.client.GetTutorsAndCourses(){ response in
//            self.tableView.reloadData()
//        }
//    }
//
//    // MARK: - Table view data source
//
//    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return "Tutor: " + session.client.Tutors[section].Name
//    }
//    
//    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        return session.client.Tutors.count
//    }
//    
//    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return session.client.Tutors[section].Courses.count + (editing ? 1 : 0)
//    }
//
//    
//    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        let cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "Cell")
//        
//        let tutor:Tutor = session.client.Tutors[indexPath.section]
//        let course = tutor.Courses[indexPath.row]
//        cell.textLabel?.text = course.Name
//        
//        if editing{
//            cell.detailTextLabel?.text = "Tap to edit"
//            cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
//        }
//        else{
//            if currentCourse? != nil{
//                if currentCourse!.CourseID == course.CourseID{
//                    cell.accessoryType = UITableViewCellAccessoryType.Checkmark
//                    cell.detailTextLabel?.text = "(Current)"
//                }
//                else{
//                    cell.detailTextLabel?.text = "Tap to select"
//                }
//            }
//        }
//        
//        return cell
//    }
//
//    func newStudent(){
//        var v = SaveCourseTableViewController()
//        self.navigationController?.pushViewController(v, animated: true)
//    }
//    
//    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        var v = SaveCourseTableViewController()
//        var tutor:Tutor = session.client.Tutors[indexPath.section]
//        
//        var course:Course = tutor.Courses[indexPath.row]
//        
//        if editing{
//            v.course = course
//            v.course.tutor = tutor
//            self.navigationController?.pushViewController(v, animated: true)
//        }
//        else{
//            delegate?.didSelectCourse(course)
//            self.navigationController?.popViewControllerAnimated(true)
//        }
//    }
//    
//    override func setEditing(editing: Bool, animated: Bool) {
//        super.setEditing(editing, animated: animated)
//        self.tableView.reloadData()
//    }
//
//    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
//        return false
//    }
//    
//    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        var title:String = self.tableView(tableView, titleForHeaderInSection: section)!
//        return MarginedTableViewCell.HeaderViewForCell(tableView, section: section, title: title, style:nil )
//    }
//    
//    func courseExistsForIndexPath(indexPath:NSIndexPath) -> Bool{
//        var course:Course? = nil
//        var tutor:Tutor? = session.client.Tutors[indexPath.section]
//        if indexPath.row < tutor!.Courses.count{
//            course = tutor!.Courses[indexPath.row]
//        }
//        return course != nil
//    }
//
//}
