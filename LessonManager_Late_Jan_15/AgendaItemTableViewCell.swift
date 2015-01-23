//
//  AgendaItemTableViewCell.swift
//  LessonManager_Dec_14
//
//  Created by Alex Bechmann on 23/12/2014.
//  Copyright (c) 2014 Alex Bechmann. All rights reserved.
//

import UIKit


class AgendaItemTableViewCell: UITableViewCell {

    var lesson:Lesson = Lesson()
    var lineView:UIView = UIView()
    var attendanceControl:UISegmentedControl = UISegmentedControl()
    
    init(lesson:Lesson) {
        super.init(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "Cell")
        
        self.lesson = lesson
        
        var lineHeight:CGFloat = self.viewForBaselineLayout()!.frame.size.height - 2
        lineView = UIView(frame: CGRectMake(0, 1, 3.0, lineHeight))
        
        //dates
        var d:NSDate = NSDate()  // = Tools.DateFromString("15/09/2014 17:14:00")
        
        if (Tools.CompareDates(d, date2: lesson.Date) == DateComparison.Earlier &&
            Tools.CompareDates(d, date2: lesson.EndDate) == DateComparison.Later){
            lineView.backgroundColor = LMColor.greenColor()
        }
        else if (Tools.CompareDates(d, date2: lesson.Date) == DateComparison.Earlier){
            lineView.backgroundColor = LMColor.maroonColor()
        }
        else if (Tools.CompareDates(d, date2: lesson.EndDate) == DateComparison.Later){
            lineView.backgroundColor = LMColor.navyColor()
        }
        
        self.addSubview(lineView);
        
        //self.selectedBackgroundView.backgroundColor = UIColor.greenColor().colorWithAlphaComponent(0.1)
        
        //dot
        var attendanceColours = [
            UIColor.grayColor(),
            UIColor(hexColorCode: "#5cb444"),
            UIColor(hexColorCode: "#b44444"),
            UIColor(hexColorCode: "#e84721")
            //,
            
        ]
        
        var attendenceCircle:UIImageView = UIImageView(frame:CGRectMake(0, 0, 8, 8));
        attendenceCircle.image = Tools.imageWithColor(attendanceColours[lesson.Status.rawValue], size: CGSizeMake(8, 8))
        var l:CALayer = attendenceCircle.layer
        l.masksToBounds = true
        l.cornerRadius = 4.0
        self.accessoryView = attendenceCircle;
 
        self.textLabel!.textColor = UIColor.darkTextColor()
        let selectedView:UIView = UIView(frame: CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height))
        selectedView.backgroundColor = UIColor.grayColor().colorWithAlphaComponent(0.7)
        
        var selectedLineView:UIView = UIView(frame: CGRectMake(0, 1, 3.0, lineHeight))
        selectedLineView.backgroundColor = LMColor.orangeColor()
        selectedView.addSubview(selectedLineView)
        self.selectedBackgroundView = selectedView
        
        
        //var lesson:Lesson = session.teacher.Lessons[indexPath.row]
        self.textLabel!.text = lesson.student.Name
        self.detailTextLabel!.text = Tools.StringFromDateWithFormat(lesson.Date, format: "HH:mm") + " (" + String(lesson.Duration) + " mins)"
        
        //attendence
        
        var editView:UIView = UIView()
        editView = UIView(frame: CGRect(x: 0, y: 0, width: self.bounds.width - 155, height: self.bounds.height))
        attendanceControl = UISegmentedControl(frame: CGRect(x: editView.bounds.origin.x, y: editView.frame.origin.y + 5, width: editView.bounds.width - 5, height: editView.bounds.height - 10))
        attendanceControl.insertSegmentWithTitle("None", atIndex: 0, animated: false)
        attendanceControl.insertSegmentWithTitle("Absent", atIndex: 1, animated: false)
        attendanceControl.insertSegmentWithTitle("Present", atIndex: 2, animated: false)
        
        var statusid = lesson.Status.rawValue
        if statusid == 1{ //switch pos round
            statusid = 2
        }
        else if statusid == 2{
            statusid = 1
        }
        
        attendanceControl.selectedSegmentIndex = statusid
        attendanceControl.addTarget(self, action: "setAttendance:", forControlEvents: UIControlEvents.ValueChanged)
        editView.addSubview(attendanceControl)
        self.editingAccessoryView = editView
        
    }
    
    func setAttendance(control:UISegmentedControl){
        var statusid = control.selectedSegmentIndex
        if statusid == 1{ //switch pos round
            statusid = 2
        }
        else if statusid == 2{
            statusid = 1
        }
        var status = LessonStatus(rawValue: statusid)!
        lesson.SetAttendance(status){ response in
        }
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
    }
    
//    convenience override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
//        self.init(style: style, reuseIdentifier: reuseIdentifier)
//        
//    }
    
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        self.selectedBackgroundView.backgroundColor = UIColor(red: 255/255, green: 242/255, blue: 219/255, alpha: 1)
        var selectedLineView:UIView = Tools.CloneView(lineView)
        self.selectedBackgroundView.addSubview(selectedLineView)
    }

}
