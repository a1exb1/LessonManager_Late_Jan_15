//
//  StudentCourseLink.swift
//  LessonManager_Late_Jan_15
//
//  Created by Alex Bechmann on 19/01/2015.
//  Copyright (c) 2015 Alex Bechmann. All rights reserved.
//

import UIKit

class StudentCourseLink: NSObject {
    var webApiControllerName = "StudentCourseLinks"
    
    var StudentCourseLinkID:Int = 0
    var student:Student = Student()
    var course:Course = Course()
    var tutor:Tutor = Tutor()
    
    var LessonTime:TimeSpan = TimeSpan()
    
    init(json: JSON){
        super.init()
        setProperties(json)
    }
    
    override init(){
        super.init()
    }
    
    func Save(completionHandler:(response: Int) -> ()){
        var urlString = Tools.WebApiURL(webApiControllerName)
        var data:Dictionary<String, AnyObject> = [
            "StudentCourseLinkID": StudentCourseLinkID,
            "Weekday": LessonTime.Weekday.rawValue,
            "Duration": LessonTime.Duration,
            "Hour": LessonTime.Hour,
            "Minute": LessonTime.Minute,
            "CourseID": course.CourseID,
            "TutorID": tutor.PersonID,
            "StudentID": student.PersonID
        ]
        var method:HttpMethod = StudentCourseLinkID > 0 ? .PUT : .POST
        if isValid(){
            JSONReader.JsonAsyncRequest(urlString, data: data, httpMethod: method){ json in
                var response = Response(json: json["Response"])
                if response.Status == 0{
                    Tools.ShowAlertControllerOK(response.Message){ r in }
                }
                else{
                    self.setProperties(json)
                }
                
                completionHandler(response: response.Status)
            }
        }
        else{
            Tools.ShowAlertControllerOK("Details not valid!"){ response in
                completionHandler(response: 0)
            }
        }
    }
    
    func Delete(view:UIView, completionHandler:(response: Int) -> ()){
        Tools.ShowAlertController("Are you sure you want to remove " + student.Name + " from " + course.Name + "?"){ response in
            if response == 1{
                var urlString = Tools.WebApiURL(self.webApiControllerName) + "/" + String(self.StudentCourseLinkID)
                JSONReader.JsonAsyncRequest(urlString, data: nil, httpMethod: .DELETE){ json in
                    completionHandler(response: 1)
                }
            }
        }
    }
    
    func setProperties(json:JSON){
        self.StudentCourseLinkID = json["StudentCourseLinkID"].intValue
        self.student.setProperties(json["Student"])
        self.course.setProperties(json["Course"])
        self.tutor.PersonID = json["Course"]["TutorID"].intValue
        self.LessonTime.Weekday = DayOfWeek(rawValue:json["Weekday"].intValue)!
        self.LessonTime.Hour = json["Hour"].intValue
        self.LessonTime.Minute = json["Minute"].intValue
        self.LessonTime.Duration = json["Duration"].intValue
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

