//
//  ManageStudentsTableViewController.swift
//  LessonManager_Jan_15
//
//  Created by Alex Bechmann on 09/01/2015.
//  Copyright (c) 2015 Alex Bechmann. All rights reserved.
//

import UIKit

protocol SelectStudentDelegate{
    func didSelectStudent(var student:Student)
}

class ManageStudentsTableViewController: UITableViewController {

    var delegate:SelectStudentDelegate? = nil
    var currentStudent:Student? = nil
    
    //var splitView:SplitView? = nil
    
//    convenience override init() {
//        self.init(style: .Grouped)
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Students"
        applyViewStyles()
        
        if delegate != nil{
            self.navigationItem.rightBarButtonItems = [UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: "newStudent"), self.editButtonItem()]
        }
        else{
            self.navigationItem.rightBarButtonItems = [UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: "newStudent")]
        }
        self.tableView.allowsSelectionDuringEditing = true
    }
    
    override func viewWillAppear(animated: Bool) {
        applyViewStyles()
    }
    
    override func viewDidAppear(animated: Bool) {
        session.client.GetStudents(){ response in
            self.tableView.reloadData()
        }
        applyViewStyles()
    }
    
    override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
        applyViewStyles()
    }
    
    func applyViewStyles(){
        //splitView?.addDetailMenuButtonToNavigationBar(self.navigationItem, button: nil)
        MarginedTableViewCell.ApplyTableViewStyles(tableView)
    }
    
    func newStudent(){
        var view:SaveStudentTableViewController = SaveStudentTableViewController()
        view.student = Student()
        self.navigationController?.pushViewController(view, animated: true)
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return session.client.Students.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = MarginedTableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "Cell")
        cell.containerView = self.tableView
        cell.indexPath = indexPath
        cell.numberOfRowsInSection = tableView.numberOfRowsInSection(indexPath.section)
        
        var student:Student = session.client.Students[indexPath.row]
        cell.textLabel?.text = student.Name
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        
        var editingAccessoryVariables = Tools.TextFieldViewForEditingMode(self.tableView.bounds)
        cell.editingAccessoryView = editingAccessoryVariables.view
        
        if editing && delegate != nil{
            cell.detailTextLabel?.text = "Tap to edit"
            cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        }
        else{
            if currentStudent? != nil{
                if currentStudent!.PersonID == student.PersonID{
                    cell.accessoryType = UITableViewCellAccessoryType.Checkmark
                    cell.detailTextLabel?.text = "(Current)"
                }
                else{
                    cell.detailTextLabel?.text = "Tap to select"
                }
            }
        }
        
        cell.setNeedsLayout()
        return cell
    }
    
//    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return session.client.Name
//    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var student = session.client.Students[indexPath.row]
        
        if !editing && delegate != nil{
            delegate?.didSelectStudent(student)
            self.navigationController?.popViewControllerAnimated(true)
        }
        else{
            var view = SaveStudentTableViewController()
            view.student = student
            self.navigationController?.pushViewController(view, animated: true)
        }
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var title:String = self.tableView(tableView, titleForHeaderInSection: section)!
        return MarginedTableViewCell.HeaderViewForCell(tableView, section: section, title: title, style:nil )
    }
    
    override func setEditing(editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        self.tableView.reloadData()
    }

}
