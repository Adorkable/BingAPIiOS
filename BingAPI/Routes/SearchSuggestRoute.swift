//
//  SearchSuggestRoute.swift
//  BingAPI
//
//  Created by Ian on 6/12/15.
//  Copyright (c) 2015 Adorkable. All rights reserved.
//

import AdorkableAPIBase

public class SearchSuggestRoute: RouteBase<Bing> {
    public typealias ResultsHandler = (SuccessResult<[String]>) -> Void
    
    override public var baseUrl : NSURL? {
        return NSURL(string: "http://api.bing.com")
    }
    

    override public static var httpMethod : String {
        return "GET"
    }

    override public var path : String {
        get {
            return "/osjson.aspx"
        }
    }
    
    var searchText : String
    
    init(searchText : String, timeoutInterval : NSTimeInterval = Bing.timeoutInterval, cachePolicy : NSURLRequestCachePolicy = Bing.cachePolicy) {
        self.searchText = searchText
        
        super.init(timeoutInterval: timeoutInterval, cachePolicy: cachePolicy)
    }
    
    override public var query : String {
        get {
            var result = ""
            
            RouteBase<Bing>.addParameter(&result, name: "query", value: self.searchText)
            
            return result
        }
    }
    
    func start(configureUrlRequest : ( (urlRequest : NSMutableURLRequest) -> Void)?,
                resultsHandler : ResultsHandler) {
        
        let task = self.jsonTask(configureUrlRequest) { (result) -> Void in
            
            switch result {
            case .Success(let jsonObject):
                if let jsonArray = jsonObject as? NSArray
                {
                    let results = self.dynamicType.parseResults(jsonArray)
                    resultsHandler(results)
                } else
                {
                    let error = NSError(domain: "In results expected Array, unexpected format " + _stdlib_getDemangledTypeName(jsonObject), code: 0, userInfo: nil)
                    resultsHandler(.Failure(error))
                }
                break
                
            case .Failure(let error):
                resultsHandler(.Failure(error))
            }
        }
        
        if task != nil
        {
            task!.resume()
        } else
        {
            let error = NSError(domain: "Unable to create SearchRoute task", code: 0, userInfo: nil)
            resultsHandler(.Failure(error))
        }
    }
    
    internal class func parseResults(jsonResponse : NSArray) -> SuccessResult<[String]> {
        var result = Array<String>()
        
        for baseEntry in jsonResponse
        {
            if let suggestions = baseEntry as? NSArray
            {
                for suggestionObject in suggestions
                {
                    if let suggestion = suggestionObject as? String
                    {
                        result.append(suggestion)
                    }
                }
            }
        }

        return .Success(result)
    }
}
