//
//  Student.swift
//  LessonManager_Dec_14
//
//  Created by Alex Bechmann on 23/12/2014.
//  Copyright (c) 2014 Alex Bechmann. All rights reserved.
//

import UIKit

class Student: Person {
    
    var webApiControllerName = "Students"
    
    func Save(completionHandler:(response: Int) -> ()){
        var urlString = Tools.WebApiURL(webApiControllerName)
        var data:Dictionary<String, AnyObject> = [
            "StudentID": PersonID,
            "StudentName" : Name,
            "Telephone": Phone,
            "Mobile": Mobile,
            "ClientID": session.client.ClientID,
            "Email": Email
        ]
        
        var method:HttpMethod = PersonID > 0 ? .PUT : .POST
        JSONReader.JsonAsyncRequest(urlString, data: data, httpMethod: method){ json in
            self.setProperties(json)
            completionHandler(response: 1)
        }
        
    }
    
    func Delete(view:UIView, completionHandler:(response: Int) -> ()){
        Tools.ShowAlertController(view, message: "Are you sure you want to delete student: " + Name + "?"){ response in
            if response == 1{
                var urlString = Tools.WebApiURL(self.webApiControllerName) + "/" + String(self.PersonID)
                JSONReader.JsonAsyncRequest(urlString, data: nil, httpMethod: .DELETE){ json in
                    completionHandler(response: 1)
                }
            }
            else{
                //completionHandler(response: 1)
            }
        }
        
    }
    
    func ReloadData(completionHandler:(response: Int) -> ()){
        var urlString = Tools.WebApiURL(webApiControllerName) + String(PersonID)
        JSONReader.JsonAsyncRequest(urlString, data: nil, httpMethod: .GET){ json in
            self.setProperties(json)
            completionHandler(response: 1)
        }
    }
    
    override func setProperties(json:JSON){
        super.setProperties(json)
        self.PersonID = json["StudentID"].intValue
        self.Name = json["StudentName"].stringValue
        
    }
}
