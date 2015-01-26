//
//  EditingTableViewController.swift
//  LessonManager_Late_Jan_15
//
//  Created by Alex Bechmann on 26/01/2015.
//  Copyright (c) 2015 Alex Bechmann. All rights reserved.
//

import UIKit

protocol EditingTableViewDelegate{
    func itemsForEditingTableView() -> Array<Array<editingTableViewItem>>
    func editingTableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    //func editingTableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    func editingTableView(tableView: UITableView, didSelectRowWithIdentifier identifier:String)
    func editingTextFieldDidChange(identifier:String, value:String)
    func editingDatePickerDidChange(identifier:String, date:NSDate)
    func commitEditing()
    func editingTableViewIsExistingEntry() -> Bool
    func commitDelete()
    func editingTableViewShouldToggleEdit() -> Bool
}

enum EditingType{
    case Button
    case Text
    case Date
}

class editingTableViewItem{
    var textLabelText:String = ""
    var detailTextLabelText:String = ""
    var textFieldIdentifier:String = ""
    var keyboardType:UIKeyboardType = UIKeyboardType.Default
    var editingType:EditingType = .Text
    
    var datePickerCell:DVDatePickerTableViewCell? = nil
    
    convenience init(textLabelText:String, detailTextLabelText:String, textFieldIdentifier:String, keyboardType:UIKeyboardType?, editingType:EditingType?, var date:NSDate?){
        self.init()
        self.textLabelText = textLabelText
        self.detailTextLabelText = detailTextLabelText
        self.textFieldIdentifier = textFieldIdentifier
        self.keyboardType = keyboardType != nil ? keyboardType! : self.keyboardType
        self.editingType = editingType != nil ? editingType! : self.editingType
        
        if editingType != nil{
            if editingType! == .Date{
                self.datePickerCell = DVDatePickerTableViewCell(textLabelText: textLabelText, identifier: textFieldIdentifier, date: date == nil ? NSDate() : date!)
            }
        }
    }
}

class EditingTableViewController: UITableViewController, EditingTableViewDelegate, DVDatePickerDelegate {

    var delegate:EditingTableViewDelegate? = nil
    var didChange:Bool = false
    var textFieldProperties:Dictionary<UITextField, String> = Dictionary<UITextField, String>()
    var datePickerCells = Array<DVDatePickerTableViewCell>() // not really used
    var isExistingEntry:Bool = false
    var items = Array<Array<editingTableViewItem>>()
    
    
    convenience override init(){
        self.init(style: .Grouped)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        
        self.navigationItem.rightBarButtonItem = self.editButtonItem()
        self.isExistingEntry = delegate!.editingTableViewIsExistingEntry()
        self.tableView.allowsSelectionDuringEditing = true
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 44

//        if delegate!.editingTableViewShouldToggleEdit(){
//            self.navigationItem.rightBarButtonItem = self.editButtonItem()
//            self.editing = true
//        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        reload()
        if !isExistingEntry{
            setEditing(true, animated: false)
        }
    }

    func reload(){
        if let d = delegate{
            self.items = d.itemsForEditingTableView()
        }
        
        self.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return items.count + 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        var rc = 0;
        if section != items.count{
            rc = items[section].count
        }
        else{
            if editing && isExistingEntry{
                rc = 1
            }
        }
        return rc
    }

    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var title:String = ""
        if let d = delegate {
            if section != items.count{
                title = d.editingTableView(tableView, titleForHeaderInSection: section)!
            }
            
        }
        return title
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        var rc = false
        
        if indexPath.section < items.count{
            var item:editingTableViewItem? = self.items[indexPath.section][indexPath.row]
            
            if item != nil{
                if item!.editingType == EditingType.Text{ rc = true }
            }
        }
        
        
        
        return rc
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section != items.count{
            var c = items[indexPath.section][indexPath.row]
            
            if c.editingType == .Text{
                
                let cell = EditingTextFieldTableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "Cell")
                cell.containerView = self.tableView
                cell.indexPath = indexPath
                cell.numberOfRowsInSection = tableView.numberOfRowsInSection(indexPath.section)
                cell.margined = false
                
                cell.textLabel!.text = c.textLabelText
                cell.detailTextLabel!.text = c.detailTextLabelText
                cell.textField.keyboardType = c.keyboardType
                textFieldProperties[cell.textField] = c.textFieldIdentifier
                
                cell.textField.keyboardAppearance = UIKeyboardAppearance.Dark
                
                cell.textField.addTarget(self, action: "textFieldDidChange:", forControlEvents: UIControlEvents.EditingChanged)
                cell.accessoryType = UITableViewCellAccessoryType.None
                return cell
            }
            else if c.editingType == .Date{
                let cell = c.datePickerCell!
                cell.delegate = self
                if find(datePickerCells, c.datePickerCell!) == nil{
                    datePickerCells.append(c.datePickerCell!)
                }
                return cell
            }
            else if c.editingType == .Button{
                let cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "NormalCell")
                cell.textLabel?.text = c.textLabelText
                cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
                return cell
            }
        }
        
        else if indexPath.section == items.count{
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
        
        return UITableViewCell()
    }
    
    override func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.None
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var cell = self.tableView(tableView, cellForRowAtIndexPath: indexPath)
        if (cell.isKindOfClass(DVDatePickerTableViewCell) && editing) {
            //closeDatePickers()
            var datePickerTableViewCell = cell as DVDatePickerTableViewCell
            datePickerTableViewCell.selectedInTableView(tableView)
        }
        else if indexPath.section == items.count{
            delegate?.commitDelete()
        }
        
        if indexPath.section != items.count{
            var item = self.items[indexPath.section][indexPath.row]
            
            if item.editingType == EditingType.Button{
                delegate?.editingTableView(tableView, didSelectRowWithIdentifier: item.textFieldIdentifier)
            }
        }
        
        self.view.endEditing(true)
        self.tableView.deselectRowAtIndexPath(indexPath, animated: editing)
    }
    
    override func setEditing(editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: true)
        
        
        if self.view.bounds.width < Tools.MinWidthForStaticSideBar(){
            if isExistingEntry{
                tableView.beginUpdates()
                if editing{
                    tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: 0, inSection: items.count)], withRowAnimation: UITableViewRowAnimation.Fade)
                }
                else{
                    tableView.deleteRowsAtIndexPaths([NSIndexPath(forRow: 0, inSection: items.count)], withRowAnimation: UITableViewRowAnimation.Fade)
                }
                tableView.endUpdates()
            }
        }
        else{
            tableView.reloadData()
        }

        closeDatePickers()
        
        if !editing && didChange{
            delegate?.commitEditing()
            didChange = false
            reload()
        }
        
    }
    
    func textFieldDidChange(textField: UITextField) {
        delegate?.editingTextFieldDidChange(textFieldProperties[textField]!, value: textField.text)
        didChange = true
    }
    
    func closeDatePickers(){
        for k in datePickerCells{
            var datePickerTableViewCell = k as DVDatePickerTableViewCell
            if datePickerTableViewCell.expanded == true{
                datePickerTableViewCell.selectedInTableView(tableView)
            }
        }
    }
    
//    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        var title:String = self.tableView(tableView, titleForHeaderInSection: section)!
//        return MarginedTableViewCell.HeaderViewForCell(tableView, section: section, title: title, style:nil )
//    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        var cell = self.tableView(tableView, cellForRowAtIndexPath: indexPath)
        if (cell.isKindOfClass(DVDatePickerTableViewCell)) {
            return (cell as DVDatePickerTableViewCell).datePickerHeight()
        }
        
        return super.tableView(tableView, heightForRowAtIndexPath: indexPath)
    }
    
    //DVDatepicker DELEGATE 
    
    func DVDatePickerDateDidChange(identifier:String, date: NSDate) {
        didChange = true
        delegate?.editingDatePickerDidChange(identifier, date: date)
    }
    
    // DELEGATE METHODS
    
    func editingTableViewShouldToggleEdit() -> Bool {
        return false
    }
    
    func editingDatePickerDidChange(identifier: String, date: NSDate) {
        //
    }
    
    func editingTableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    func editingTableViewIsExistingEntry() -> Bool {
        return false
    }
    
    func editingTableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return ""
    }
    
    func editingTextFieldDidChange(identifier: String, value:String) {
        //println("\(identifier) : \(value)")
    }
    
    func itemsForEditingTableView() -> Array<Array<editingTableViewItem>> {
        var rc = Array<Array<editingTableViewItem>>()
        return rc
    }
    
    func commitEditing() {
    }
    
    func commitDelete() {
    }
    
    func editingTableView(tableView: UITableView, didSelectRowWithIdentifier identifier: String) {
        //
    }
}
