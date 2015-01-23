//
//  SaveStudentCourseLinkTableViewController.swift
//  LessonManager_Late_Jan_15
//
//  Created by Alex Bechmann on 19/01/2015.
//  Copyright (c) 2015 Alex Bechmann. All rights reserved.
//

import UIKit

class SaveStudentCourseLinkViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource, SelectStudentDelegate, SelectCourseDelegate {
    @IBOutlet weak var timePicker: UIPickerView!
    @IBOutlet weak var tableView: UITableView!

    var slot:StudentCourseLink = StudentCourseLink()
    var textFieldProperties:Dictionary<UITextField, String> = Dictionary<UITextField, String>()
    //var didChange:Bool = false

//    convenience override init() {
//        self.init(style: .Grouped)
//    }
    
//    override func supportedInterfaceOrientations() -> Int {
//        return UIInterfaceOrientationMask.Landscape
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Save, target: self, action: "save")
        self.navigationItem.title = "Course link"
        applyViewStyles()
        if slot.StudentCourseLinkID == 0{
            self.setEditing(true, animated: false)
            
        }
        self.tableView.allowsSelectionDuringEditing = true
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.contentOffset = CGPointZero
        
        self.timePicker.delegate = self
        self.timePicker.dataSource = self
        
        self.slot.LessonTime.setPicker(self.timePicker)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        applyViewStyles()
        //tableView.reloadData()
        if let path = self.tableView.indexPathForSelectedRow(){
            tableView.deselectRowAtIndexPath(path, animated: true)
        }
        
        
    }
    
    func applyViewStyles(){
        MarginedTableViewCell.ApplyTableViewStyles(tableView)
    }
    

    
    // MARK: - Table view data source

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var rc = 0
        switch section{
        case 0:
            rc = 2

            break
            
        case 1:
            if slot.StudentCourseLinkID > 0{
                rc = 1
            }
            
        default: break
        }
        
        return rc
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 && indexPath.row == 2{
            return 300
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
                cell.detailTextLabel!.text = slot.student.PersonID < 1 ? "Tap to select" : slot.student.Name
            
                break
                
            case 1:
                cell.textLabel!.text = "Course"
                cell.detailTextLabel!.text = slot.course.CourseID < 1 ? "Tap to select" : slot.course.Name
            
                
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
            slot.Delete(self.view){ response in
                println(response) // this line needed ?!
                self.navigationController?.popViewControllerAnimated(true)
            }
        }
        
    }
    
    func selectStudent(){
        var v = ManageStudentsTableViewController()
        v.delegate = self
        v.currentStudent = self.slot.student
        self.navigationController?.pushViewController(v, animated: true)
    }
    
    func selectCourse(){
        var v = ManageCoursesDetailTableViewController()
        v.delegate = self
        v.currentCourse = self.slot.course
        self.navigationController?.pushViewController(v, animated: true)
    }
    
    func save(){
        Tools.AddLoaderToView(self.view)
        slot.Save(){ response in
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
    
    
    //PICKER
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 4
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        var rc:Int = 0
        
        switch component{
        case 0: rc = 7; break
        case 1: rc = 23; break
        case 2: rc = 12; break
        case 3: rc = 12; break
        default:rc = 0; break
        }
        
        return rc
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        var rc = ""
        if component == 0{
            rc = TimeSpan.TitleForDayOfWeekFromPicker(row)
        }
        if component == 1{
            rc = (row < 9 ? "0" : "") + String(row + 1)
        }
        if component == 2{
            rc = (row < 2 ? "0" : "") + String(row * 5)
        }
        if component == 3{
            rc = String((row + 1) * 15)
        }
        return rc
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        var weekday = pickerView.selectedRowInComponent(0)
        var hour = pickerView.selectedRowInComponent(1)
        var minute = pickerView.selectedRowInComponent(2)
        var duration = pickerView.selectedRowInComponent(3)
        self.slot.LessonTime = TimeSpan(pickerWeekday: weekday, pickerHour: hour, pickerMinute: minute, pickerDuration: duration)
    }
    
    func didSelectStudent(student: Student) {
        self.slot.student = student
        self.tableView.reloadData()
    }
    
    func didSelectCourse(course: Course) {
        self.slot.course = course
        self.tableView.reloadData()
    }
}
