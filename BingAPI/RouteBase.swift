//
//  RouteBase.swift
//  BingAPI
//
//  Created by Ian on 6/12/15.
//  Copyright (c) 2015 Adorkable. All rights reserved.
//

import Foundation

// TODO: Swift 2.0 this should be a protocol
class RouteBase: NSObject {
    internal class var baseUrl : NSURL? {
        get {
            return Bing.baseUrl
        }
    }
    
    static let defaultTimeout : NSTimeInterval = 30
    let timeoutInterval : NSTimeInterval
    
    static let defaultCachePolicy : NSURLRequestCachePolicy = .ReloadRevalidatingCacheData
    let cachePolicy : NSURLRequestCachePolicy
    
    init(timeoutInterval : NSTimeInterval, cachePolicy : NSURLRequestCachePolicy) {
        self.timeoutInterval = timeoutInterval
        self.cachePolicy = cachePolicy
        
        super.init()
    }
    
    // TODO: Swift 2.0 this should be a protocol function declaration
    internal class var path : String {
        get {
            return "Subclass should override"
        }
    }
    
    // TODO: Swift 2.0 this should be a protocol function declaration
    internal var query : String {
        get {
            return "Subclass should override"
        }
    }
    
    // TODO: Swift 2.0 this should be a default implementation function
    internal class func encodeString(string : String) -> String? {
        var result : String?
        
        if let stringEncoded = string.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
        {
            result = "\'" + stringEncoded + "\'"
        }
        
        return result
    }
    
    // TODO: Swift 2.0 this should be a default implementation function
    internal func buildUrl() -> NSURL? {
        
        var combinedPath = self.dynamicType.path
        
        if count(self.query) > 0 {
            
            combinedPath += "?\(self.query)"
        }
        
        return NSURL(string: combinedPath, relativeToURL: self.dynamicType.baseUrl)
    }
    
    // TODO: Swift 2.0 this should be a default implementation function
    func dataTask(configureUrlRequest : ( (urlRequest : NSMutableURLRequest) -> Void)? = nil, completionHandler : (data : NSData?, urlResponse : NSURLResponse?, error : NSError?) -> Void ) -> NSURLSessionDataTask? {
        var result : NSURLSessionDataTask?
        
        if let url = self.buildUrl()
        {
            var urlRequest = NSMutableURLRequest(URL: url, cachePolicy: cachePolicy, timeoutInterval: timeoutInterval)
            urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")

            if configureUrlRequest != nil
            {
                configureUrlRequest!(urlRequest: urlRequest)
            }
            
            let urlSession = NSURLSession.sharedSession()
            result = urlSession.dataTaskWithRequest(urlRequest, completionHandler: completionHandler)
        }
        
        return result
    }
    
    func jsonTask(configureUrlRequest : ( (urlRequest : NSMutableURLRequest) -> Void)? = nil, completionHandler : (jsonObject : AnyObject?, error : NSError?) -> Void) -> NSURLSessionDataTask? {
        
        return self.dataTask(configureUrlRequest: configureUrlRequest, completionHandler: { (data, urlResponse, error) -> Void in
            if data != nil
            {
                var error : NSError?
                var string = NSString(data: data!, encoding: NSUTF8StringEncoding)
                if let jsonObject: AnyObject = NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.allZeros, error: &error)
                {
                    completionHandler(jsonObject: jsonObject, error: nil)
                } else if let errorString = NSString(data: data!, encoding: NSUTF8StringEncoding) as? String
                {
                    completionHandler(jsonObject: nil, error: NSError(domain: errorString, code: 0, userInfo: nil) )
                } else
                {
                    completionHandler(jsonObject: nil, error: NSError(domain: "Unknown error from request", code: 0, userInfo: nil) )
                }
            } else
            {
                completionHandler(jsonObject: nil, error: error)
            }
        })
    }
    
    class func addParameter(inout addTo : String, parameter : String) {
        if count(parameter) > 0 {
            
            if count(addTo) > 0 {
                addTo += "&" + parameter
            } else {
                addTo = parameter
            }
            
        }
    }
}
