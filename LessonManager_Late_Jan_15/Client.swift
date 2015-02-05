//
//  Client.swift
//  LessonManager_Jan_15
//
//  Created by Alex Bechmann on 03/01/2015.
//  Copyright (c) 2015 Alex Bechmann. All rights reserved.
//

import UIKit

class Client: NSObject{
    var ClientID:Int = 0
    var Name:String = ""
    var AccountType:Int = 0
    var ClientUserName = ""
    var Tutors:Array<Tutor> = []
    var Students:Array<Student> = []
    var Active = "Y"
    var EnteredDate = NSDate.ISOStringFromDate(NSDate())
    
    func GetTutorsAndCourses(completionHandler:(response: Int) -> ()){
        var urlString = Tools.WebMvcController("Client", action: "GetTutorsAndCourses")
        JSONReader.JsonAsyncRequest(urlString, data: ["ClientID": ClientID], httpMethod: .POST){ json in
            self.Tutors = []
            for (index: String, tutorJSON: JSON) in json {
                var tutor:Tutor = Tutor()
                tutor.setProperties(tutorJSON)
                for (index: String, courseJSON: JSON) in tutorJSON["Courses"] {
                    var course:Course = Course(json: courseJSON)
                    tutor.Courses.append(course)
                }
                self.Tutors.append(tutor)
            }
            completionHandler(response: 1)
        }
    }
    
    func GetStudents(completionHandler:(response: Int) -> ()){
        var urlString = Tools.WebMvcController("Client", action: "GetStudents");
        var data:Dictionary<String, AnyObject> = [
            "ClientID": ClientID,
            "Active": Active
        ]
        JSONReader.JsonAsyncRequest(urlString, data: data, httpMethod: .POST){ json in
            self.Students = []
            for (index: String, studentJSON: JSON) in json {
                var student = Student()
                student.setProperties(studentJSON)
                self.Students.append(student)
                completionHandler(response: 1)
            }
        }
    }
    
    func setProperties(json:JSON){
        ClientID = json["ClientID"].intValue
        Name = json["ClientName"].stringValue
        AccountType = json["AccountType"].intValue
        ClientUserName = json["ClientUserName"].stringValue
    }
}
