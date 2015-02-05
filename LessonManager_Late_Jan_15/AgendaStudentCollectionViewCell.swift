//
//  AgendaStudentCollectionViewCell.swift
//  LessonManager_Jan_15
//
//  Created by Alex Bechmann on 01/01/2015.
//  Copyright (c) 2015 Alex Bechmann. All rights reserved.
//

import UIKit
import MessageUI

class AgendaStudentCollectionViewCell: UICollectionViewCell, UITableViewDelegate, UITableViewDataSource, MFMailComposeViewControllerDelegate {

    var student:Student? = nil
    @IBOutlet weak var studentNameLabel: UILabel!
    var mc: MFMailComposeViewController = MFMailComposeViewController()
    
    @IBOutlet weak var tableView: UITableView!
    
    func setup(student:Student){
        self.student = student
        self.studentNameLabel.text = student.Name
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell  = UITableViewCell(style: .Value1, reuseIdentifier: "Cell")
        if indexPath.row == 0{
            cell.textLabel!.text = "Call"
            cell.detailTextLabel!.text = student?.Phone
        }
        if indexPath.row == 1{
            cell.textLabel!.text = "Mobile"
            cell.detailTextLabel!.text = student?.Mobile
        }
        if indexPath.row == 2{
            cell.textLabel!.text = "Email"
            cell.detailTextLabel!.text = student?.Email
        }
        cell.textLabel?.textColor = UIColor(red: 0/255, green: 122/255, blue: 1, alpha: 1)
        cell.detailTextLabel?.textColor = UIColor(red: 0/255, green: 122/255, blue: 1, alpha: 1)
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 0{
            Tools.ShowAlertControllerWithButtonTitle("Call", confirmBtnStyle: UIAlertActionStyle.Default, message: "Call \(student!.Name): \(student!.Phone)"){ response in
                if response == 1 {
                    var str:String = "tel://" + self.student!.Phone.replace(" ", withString: "")
                    if let url = NSURL(string: str) {
                        UIApplication.sharedApplication().openURL(url)
                    }
                }
                tableView.deselectRowAtIndexPath(indexPath, animated: true)
            }
        }
        if indexPath.row == 1{
            Tools.ShowAlertControllerWithButtonTitle("Call", confirmBtnStyle: UIAlertActionStyle.Default, message: "Call \(student!.Name): \(student!.Phone)"){ response in
                if response == 1{
                    var str:String = "tel://" + self.student!.Mobile.replace(" ", withString: "")
                    if let url = NSURL(string: str) {
                        UIApplication.sharedApplication().openURL(url)
                    }
                }
                tableView.deselectRowAtIndexPath(indexPath, animated: true)
            }
        }
        if indexPath.row == 2{
            var emailTitle = ""
            var messageBody = "";
            var toRecipents = [student!.Email]
            
            mc = MFMailComposeViewController()
            mc.mailComposeDelegate = self
            mc.setSubject(emailTitle)
            mc.setMessageBody(messageBody, isHTML: false)
            mc.setToRecipients(toRecipents)
            Tools.TopMostController().presentViewController(mc, animated: true, completion: nil)

        }
        
    }
    
    func mailComposeController(controller: MFMailComposeViewController!, didFinishWithResult result: MFMailComposeResult, error: NSError!) {
        mc.dismissViewControllerAnimated(true, completion: nil)
        if let indexPath = tableView.indexPathForSelectedRow(){
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
        }
    }

}
