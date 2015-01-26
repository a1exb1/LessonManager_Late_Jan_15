//
//  Teacher.swift
//  LessonManager_Dec_14
//
//  Created by Alex Bechmann on 23/12/2014.
//  Copyright (c) 2014 Alex Bechmann. All rights reserved.
//

import UIKit

//@objc protocol teacherDataDelegate{
//    func ReceivedJSON(requestString:String)
//}

class Tutor: Person{
    
    var webApiControllerName = "Tutors"
    var Courses:Array<Course> = []
    var requestedDate:NSDate = NSDate()
    
    func GetLessons(date: NSDate, completionHandler:(response: Array<Lesson>) -> ()){
        var urlString = Tools.WebMvcController("Calender", action: "AgendaForTutorAndDate")
        var data:Dictionary<String, AnyObject> = [
            "TutorID": PersonID,
            "date": Tools.StringFromDate(date, format: "dd/MM/yyyy")
        ]
        JSONReader.JsonAsyncRequest(urlString, data:data, httpMethod: .POST){ json in
            var lessons = Array<Lesson>()
            for (index: String, lessonJSON: JSON) in json["Items"] {
                var lesson:Lesson = Lesson(json:lessonJSON)
                lessons.append(lesson)
            }
            completionHandler(response: lessons)
        }
    }
    
    func Login(username:String, password:String, completionHandler:(response: Int) -> ()){
        var urlString = Tools.WebApiURL("Login")
        var data:Dictionary<String, AnyObject> = [
            "UserName": username,
            "Password": password
        ]
        JSONReader.JsonAsyncRequest(urlString, data: data, httpMethod: .POST){ json in
            self.setProperties(json["Tutor"])
            session.tutor = self
            session.client.setProperties(json["Client"]) // needs to be inside tutor as obj
            completionHandler(response: Response(json: json["Response"]).Status)
        }

    }
    
    func Save(completionHandler:(response: Int) -> ()){
        var urlString = Tools.WebApiURL(webApiControllerName)
        var data:Dictionary<String, AnyObject> = [
            "TutorID": PersonID,
            "TutorName" : Name,
            "Telephone": Phone,
            "Mobile": Mobile,
            "ClientID": session.client.ClientID,
            "Email": Email,
            "UserName": UserName,
            "AccountType": AccountType,
            "Password": Password,
            "Active": Active
        ]
        
        var method:HttpMethod = PersonID > 0 ? .PUT : .POST
        JSONReader.JsonAsyncRequest(urlString, data: data, httpMethod: method){ json in
            self.setProperties(json)
            completionHandler(response: 1)
        } 
    }
    
    func Delete(view:UIView, completionHandler:(response: Int) -> ()){
        Tools.ShowAlertController("Are you sure you want to delete tutor: " + Name + "?"){ response in
            if response == 1{
                var urlString = Tools.WebApiURL(self.webApiControllerName) + "/" + String(self.PersonID)
                JSONReader.JsonAsyncRequest(urlString, data: nil, httpMethod: .DELETE){ json in
                    completionHandler(response: 1)
                }
            }
        }
    }
    
    func GetLessonSlots(completionHandler:(response: Array<StudentCourseLink>) -> ()){
        var urlString = Tools.WebMvcController("Tutor", action: "GetLessonSlots")
        var data:Dictionary<String, AnyObject> = [
            "TutorID": PersonID
        ]
        
        var method:HttpMethod = PersonID > 0 ? .PUT : .POST
        JSONReader.JsonAsyncRequest(urlString, data: data, httpMethod: method){ json in
            var slots = Array<StudentCourseLink>()
            for (index: String, slotJSON: JSON) in json["slots"]{
                var slot = StudentCourseLink(json: slotJSON)
                slots.append(slot)
            }
            completionHandler(response: slots)
        }

    }
    
    func getTerms(completionHandler:(response: Array<Term>) -> ()){
        var urlString = Tools.WebApiURL("Terms")
        var data:Dictionary<String, AnyObject> = [
            "TutorID": PersonID
        ]
        
        JSONReader.JsonAsyncRequest(urlString, data: data, httpMethod: .GET){ json in
            var terms = Array<Term>()
            for (index: String, termJSON: JSON) in json{
                var term = Term(json: termJSON)
                terms.append(term)
            }
            completionHandler(response: terms)
        }
    }
    
    override func setProperties(json:JSON){
        super.setProperties(json)
        self.PersonID = json["TutorID"].intValue
        self.Name = json["TutorName"].stringValue
    }
    
}
