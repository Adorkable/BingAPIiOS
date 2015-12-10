//
//  BingSearchResult.swift
//  BingAPI
//
//  Created by Ian on 4/3/15.
//  Copyright (c) 2015 Adorkable. All rights reserved.
//

import Foundation

import AdorkableAPIBase

/**
*  Bing Search Results
*/
public class BingSearchResult: RouteBase<Bing>, CustomDebugStringConvertible {
    /// id
    public let id : String
    /// description
    public let resultDescription : String
    /// title
    public let title : String
    /// Url string
    public let urlString : String
    /// Url as NSURL
    public var url : NSURL? {
        get {
            return NSURL(string: self.urlString)
        }
    }
    /// meta data
    public let metaData : NSDictionary
    
    init(resultDescription : String, id : String, title : String, urlString : String, metaData : NSDictionary) {
        self.resultDescription = resultDescription
        self.id = id
        self.title = title
        self.urlString = urlString
        self.metaData = metaData
        
        super.init()
    }
    
    init?(dictionary : NSDictionary) {
        var initFailed = false
        
        if let id = dictionary["ID"] as? String
        {
            self.id = id
        } else
        {
            self.id = ""
            initFailed = true
        }
        
        if let description = dictionary["Description"] as? String
        {
            self.resultDescription = description
        } else
        {
            self.resultDescription = ""
            initFailed = true
        }
        
        if let title = dictionary["Title"] as? String
        {
            self.title = title
        } else
        {
            self.title = ""
            initFailed = true
        }
        
        if let urlString = dictionary["Url"] as? String
        {
            self.urlString = urlString
        } else
        {
            self.urlString = ""
            initFailed = true
        }
        
        if let metaData = dictionary["__metadata"] as? NSDictionary
        {
            self.metaData = metaData
        } else
        {
            self.metaData = NSDictionary()
            initFailed = true
        }

        super.init()
        
        if initFailed
        {
            return nil
        }
    }
    
    /// debug description
    override public var debugDescription: String {
        get {
            var result = super.debugDescription + "\n"
            result += "ID: \(self.id)\n"
            result += "Title: \(self.title)\n"
            result += "Description: \(self.resultDescription)\n"
            result += "URL: \(self.url)\n"
            result += "Metadata: \(self.metaData)"
            return result
        }
    }
}
