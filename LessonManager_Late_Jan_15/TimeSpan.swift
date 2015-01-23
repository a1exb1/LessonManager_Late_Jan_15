//
//  TimeSpan.swift
//  LessonManager_Late_Jan_15
//
//  Created by Alex Bechmann on 21/01/2015.
//  Copyright (c) 2015 Alex Bechmann. All rights reserved.
//

import UIKit

enum DayOfWeek:Int{
    case None = 0
    case Monday = 1
    case Tuesday = 2
    case Wednesday = 3
    case Thursday = 4
    case Friday = 5
    case Saturday = 6
    case Sunday = 7
}

class TimeSpan: NSObject {
    var Weekday:DayOfWeek = DayOfWeek.Monday
    var Hour:Int = 10
    var Minute:Int = 0
    var Duration:Int = 30
    
    override init(){
        super.init()
    }
    
    init(var pickerWeekday:Int, var pickerHour:Int, var pickerMinute:Int, pickerDuration:Int){
        super.init()
        self.Weekday = DayOfWeek(rawValue: pickerWeekday+1)!
        self.Hour = pickerHour + 1
        self.Minute = (pickerMinute) * 5
        self.Duration = (pickerDuration + 1) * 15
    }
    
    func PickerValues() -> Dictionary<String, Int>{
        var rc = Dictionary<String, Int>()
        rc["pickerWeekday"] = self.Weekday.rawValue - 1
        rc["pickerHour"] = self.Hour - 1
        rc["pickerMinute"] = self.Minute / 5
        rc["pickerDuration"] = (self.Duration / 15) - 1
        return rc
    }
    
    class func TitleForDayOfWeek(var i:Int) -> String{
        var rc = "None"
        switch i{
            case 1: rc = "Mon"; break
            case 2: rc = "Tue"; break
            case 3: rc = "Wed"; break
            case 4: rc = "Thu"; break
            case 5: rc = "Fri"; break
            case 6: rc = "Sat"; break
            case 7: rc = "Sun"; break
            default: break
        }
        return rc
    }
    
    class func TitleForDayOfWeekFromPicker(var pickerRow:Int) -> String{
        return TitleForDayOfWeek(pickerRow + 1)
    }
    
    func setPicker(picker:UIPickerView){
        var v = PickerValues()
        picker.selectRow(v["pickerWeekday"]!, inComponent: 0, animated: false)
        picker.selectRow(v["pickerHour"]!, inComponent: 1, animated: false)
        picker.selectRow(v["pickerMinute"]!, inComponent: 2, animated: false)
        picker.selectRow(v["pickerDuration"]!, inComponent: 3, animated: false)
    }
}

