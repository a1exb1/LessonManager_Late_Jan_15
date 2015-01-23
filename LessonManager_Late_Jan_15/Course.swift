//
//  Course.swift
//  LessonManager_Jan_15
//
//  Created by Alex Bechmann on 05/01/2015.
//  Copyright (c) 2015 Alex Bechmann. All rights reserved.
//

import UIKit

class Course: NSObject {
    var webApiControllerName = "Courses"
    
    var CourseID:Int = 0
    var Name:String = ""
    var tutor:Tutor = Tutor()
    
    init(json:JSON){
        super.init()
        setProperties(json)
    }
    
    override init(){

    }
    
    func Save(completionHandler:(response: Int) -> ()){
        var urlString = Tools.WebApiURL(webApiControllerName)
        var data:Dictionary<String, AnyObject> = [
            "CourseID": CourseID,
            "CourseName" : Name,
            "TutorID": tutor.PersonID
        ]
        
        var method:HttpMethod = CourseID > 0 ? .PUT : .POST
        JSONReader.JsonAsyncRequest(urlString, data: data, httpMethod: method){ json in
            self.setProperties(json)
            completionHandler(response: 1)
        }
        
    }
    
    func Delete(view:UIView, completionHandler:(response: Int) -> ()){
        Tools.ShowAlertController(view, message: "Are you sure you want to delete course: " + Name + "?"){ response in
            if response == 1{
                var urlString = Tools.WebApiURL(self.webApiControllerName) + "/" + String(self.CourseID)
                JSONReader.JsonAsyncRequest(urlString, data: nil, httpMethod: .DELETE){ json in
                    completionHandler(response: 1)
                }
            }
        }
        
        
    }
    
    func SwitchTutor(var ToTutor:Tutor, completionHandler:(response: Int) -> ()){
        var urlString = Tools.WebMvcController("Functions", action: "SetTutorForCourse")
        var data:Dictionary<String, AnyObject> = [
            "TutorID": ToTutor.PersonID,
            "CourseID" : CourseID,
        ]
        JSONReader.JsonAsyncRequest(urlString, data: data, httpMethod: .POST){ json in
            completionHandler(response: Response(json: json["Response"]).Status)
        }
        
    }
    
    func setProperties(json:JSON){
        self.CourseID = json["CourseID"].intValue
        self.Name = json["CourseName"].stringValue
    }
}
