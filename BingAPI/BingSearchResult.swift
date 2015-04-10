//
//  BingSearchResult.swift
//  BingAPI
//
//  Created by Ian on 4/3/15.
//  Copyright (c) 2015 Adorkable. All rights reserved.
//

import Foundation

public class BingSearchResult: NSObject {
    public let resultDescription : String
    public let id : String
    public let title : String
    public let url : String
    public var urlValue : NSURL? {
        get {
            return NSURL(string: self.url)
        }
    }
    public let metaData : NSDictionary
    
    init(resultDescription : String, id : String, title : String, url : String, metaData : NSDictionary) {
        self.resultDescription = resultDescription
        self.id = id
        self.title = title
        self.url = url
        self.metaData = metaData
        
        super.init()
    }
    
    // TODO: should be failable init
    convenience init(dictionary : NSDictionary) {
        self.init(resultDescription: dictionary["Description"] as! String,
                                 id: dictionary["ID"] as! String,
                              title: dictionary["Title"] as! String,
                                url: dictionary["Url"] as! String,
                           metaData: dictionary["__metadata"] as! NSDictionary)
    }
}
