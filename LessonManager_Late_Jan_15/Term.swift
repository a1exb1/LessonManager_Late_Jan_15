//
//  Term.swift
//  LessonManager_Late_Jan_15
//
//  Created by Alex Bechmann on 26/01/2015.
//  Copyright (c) 2015 Alex Bechmann. All rights reserved.
//

import UIKit

class Term: NSObject {
    var webApiControllerName = "Terms"
    
    var TermID:Int = 0
    var TermName:String = ""
    var StartDate:NSDate = NSDate()
    var EndDate:NSDate = NSDate().dateByAddingMonths(3)
    
    init(json:JSON){
        super.init()
        setProperties(json)
    }
    
    override init(){
        super.init()
    }
    
    func setProperties(json:JSON){
        self.TermID = json["TermID"].intValue
        self.TermName = json["TermName"].stringValue
        self.StartDate = NSDate.dateFromISOString(json["StartDate"].stringValue + "+00:00")
        self.EndDate = NSDate.dateFromISOString(json["EndDate"].stringValue + "+00:00")
    }
    
    func Save(completionHandler:(response: Int) -> ()){
        var urlString = Tools.WebApiURL(webApiControllerName)
        var data:Dictionary<String, AnyObject> = [
            "TermID": TermID,
            "TermName" : TermName,
            "StartDate": NSDate.ISOStringFromDate(StartDate),
            "EndDate": NSDate.ISOStringFromDate(EndDate)
        ]
        println(data)
        
        var method:HttpMethod = TermID > 0 ? .PUT : .POST
        JSONReader.JsonAsyncRequest(urlString, data: data, httpMethod: method){ json in
            //println(json)
            //self.setProperties(json)
            
            completionHandler(response: 1)
        }
    }
    
    func Delete(completionHandler:(response: Int) -> ()){
        Tools.ShowAlertController("Are you sure you want to delete term: " + TermName + "?"){ response in
            if response == 1{
                var urlString = Tools.WebApiURL(self.webApiControllerName) + "/" + String(self.TermID)
                JSONReader.JsonAsyncRequest(urlString, data: nil, httpMethod: .DELETE){ json in
                    completionHandler(response: 1)
                }
            }
        }
    }

}
