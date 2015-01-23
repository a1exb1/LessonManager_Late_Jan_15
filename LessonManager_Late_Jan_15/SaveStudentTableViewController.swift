//
//  StudentTableViewController.swift
//  LessonManager_Dec_14
//
//  Created by Alex Bechmann on 26/12/2014.
//  Copyright (c) 2014 Alex Bechmann. All rights reserved.
//

import UIKit

class SaveStudentTableViewController: UITableViewController {

    var student:Student = Student()
    var textFieldProperties:Dictionary<UITextField, String> = Dictionary<UITextField, String>()
    var didChange:Bool = false
    
    convenience override init() {
        self.init(style: .Grouped)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = self.editButtonItem()
        self.navigationItem.title = "Student details"
        applyViewStyles()
        if student.PersonID == 0{
            self.setEditing(true, animated: false)
        }
        self.tableView.allowsSelectionDuringEditing = true
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        applyViewStyles()
        tableView.reloadData()
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
        return 3
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var rc = 0
        switch section{
        case 0:
            rc = 3
            break
            
        case 1:
            rc = 2
            
            break
            
        case 2:
            if student.PersonID > 0 && editing{
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
            title = "Call"
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
                cell.detailTextLabel!.text = student.Name
                
                break
                
            case 1:
                cell.textLabel!.text = "Address"
                cell.detailTextLabel!.text = ""
                
            case 2:
                cell.textLabel!.text = "Email"
                cell.detailTextLabel!.text = student.Email
                cell.textField.keyboardType = UIKeyboardType.EmailAddress
                break
                
            default:
                break
            }
        }
        else if indexPath.section == 1{
            switch indexPath.row{
            case 0:
                cell.textLabel!.text = "Phone"
                cell.detailTextLabel!.text = student.Phone
                
                cell.detailTextLabel!.textColor = self.view.tintColor
                cell.textLabel!.textColor = self.view.tintColor
                cell.textField.keyboardType = UIKeyboardType.PhonePad
                //cell.imageView?.image = UIImage(named: "735-phone-toolbar-selected")
                break
                
            case 1:
                cell.textLabel!.text = "Mobile"
                cell.detailTextLabel!.text = student.Mobile
                
                cell.detailTextLabel!.textColor = self.view.tintColor
                cell.textLabel!.textColor = self.view.tintColor
                cell.textField.keyboardType = UIKeyboardType.PhonePad
                //cell.imageView?.image = UIImage(named: "839-mobile-phone-toolbar-selected")
                break
                
            default:
                break
            }
            
        }
        else if indexPath.section == 2{
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
        
        cell.textField.keyboardAppearance = UIKeyboardAppearance.Dark
        textFieldProperties[cell.textField] = cell.textLabel!.text!
        cell.textField.addTarget(self, action: "textFieldDidChange:", forControlEvents: UIControlEvents.EditingChanged)
        cell.accessoryType = UITableViewCellAccessoryType.None
        return cell
    }
    
    override func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.None
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //println("clicked")
        if indexPath.section == 2 && indexPath.row == 0{
            student.Delete(self.view){ response in
                println(response)
                self.navigationController?.popViewControllerAnimated(true)
            }
        }
    }
    
    override func setEditing(editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: true)
        if !editing && didChange{
            student.Save(){ response in
                Tools.HideLoaderFromView(self.view)
                self.tableView.reloadData()
                self.didChange = false
                self.navigationController?.popViewControllerAnimated(true)
            }
            Tools.AddLoaderToView(self.view)
        }
        
        if self.view.bounds.width < Tools.MinWidthForStaticSideBar(){
            if student.PersonID > 0{
                tableView.beginUpdates()
                if editing{
                    tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: 0, inSection: 2)], withRowAnimation: UITableViewRowAnimation.Fade)
                }
                else{
                    tableView.deleteRowsAtIndexPaths([NSIndexPath(forRow: 0, inSection: 2)], withRowAnimation: UITableViewRowAnimation.Fade)
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
            student.Name = textField.text
            break
            
        case "Phone":
            student.Phone = textField.text
            break
            
        case "Mobile":
            student.Mobile = textField.text
            break
            
        case "Email":
            student.Email = textField.text
            break
            
        default:break
        }
        didChange = true
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var title:String = self.tableView(tableView, titleForHeaderInSection: section)!
        return MarginedTableViewCell.HeaderViewForCell(tableView, section: section, title: title, style:nil )
    }
}
