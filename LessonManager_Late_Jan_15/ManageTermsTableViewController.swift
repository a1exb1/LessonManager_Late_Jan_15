//
//  ManageTermsTableViewController.swift
//  LessonManager_Late_Jan_15
//
//  Created by Alex Bechmann on 26/01/2015.
//  Copyright (c) 2015 Alex Bechmann. All rights reserved.
//

import UIKit

class ManageTermsTableViewController: UITableViewController {

    var terms = Array<Term>()

    override func viewDidLoad() {
        super.viewDidLoad()
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
//
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "addTerm")
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        Tools.AddLoaderToView(self.view)
        session.tutor.getTerms(){ response in
            self.terms = response
            self.tableView.reloadData()
            Tools.HideLoaderFromView(self.view)
        }
    }
    
    func addTerm(){
        var v = SaveTermTableViewController()
        self.navigationController?.pushViewController(v, animated: true)
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return terms.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell =  UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "Cell")

        var term = terms[indexPath.row]
        cell.textLabel?.text = term.TermName
        cell.detailTextLabel!.text = Tools.StringFromDate(term.StartDate, format: LMDateFormat.Date.rawValue) + " - " + Tools.StringFromDate(term.EndDate, format: LMDateFormat.Date.rawValue)

        return cell
    }
    

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var term = terms[indexPath.row]
        
        var v = SaveTermTableViewController()
        v.term = term
        self.navigationController?.pushViewController(v, animated: true)
    }


}
