////
////  SelectStudentTableViewController.swift
////  LessonManager_Late_Jan_15
////
////  Created by Alex Bechmann on 21/01/2015.
////  Copyright (c) 2015 Alex Bechmann. All rights reserved.
////
//
//import UIKit
//
//protocol SelectStudentDelegate{
//    func didSelectStudent(var student:Student)
//}
//
//class SelectStudentTableViewController: UITableViewController {
//
//    var delegate:SelectStudentDelegate? = nil
//    var currentStudent:Student? = nil
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        //self.navigationItem.rightBarButtonItems = [self.editButtonItem(),
//        //UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: "newStudent")]
//        self.tableView.allowsSelectionDuringEditing = true
//    }
//
//    override func viewDidAppear(animated: Bool) {
//        super.viewDidAppear(animated)
//        session.client.GetStudents(){ response in
//            self.tableView.reloadData()
//        }
//    }
//
//    // MARK: - Table view data source
//
//    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        // #warning Potentially incomplete method implementation.
//        // Return the number of sections.
//        return 1
//    }
//
//    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete method implementation.
//        // Return the number of rows in the section.
//        return session.client.Students.count
//    }
//
//    
//    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        let cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "Cell")
//
//        let student = session.client.Students[indexPath.row]
//        cell.textLabel?.text = student.Name
//        
//        if editing{
//            cell.detailTextLabel?.text = "Tap to edit"
//            cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
//        }
//        else{
//            if currentStudent? != nil{
//                if currentStudent!.PersonID == student.PersonID{
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
//        var v = SaveStudentTableViewController()
//        self.navigationController?.pushViewController(v, animated: true)
//    }
//    
//    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        let student = session.client.Students[indexPath.row]
//        if editing{
//            var v = SaveStudentTableViewController()
//            v.student = student
//            self.navigationController?.pushViewController(v, animated: true)
//        }
//        else{
//            delegate?.didSelectStudent(student)
//            self.navigationController?.popViewControllerAnimated(true)
//        }
//    }
//    
//    override func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
//        return UITableViewCellEditingStyle.None
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
//}
