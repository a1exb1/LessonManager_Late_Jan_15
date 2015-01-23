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
    var lesson:Lesson? = nil
    
    func setup(lesson:Lesson){
        self.lesson = lesson
        self.TimeLabel.text = Tools.StringFromDate(lesson.Date, format: "dd/MM/yyyy HH:mm")
    }
}
