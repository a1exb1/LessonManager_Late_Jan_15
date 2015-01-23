//
//  ManageMasterTableViewController.swift
//  LessonManager_Jan_15
//
//  Created by Alex Bechmann on 02/01/2015.
//  Copyright (c) 2015 Alex Bechmann. All rights reserved.
//

import UIKit

class ManageMasterTableViewController: UITableViewController {

    
    convenience override init() {
        self.init(style: .Grouped)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Manage"
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 2
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return section == 0 ? 3 : 1
    }

    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "Client controls" : "Your controls"
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "Cell")
        
        // Configure the cell...
        if indexPath.section == 0{
            switch indexPath.row{
            case 0:
                cell.textLabel?.text = "Tutors"
                cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
                break
                
            case 1:
                cell.textLabel?.text = "Courses"
                cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
                break
                
            case 2:
                cell.textLabel?.text = "Students"
                cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
                break
                
            default:
                break
            }
        }
        
        if indexPath.section == 1{
            switch indexPath.row{
            case 0:
                cell.textLabel?.text = "Lesson slots"
                cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
                break
                
            default:
                break
            }
        }

        cell.selectionStyle = UITableViewCellSelectionStyle.Blue // doesnt work?!
        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var v:UIViewController? = nil
        
        if indexPath.section == 0{
            switch indexPath.row{
            case 0: v = ManageTutorsTableViewController(); break
            case 1: v = ManageCoursesDetailTableViewController(); break
            case 2: v = ManageStudentsTableViewController(); break
            default: break
            }
        }
        
        if indexPath.section == 1{
            switch indexPath.row{
            case 0: v = ManageStudentCourseLinksTableViewController(); break
            default: break
            }
        }
        
        
        
        self.navigationController?.pushViewController(v!, animated: true)
        

    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
