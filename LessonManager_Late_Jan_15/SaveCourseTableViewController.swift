//
//  SaveCourseTableViewController.swift
//  LessonManager_Jan_15
//
//  Created by Alex Bechmann on 08/01/2015.
//  Copyright (c) 2015 Alex Bechmann. All rights reserved.
//

import UIKit

class SaveCourseTableViewController: UITableViewController {

    var course:Course = Course()
    var textFieldProperties:Dictionary<UITextField, String> = Dictionary<UITextField, String>()
    var didChange:Bool = false
    var shouldEditOnLoad = false
    
    convenience override init() {
        self.init(style: .Grouped)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = self.editButtonItem()
        self.navigationItem.title = "Course details"
        applyViewStyles()
        
        self.tableView.allowsSelectionDuringEditing = true
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        applyViewStyles()
//        tableView.reloadData()
//        if course.CourseID == 0 || shouldEditOnLoad{
//            self.setEditing(true, animated: true)
//        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if course.CourseID == 0 || shouldEditOnLoad{
            self.setEditing(true, animated: false)
        }
    }
    
    
    func applyViewStyles(){
        MarginedTableViewCell.ApplyTableViewStyles(tableView)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 2
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var rc = 0
        
        switch section{
        case 0:
            rc = 2
            break
            
        case 1:
            if course.CourseID > 0 && editing{
                rc = 1
            }
            
        default: break
        }
        return rc
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var title:String = ""
        switch section{
        case 0:
            title = "Info"
            break
            
        case 1:
            title = ""
            break
            
        default:
            break
        }
        return title
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = EditingTextFieldTableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "Cell")
        cell.containerView = self.tableView
        cell.indexPath = indexPath
        cell.numberOfRowsInSection = tableView.numberOfRowsInSection(indexPath.section)
        cell.margined = true
        
        if (indexPath.section == 0){
            switch indexPath.row{
            case 0:
                cell.textLabel!.text = "Name"
                cell.detailTextLabel!.text = course.Name
                
                break
                
            case 1:
                cell.textLabel!.text = "Tutor"
                cell.detailTextLabel!.text = course.tutor.Name
                break
                
            default:
                break
            }
        }
        else if indexPath.section == 1{
            var deleteCell = MarginedTableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "DeleteCell")
            deleteCell.containerView = self.tableView
            deleteCell.indexPath = indexPath
            deleteCell.numberOfRowsInSection = tableView.numberOfRowsInSection(indexPath.section)
            
            var label = UILabel(frame: CGRectZero)
            label.text = "Delete"
            label.textColor = UIColor.redColor()
            label.textAlignment = NSTextAlignment.Center
            label.setTranslatesAutoresizingMaskIntoConstraints(false)
            deleteCell.addSubview(label)
            label.addCenterXConstraint(toView: label.superview)
            label.addCenterYConstraint(toView: label.superview)
            return deleteCell
        }
        
        textFieldProperties[cell.textField] = cell.textLabel!.text!
        cell.textField.addTarget(self, action: "textFieldDidChange:", forControlEvents: UIControlEvents.EditingChanged)
        cell.accessoryType = UITableViewCellAccessoryType.None
        return cell
    }
    
    override func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.None
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 1 && indexPath.row == 0{
            course.Delete(self.view){ response in
                println(response)
                self.navigationController?.popViewControllerAnimated(true)
            }
        }
    }
    
    override func setEditing(editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: true)
        if !editing && didChange{
            course.Save(){ response in
                Tools.HideLoaderFromView(self.view)
                self.tableView.reloadData()
                self.didChange = false
                self.navigationController?.popViewControllerAnimated(true)
            }
            Tools.AddLoaderToView(self.view)
        }
        
        if self.view.bounds.width < Tools.MinWidthForStaticSideBar(){
            if course.CourseID > 0{
                tableView.beginUpdates()
                if editing{
                    tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: 0, inSection: 1)], withRowAnimation: UITableViewRowAnimation.Fade)
                }
                else{
                    tableView.deleteRowsAtIndexPaths([NSIndexPath(forRow: 0, inSection: 1)], withRowAnimation: UITableViewRowAnimation.Fade)
                }
                tableView.endUpdates()
            }
        }
        else{
            tableView.reloadData()
        }
    }
    
    func textFieldDidChange(textField: UITextField) {
        switch textFieldProperties[textField]!{
        case "Name":
            course.Name = textField.text
            break
            
        default:break
        }
        
        self.didChange = true
        
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return (indexPath.row != 1 && indexPath.section == 0)
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var title:String = self.tableView(tableView, titleForHeaderInSection: section)!
        return MarginedTableViewCell.HeaderViewForCell(tableView, section: section, title: title, style:nil )
    }
    
    override func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        var c = session.client.Tutors[section].Courses.count
        return (c == 0 && !tableView.editing) ? "No courses" : ""
    }
}
