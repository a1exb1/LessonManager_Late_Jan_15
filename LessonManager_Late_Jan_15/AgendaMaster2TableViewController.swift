//
//  AgendaMaster2TableViewController.swift
//  LessonManager_Jan_15
//
//  Created by Alex Bechmann on 14/01/2015.
//  Copyright (c) 2015 Alex Bechmann. All rights reserved.
//

import UIKit

class AgendaMaster2TableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CalenderControlDelegate, SessionDelegate {

    //var detailViewController: DetailViewController? = nil
    var calenderView:CalenderControl? = nil
    
    var tableView = UITableView(frame: CGRectZero, style: UITableViewStyle.Grouped)
    var lessons:Array<Lesson> = []
    var takeAttendanceBtn:UIBarButtonItem = UIBarButtonItem()
    var nav:UINavigationController = UINavigationController()
    var monthData: Dictionary<NSDate,JSON> = Dictionary<NSDate, JSON>()
    //var toolbar:UIToolbar = UIToolbar()
    @IBOutlet weak var toolbar: UIToolbar!
    var settingsNvc = UINavigationController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Today", style: UIBarButtonItemStyle.Bordered, target: self, action: "goToToday")
        self.navigationItem.leftBarButtonItems = [self.editButtonItem()]
//        UIBarButtonItem(title: "Cmode", style: UIBarButtonItemStyle.Bordered, target: self, action: "switchCalenderMode")
//        ]
        
        self.navigationItem.rightBarButtonItems = [UIBarButtonItem(image: UIImage(named: "766-arrow-right-toolbar"), style: UIBarButtonItemStyle.Bordered, target: self, action: "nextMonth"),
            UIBarButtonItem(image: UIImage(named: "765-arrow-left-toolbar"), style: UIBarButtonItemStyle.Bordered, target: self, action: "prevMonth")]
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        tableView.dataSource = self
        tableView.delegate = self
        self.view.addSubview(tableView)
        
        self.navigationController!.tabBarItem!.selectedImage = UIImage(named: "728-clock-selected.png")
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.barTintColor = LMColor.purpleColor()
        self.navigationController?.navigationBar.translucent = false
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.navigationController?.navigationBar.titleTextAttributes = titleDict
        
        self.view.addSubview(toolbar)
        self.setNeedsStatusBarAppearanceUpdate()
        
//        if let split = self.splitViewController {
//            let controllers = split.viewControllers
//            self.detailViewController = controllers[controllers.count-1].topViewController as? DetailViewController
//        }
        
        session.agendaMasterDelegate = self
    }
    
    func masterNeedsUpdate(){
        getData()
        getMonthData()
    }
    
    func setToday(){
        self.calenderView?.date = NSDate()
        self.calenderView?.reloadActiveCollectionViewData()
    }
    
    override func viewWillAppear(animated: Bool) {
        if calenderView == nil{
            calenderView = CalenderControl(origin: self.view, navigationItem:navigationItem)
            calenderView?.delegate = self
            calenderView?.setIsMonthMode(true)
        }
        
        getMonthData()
        self.calenderControlDidSelectDate(calenderView!.selectedDate)
    }
    
    func switchCalenderMode(){
        calenderView?.setIsMonthMode(!calenderView!.isMonthMode)
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        layoutViews()
        //getData();println(1)
    }
    
    func calenderControlDidChangeMode() {
        layoutViews()
    }
    
    override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
        layoutViews()
    }
    
    func layoutViews(){
        //toolbar items
        var leftButton:UIBarButtonItem = UIBarButtonItem(title: "Today", style: UIBarButtonItemStyle.Bordered, target: self, action: "setToday")
        
        var manageBtn:UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "742-wrench.png"), style: UIBarButtonItemStyle.Bordered, target: self, action: "goToSettings")
        
        var flex = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        
        //self.toolbarItems = [leftButton, flex, manageBtn]
        //toolbar.frame = CGRectMake(0, self.view.frame.size.height - 46, self.view.frame.size.width, 46)
        toolbar.sizeToFit()
        toolbar.setItems([leftButton, flex, manageBtn], animated: true)
        
        tableView.frame = CGRect(x: 0, y: calenderView!.frame.height, width: self.view.frame.width, height: self.view.frame.height - calenderView!.frame.height - toolbar.frame.height)
        var indexPath = self.tableView.indexPathForSelectedRow()
        if indexPath != nil{
            self.tableView.deselectRowAtIndexPath(indexPath!, animated: true)
        }
        calenderView?.onDidRotate()
    }
    
    func goToSettings(){
        settingsNvc = UINavigationController()
        settingsNvc.modalPresentationStyle = UIModalPresentationStyle.FormSheet
        
        var view = ManageMasterTableViewController()
        settingsNvc.pushViewController(view, animated: false)
        view.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Close", style: UIBarButtonItemStyle.Bordered, target: self, action: "exitSettings")
        self.presentViewController(settingsNvc, animated: true, completion: nil)
    }
    
    func exitSettings(){
        settingsNvc.dismissViewControllerAnimated(true, completion: nil)
        //getData()
        
    }
    
    func calenderControlDidSelectDate(date: NSDate) {
        Tools.AddLoaderToView(self.tableView)
        getData()//;println(2)
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    func prevMonth(){
        calenderView?.previousMonth()
    }
    
    func nextMonth(){
        calenderView?.nextMonth()
    }
    
    func getData(){
        self.lessons = []
        self.tableView.reloadData()
        Tools.AddLoaderToView(self.tableView)
        Tools.AddLoaderToView(self.tableView)
        session.tutor.GetLessons(calenderView!.selectedDate){ lessons in
            self.lessons = lessons
            self.tableView.reloadData()
            Tools.HideLoaderFromView(self.tableView)
            self.tableView.hidden = false
        }
    }
    

    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return lessons.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:AgendaItemTableViewCell = AgendaItemTableViewCell(lesson: lessons[indexPath.row])
        
        // Configure the cell...
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("showDetailLesson", sender: self)
    }
    
    
    func closePopover(){
        nav.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete{
            var lesson = lessons[indexPath.row]
            lesson.Delete(self.tableView){ response in
                if response == 1{
                    self.getData()//;println(3)
                }
                else{
                    tableView.reloadData()
                }
                
            }
        }
    }

    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return Tools.StringFromDate(calenderView!.selectedDate, format: "dd/MM/yyyy")
    }
    
    override func setEditing(editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: true)
        self.tableView.setEditing(editing, animated: animated)
        if !editing{ getData() }
    }
    
    func calenderControlShouldShowIndicator(date: NSDate) -> Bool {
        var json:JSON? = monthData[date]
        return json?["AgendaItems"].arrayValue.count > 0 ? true : false
    }
    
    func calenderControlDidChangeMonth(toMonth:NSDate){
        getMonthData()
    }
    
    func getMonthData(){
        var urlString = Tools.WebMvcController("Calender", action: "OverviewForDaysBetween")
        var data:Dictionary<String, AnyObject> = [
            "TutorID": session.tutor.PersonID,
            "fromDate": Tools.StringFromDate(calenderView!.firstDateOfMonth.dateBySubtractingDays(7), format: "dd/MM/yyyy"),
            "toDate": Tools.StringFromDate(calenderView!.firstDateOfMonth.dateByAddingDays(43), format: "dd/MM/yyyy")
        ]
        self.calenderView?.reloadActiveCollectionViewData()
        JSONReader.JsonAsyncRequest(urlString, data:data, httpMethod: HttpMethod.POST){ json in
            self.monthData = Dictionary<NSDate,JSON>()
            for (index: String, dayJSON: JSON) in json["Days"] {
                var date = Tools.DateFromString(dayJSON["Date"].stringValue, format:"dd/MM/yyyy").dateAtStartOfDay()
                self.monthData[date] = dayJSON
                self.calenderView?.reloadActiveCollectionViewData()
            }
            
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetailLesson" {
            if let indexPath = self.tableView.indexPathForSelectedRow() {
//                let object = objects[indexPath.row] as NSDate
            
                var controller = segue.destinationViewController.topViewController as AgendaDetailCollectionViewController
                
                //var nav = segue.destinationViewController as UINavigationController
                //var controller = self.storyboard?.instantiateViewControllerWithIdentifier("AgendaCollectionViewController") as AgendaDetailCollectionViewController
                controller.lessonCount = lessons.count
                var indexPath = self.tableView.indexPathForSelectedRow()
                controller.selectLesson(lessons[indexPath!.row], index: indexPath!.row)
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
                controller.navigationItem.leftItemsSupplementBackButton = true
                
                //nav.pushViewController(controller, animated: false)
                
            }
        }
    }
}
