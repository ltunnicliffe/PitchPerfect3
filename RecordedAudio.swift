//
//  RecordedAudio.swift
//  Voice Changer
//
//  Created by Luke on 2015/06/08.
//  Copyright (c) 2015年 Luke Tunnicliffe. All rights reserved.
//

import Foundation

class RecordedAudio: NSObject {

    var title:String!
    var filePathUrl: NSURL!
    
    //custom initializer for Swift
   
    init(title : String, filePathUrl : NSURL) {
        self.title = title
        self.filePathUrl = filePathUrl
    }
   
}
