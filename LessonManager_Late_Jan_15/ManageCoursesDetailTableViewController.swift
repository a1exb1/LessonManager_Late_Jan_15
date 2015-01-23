//
//  ManageCoursesDetailTableViewController.swift
//  LessonManager_Jan_15
//
//  Created by Alex Bechmann on 03/01/2015.
//  Copyright (c) 2015 Alex Bechmann. All rights reserved.
//

import UIKit

protocol SelectCourseDelegate{
    func didSelectCourse(var course:Course)
}

class ManageCoursesDetailTableViewController: UITableViewController {

    //var splitView:SplitView? = nil
    var tutor:Tutor = Tutor()
    var delegate:SelectCourseDelegate? = nil
    var currentCourse:Course? = nil
    
    convenience override init() {
        self.init(style: .Grouped)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Courses"
        applyViewStyles()
        self.navigationItem.rightBarButtonItem = self.editButtonItem()
        self.tableView.allowsSelectionDuringEditing = true
    }
    
    override func viewWillAppear(animated: Bool) {
        applyViewStyles()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        reloadData()
    }
    
    func reloadData(){
        session.client.GetTutorsAndCourses(){ response in
            self.tableView.reloadData()
        }
    }
    
    override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
        applyViewStyles()
    }
    
    func applyViewStyles(){
        //splitView?.addDetailMenuButtonToNavigationBar(self.navigationItem, button: nil) // UIBarButtonItem(title: "Manage", style: UIBarButtonItemStyle.Bordered, target: nil, action: nil)
        MarginedTableViewCell.ApplyTableViewStyles(tableView)
    }

    // MARK: - Table view data source
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Tutor: " + session.client.Tutors[section].Name
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return session.client.Tutors.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return session.client.Tutors[section].Courses.count + (self.editing ?  1 : 0)
    }
    
    override func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        var c = session.client.Tutors[section].Courses.count
        return (c == 0 && !tableView.editing) ? "No courses" : ""
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = MarginedTableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "Cell")
        cell.containerView = self.tableView
        cell.indexPath = indexPath
        cell.numberOfRowsInSection = tableView.numberOfRowsInSection(indexPath.section)
        
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        
        if cell.numberOfRowsInSection == indexPath.row + (self.editing ?  1 : 0){
            cell.textLabel?.text = "Add new course"
            cell.textLabel?.textColor = UIColor.grayColor()
        }
        else{
            var tutor:Tutor = session.client.Tutors[indexPath.section]
            var course = tutor.Courses[indexPath.row]
            cell.textLabel?.text = course.Name
            //var editingAccessoryVariables = Tools.TextFieldViewForEditingMode(self.tableView.bounds)
            //cell.editingAccessoryView = editingAccessoryVariables.view
            //cell.setNeedsLayout()
            
            if editing && delegate != nil{
                cell.detailTextLabel?.text = "Tap to edit"
                cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            }
            else{
                if currentCourse? != nil{
                    if currentCourse!.CourseID == course.CourseID{
                        cell.accessoryType = UITableViewCellAccessoryType.Checkmark
                        cell.detailTextLabel?.text = "(Current)"
                    }
                    else{
                        cell.detailTextLabel?.text = "Tap to select"
                    }
                }
            }
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        //Tools.marginedtableView(tableView, cell: cell, indexPath: indexPath)
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var view = SaveCourseTableViewController()
        var tutor:Tutor = session.client.Tutors[indexPath.section]
        var course = Course()
        
        if courseExistsForIndexPath(indexPath){
            course = tutor.Courses[indexPath.row]
        }
        
        if delegate != nil && !editing{
            delegate?.didSelectCourse(course)
            self.navigationController?.popViewControllerAnimated(true)
        }
        else{
            view.course = course
            view.course.tutor = tutor
            view.shouldEditOnLoad = self.tableView.editing
            self.navigationController?.pushViewController(view, animated: true)
        }
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        var tutor:Tutor = session.client.Tutors[indexPath.section]
        if courseExistsForIndexPath(indexPath) && editingStyle == UITableViewCellEditingStyle.Delete{
            var course:Course = tutor.Courses[indexPath.row]
            course.Delete(self.view){ response in
                println(response)
                tableView.beginUpdates()
                //tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
                tutor.Courses.removeAtIndex(indexPath.row)
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Top)
                tableView.endUpdates()
                //self.reloadData()
            }
            
        }
        else if (editingStyle == UITableViewCellEditingStyle.Insert){
            var view = SaveCourseTableViewController()
            view.course = Course()
            view.course.tutor = tutor
            self.navigationController?.pushViewController(view, animated: true)
        }
        
        
    }

    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
        if courseExistsForIndexPath(fromIndexPath) && (toIndexPath != fromIndexPath){
            var tutor:Tutor = session.client.Tutors[fromIndexPath.section]
            var course:Course = tutor.Courses[fromIndexPath.row]
            tutor.Courses.removeAtIndex(fromIndexPath.row)
            
            var toTutor = session.client.Tutors[toIndexPath.section]
            toTutor.Courses.append(course)
            
            course.SwitchTutor(toTutor){ response in
                if response == 1{
                    tableView.reloadData()
                    self.reloadData()
                }
                
            }
            if self.view.bounds.width > Tools.MinWidthForStaticSideBar(){
                tableView.reloadData()
            }
        }
        
    }

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
        
    }
    
    override func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        var rc = UITableViewCellEditingStyle.None
        if courseExistsForIndexPath(indexPath){
            if self.view.bounds.width < Tools.MinWidthForStaticSideBar(){
                rc = UITableViewCellEditingStyle.Delete
            }
        }
        else{
            rc = UITableViewCellEditingStyle.Insert
        }

        return rc
    }
    
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return courseExistsForIndexPath(indexPath)
    }
    
    override func setEditing(editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: true)
        self.tableView.reloadData()
    }
    
    func courseExistsForIndexPath(indexPath:NSIndexPath) -> Bool{
        var course:Course? = nil
        var tutor:Tutor? = session.client.Tutors[indexPath.section]
        if indexPath.row < tutor!.Courses.count{
            course = tutor!.Courses[indexPath.row]
        }
        return course != nil
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var title:String = self.tableView(tableView, titleForHeaderInSection: section)!
        return MarginedTableViewCell.HeaderViewForCell(tableView, section: section, title: title, style:"" )
    }
}
