//
//  ManageTutorsTableViewController.swift
//  LessonManager_Jan_15
//
//  Created by Alex Bechmann on 05/01/2015.
//  Copyright (c) 2015 Alex Bechmann. All rights reserved.
//

import UIKit

class ManageTutorsTableViewController: UITableViewController {

    //var splitView:SplitView? = nil
    
    convenience override init() {
        self.init(style: .Grouped)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Tutors"
        applyViewStyles()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: "newTutor")
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        applyViewStyles()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        session.client.GetTutorsAndCourses(){ response in
            self.tableView.reloadData()
        }
    }
    
    override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
        applyViewStyles()
    }

    func applyViewStyles(){
        //splitView?.addDetailMenuButtonToNavigationBar(self.navigationItem, button: nil)
        MarginedTableViewCell.ApplyTableViewStyles(tableView)
    }
    
    func newTutor(){
        var view:SaveTutorTableViewController = SaveTutorTableViewController()
        view.tutor = Tutor()
        self.navigationController?.pushViewController(view, animated: true)
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return session.client.Tutors.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = MarginedTableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "Cell")
        cell.containerView = self.tableView
        cell.indexPath = indexPath
        cell.numberOfRowsInSection = tableView.numberOfRowsInSection(indexPath.section)
        
        var tutor:Tutor = session.client.Tutors[indexPath.row]
        cell.textLabel?.text = tutor.Name
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        
        var editingAccessoryVariables = Tools.TextFieldViewForEditingMode(self.tableView.bounds)
        cell.editingAccessoryView = editingAccessoryVariables.view
        
        
        cell.setNeedsLayout()
        return cell
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        //Tools.marginedtableView(tableView, cell: cell, indexPath: indexPath)
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var view:SaveTutorTableViewController = SaveTutorTableViewController()
        view.tutor = session.client.Tutors[indexPath.row]
        self.navigationController?.pushViewController(view, animated: true)
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var title:String = self.tableView(tableView, titleForHeaderInSection: section)!
        return MarginedTableViewCell.HeaderViewForCell(tableView, section: section, title: title, style:nil )
    }

}
