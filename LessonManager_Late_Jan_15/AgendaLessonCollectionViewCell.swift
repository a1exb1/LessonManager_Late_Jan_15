//
//  AgendaLessonCollectionViewCell.swift
//  LessonManager_Jan_15
//
//  Created by Alex Bechmann on 01/01/2015.
//  Copyright (c) 2015 Alex Bechmann. All rights reserved.
//

import UIKit

class AgendaLessonCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var TimeLabel: UILabel!
    @IBOutlet weak var timeRemainingCountdownLbl: UILabel!
    @IBOutlet weak var timeRemainingLbl: UILabel!
    var lesson:Lesson? = nil
    var updateTimer = NSTimer()
    var showColon = true // for timer label
    
    func setup(lesson:Lesson){
        self.lesson = lesson
        self.TimeLabel.text = Tools.StringFromDate(lesson.Date, format: "dd/MM/yyyy HH:mm") + " (\(self.lesson!.Duration) mins)"

        updateLabels()
        updateTimer = NSTimer.scheduledTimerWithTimeInterval(2.0, target: self, selector: "updateLabels", userInfo: nil, repeats: true)
    }
    
    func updateLabels(){
        //dates
        var d:NSDate = NSDate()  // = Tools.DateFromString("15/09/2014 17:14:00")
        
        if (Tools.CompareDates(d, date2: lesson!.Date) == DateComparison.Earlier &&
            Tools.CompareDates(d, date2: lesson!.EndDate) == DateComparison.Later){
                var span:DateRange = lesson!.EndDate - d
                var colon = showColon ? ":" : ":" // change to blink
                
                self.timeRemainingCountdownLbl.text = String(format: "%02d", span.hours) + colon + String(format: "%02d", span.minutes - (span.hours * 60))
                showColon = !showColon
                self.timeRemainingLbl.text = "remaining"
                
        }
        else if (Tools.CompareDates(d, date2: lesson!.Date) == DateComparison.Earlier){
            self.timeRemainingCountdownLbl.text = "Completed"
            self.timeRemainingLbl.text = ""
        }
        else if (Tools.CompareDates(d, date2: lesson!.EndDate) == DateComparison.Later){
            self.timeRemainingCountdownLbl.text = "Upcoming"
            self.timeRemainingLbl.text = ""
        }
    }
}
