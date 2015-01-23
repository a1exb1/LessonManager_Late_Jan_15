//
//  Lesson.swift
//  LessonManager_Dec_14
//
//  Created by Alex Bechmann on 23/12/2014.
//  Copyright (c) 2014 Alex Bechmann. All rights reserved.
//

import UIKit

enum LessonStatus:Int{
    case NotSet = 0
    case Present = 1
    case Absent = 2
    case Cancelled = 3
}

class Lesson: NSObject {
    var webApiControllerName = "Lessons"
    
    var LessonID: Int = 0
    var Duration: Int = 30
    var student: Student = Student()
    var course:Course = Course()
    var teacher: Tutor = Tutor()
    var Date: NSDate = NSDate()
    var EndDate:NSDate = NSDate()
    var Status:LessonStatus = .NotSet
    
    override init() {
        super.init()
    }
    
    init(json:JSON){
        super.init()
        setProperties(json)
    }
    
    func setProperties(json:JSON){
        self.LessonID = json["Lesson"]["LessonID"].intValue
        self.Duration = json["Lesson"]["Duration"].intValue
        self.Status = LessonStatus(rawValue: json["Lesson"]["Status"].intValue)!
        
        var s:Student = Student()
        s.setProperties(json["Student"])
        self.student = s
        
        var c:Course = Course()
        c.setProperties(json["Course"])
        self.course = c
        
        self.Date = Tools.DateFromISO8601String(json["LessonDateTime"].stringValue + "+00:00")
        self.EndDate = self.Date.dateByAddingMinutes(Duration)
    }
    
    func SetAttendance(status:LessonStatus, completionHandler:(response: Int) -> ()){
        var urlString = Tools.WebMvcController("Lesson", action: "SetAttendance")
        var data = [
            "LessonID": LessonID,
            "status": status.rawValue
        ];
        JSONReader.JsonAsyncRequest(urlString, data: data, httpMethod: .POST){ json in
            completionHandler(response: Response(json: json).Status)
        }
    }
    
    func Save(completionHandler:(response: Int) -> ()){
        var urlString = Tools.WebApiURL(webApiControllerName)
        var data:Dictionary<String, AnyObject> = [
            "LessonID": LessonID,
            "Duration": Duration,
            "CourseID": course.CourseID,
            "StudentID": student.PersonID,
            "LessonDateTime":  Tools.StringFromDate(Date, format: "yyyy-MM-dd") + "T" + Tools.StringFromDate(Date, format: "hh:mm") + ":00" //"2015-01-07T12:15:00"
        ]
        println(data)
        var method:HttpMethod = LessonID > 0 ? .PUT : .POST
        if isValid(){
            JSONReader.JsonAsyncRequest(urlString, data: data, httpMethod: method){ json in
                println(json)
                var response = Response(json: json["Response"])
                if response.Status == 0{
                    Tools.ShowAlertControllerOK(Tools.TopMostController().view, message: response.Message){ r in }
                }
                else{
                    //self.setProperties(json["Lesson"])
                }
                
                completionHandler(response: response.Status)
            }
        }
        else{
            Tools.ShowAlertControllerOK(Tools.TopMostController().view, message: "Details not valid!"){ response in
                completionHandler(response: 0)
            }
        }
    }

    
    func Delete(view:UIView, completionHandler:(response: Int) -> ()){
        Tools.ShowAlertController(view, message: "Are you sure you want to delete " + student.Name + "'s lesson at " + Tools.StringFromDate(self.Date, format: LMDateFormat.DateTime.rawValue) + "?"){ response in
            if response == 1{
                var urlString = Tools.WebMvcController("Lesson", action: "DeleteLesson")
                var data = [
                    "LessonID": self.LessonID
                ];
                JSONReader.JsonAsyncRequest(urlString, data: data, httpMethod: .DELETE){ json in
                    completionHandler(response: 1)
                }
            }
            else{
                completionHandler(response: 0)
            }
        }
        
    }
    
    func isValid() -> Bool {
        if student.PersonID < 1{
            return false
        }
        //        if tutor.PersonID < 1{
        //            return false
        //        }
        if course.CourseID < 1{
            return false
        }
        return true
    }
}

