//
//  SaveLessonViewController.swift
//  LessonManager_Late_Jan_15
//
//  Created by Alex Bechmann on 22/01/2015.
//  Copyright (c) 2015 Alex Bechmann. All rights reserved.
//

import UIKit

class SaveLessonViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, SelectStudentDelegate, SelectCourseDelegate, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var tableView: UITableView!
    
    var durationPicker = UIPickerView()
    
    var lesson:Lesson = Lesson()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Save, target: self, action: "save")
        self.navigationItem.title = "Lesson"
        if lesson.LessonID == 0{
            self.setEditing(true, animated: false)
            
        }
        
        self.datePicker.date = lesson.Date
        self.tableView.allowsSelectionDuringEditing = true
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.contentOffset = CGPointZero
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        //tableView.reloadData()
        if let path = self.tableView.indexPathForSelectedRow(){
            tableView.deselectRowAtIndexPath(path, animated: true)
        }
    }
    
    
    
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var rc = 0
        
        switch section{
        case 0: rc = 3; break
        case 1:
            if lesson.LessonID > 0{
                rc = 1
            }
            
        default: break
        }
        
        return rc
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 && indexPath.row == 2{
            return 160
        }
        else{
            return 44
        }
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var title:String = ""
        switch section{
        case 0:
            title = "Info"
            break
            
        default:
            break
        }
        return title
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "Cell")
        
        if (indexPath.section == 0){
            cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            switch indexPath.row{
            case 0:
                cell.textLabel!.text = "Student"
                cell.detailTextLabel!.text = lesson.student.PersonID < 1 ? "Tap to select" : lesson.student.Name
                
                break
                
            case 1:
                cell.textLabel!.text = "Course"
                cell.detailTextLabel!.text = lesson.course.CourseID < 1 ? "Tap to select" : lesson.course.Name
                
            case 2:
                cell.textLabel?.text = "Duration"
                var p = UIPickerView(frame: CGRect(x: cell.bounds.origin.x + cell.bounds.width - 50, y: cell.bounds.origin.y, width: 50, height: cell.bounds.height))
                p.delegate = self
                cell.addSubview(p)
                cell.selectedBackgroundView.backgroundColor = UIColor.clearColor()
                p.selectRow((self.lesson.Duration / 15) - 1, inComponent: 0, animated: false)
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
        return cell
    }
    
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.None
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 0{
            switch indexPath.row{
            case 0: selectStudent(); break
            case 1: selectCourse(); break
            default: break
            }
        }
        
        if indexPath.section == 1 && indexPath.row == 0{
            lesson.Delete(self.view){ response in
                println("") // this line needed ?!
                self.navigationController?.popViewControllerAnimated(true)
            }
        }
    }
    
    func selectStudent(){
        var v = ManageStudentsTableViewController()
        v.delegate = self
        v.currentStudent = self.lesson.student
        self.navigationController?.pushViewController(v, animated: true)
    }
    
    func selectCourse(){
        var v = ManageCoursesDetailTableViewController()
        v.delegate = self
        v.currentCourse = self.lesson.course
        self.navigationController?.pushViewController(v, animated: true)
    }
    
    func save(){
        Tools.AddLoaderToView(self.view)
        lesson.Date = datePicker.date
        lesson.Save(){ response in
            Tools.HideLoaderFromView(self.view)
            self.tableView.reloadData()
            if response == 1{
                self.navigationController?.popViewControllerAnimated(true)
            }
        }
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }
    
    
    func didSelectStudent(student: Student) {
        self.lesson.student = student
        self.tableView.reloadData()
    }
    
    func didSelectCourse(course: Course) {
        self.lesson.course = course
        self.tableView.reloadData()
    }
    
    /* PICKER */
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 12
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String!{
        return String((row + 1) * 15)
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.lesson.Duration = (row + 1) * 15
    }

}
