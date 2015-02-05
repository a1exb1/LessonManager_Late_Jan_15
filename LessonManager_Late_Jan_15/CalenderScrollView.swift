//
//  CalenderScrollView.swift
//  LessonManager_Late_Jan_15
//
//  Created by Alex Bechmann on 03/02/2015.
//  Copyright (c) 2015 Alex Bechmann. All rights reserved.
//

import UIKit

protocol CalenderScrollViewDelegate{
    func calenderScrollViewDidChangeDate(date: NSDate)
}

class CalenderScrollView: ABInfiniteScrollView, UIWebViewDelegate {
   
    var selectedDate = NSDate()
    var tutor = Tutor()
    var calenderScrollViewDelegate:CalenderScrollViewDelegate? = nil
    var activeWebView = UIWebView()
    
    convenience init(frame:CGRect, tutor:Tutor, date:NSDate){
        self.init(frame: frame)
        self.selectedDate = date
        self.tutor = tutor
    }
    
    override func infiniteScrollViewDidScroll(direction: ABInfiniteScrollDirection) {
        if direction == ABInfiniteScrollDirection.Left{
            selectedDate = selectedDate.dateBySubtractingDays(7)
        }
        else if direction == ABInfiniteScrollDirection.Right{
            selectedDate = selectedDate.dateByAddingDays(7)
        }
    }
    
    override func infiniteScrollViewNewView(frame: CGRect, pageFrame:CGRect) -> UIView {
        var view = UIView(frame:frame)
        
        var subView = UIView(frame: pageFrame)
        var webView = UIWebView(frame: pageFrame)
        
        let requestURL = NSURL(string: URL())
        let request = NSURLRequest(URL: requestURL!)
        webView.loadRequest(request)
        webView.delegate = self
        
        subView.addSubview(webView)
        view.addSubview(subView)
        
        self.activeWebView = webView
        calenderScrollViewDelegate?.calenderScrollViewDidChangeDate(selectedDate)
        return view
    }
    
    func URL() -> String{
        var startDate = selectedDate.dateAtStartOfWeek()
        var endDate = selectedDate.dateAtEndOfWeek()
        return Tools.Domain() + "/sections/frames/calender_items_week.aspx?tutorid=\(tutor.PersonID)&from=\(Tools.StringFromDate(startDate, format: LMDateFormat.Date.rawValue))&to=\(Tools.StringFromDate(endDate, format: LMDateFormat.Date.rawValue))&auth=0CCAAC112&clientid=\(session.client.ClientID)"
    }
    
    func webViewDidStartLoad(webView: UIWebView) {
        if webView == self.activeWebView{
            Tools.AddLoaderToView(webView.superview!)
            webView.hidden = true
        }
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        if webView == self.activeWebView{
            Tools.HideLoaderFromView(webView.superview!)
            webView.hidden = false
        }
    }
    
}
