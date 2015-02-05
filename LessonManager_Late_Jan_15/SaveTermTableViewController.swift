//
//  SaveTermTableViewController.swift
//  LessonManager_Late_Jan_15
//
//  Created by Alex Bechmann on 26/01/2015.
//  Copyright (c) 2015 Alex Bechmann. All rights reserved.
//

import UIKit

class SaveTermTableViewController: EditingTableViewController {

    var term:Term = Term()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func editingTableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //
    }
    
    override func editingTableViewIsExistingEntry() -> Bool {
        return term.TermID > 0
    }
    
    override func editingTableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "Info" : "Dates"
    }
    
    override func editingTextFieldDidChange(identifier: String, value:String) {
        switch identifier{
        case "Term": term.TermName = value; break;
        default:break;
        }
    }
    
    override func itemsForEditingTableView() -> Array<Array<editingTableViewItem>> {
        var rc = Array<Array<editingTableViewItem>>()
        rc.append(
            [
                editingTableViewItem(textLabelText: "Term name", detailTextLabelText: term.TermName, textFieldIdentifier: "Term", keyboardType: nil, editingType:nil, date: nil)
            ]
        )
        
        rc.append(
            [
                editingTableViewItem(textLabelText: "Start date", detailTextLabelText: term.TermName, textFieldIdentifier: "StartDate", keyboardType: nil, editingType:.Date, date: term.StartDate),
                editingTableViewItem(textLabelText: "End date", detailTextLabelText: term.TermName, textFieldIdentifier: "EndDate", keyboardType: nil, editingType:.Date, date: term.EndDate)
            ]
        )
        
        if term.TermID > 0{
            rc.append(
                [
                    editingTableViewItem(textLabelText: "Add lessons", detailTextLabelText: term.TermName, textFieldIdentifier: "AddLessons", keyboardType: nil, editingType:EditingType.Button, date: nil)
                ]
            )
        }
        
        return rc
    }
    
    override func commitEditing() {
        term.Save(){ response in
            println("") // ??
            self.navigationController?.popViewControllerAnimated(true)
        }
    }
    
    override func commitDelete() {
        term.Delete(){ response in
            println("") // ??
            self.navigationController?.popViewControllerAnimated(true)
        }
    }
    
    override func editingDatePickerDidChange(identifier: String, date: NSDate) {
        if identifier == "StartDate"{
            self.term.StartDate = date
        }
        else if identifier == "EndDate"{
            self.term.EndDate = date
        }
    }
    
    override func editingTableView(tableView: UITableView, didSelectRowWithIdentifier identifier: String) {
        println(identifier)
        if identifier == "AddLessons"{
            
            Tools.ShowAlertControllerWithButtonTitle("Add lessons", confirmBtnStyle: UIAlertActionStyle.Default, message: "Do you want to add lessons for all courses to this term?"){ response in
                if response == 1{
                    self.term.AddLessonsForAllCourses(session.tutor){ r in
                        if r == 1{
                            
                            if self.editing && self.didChange{
                                self.setEditing(!self.editing, animated: true)
                            }
                            else{
                                self.navigationController?.popViewControllerAnimated(true)
                            }
                        }
                    }
                }
            }
        }
    }
}
