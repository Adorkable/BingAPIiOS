//
//  SearchRoute.swift
//  BingAPI
//
//  Created by Ian on 6/12/15.
//  Copyright (c) 2015 Adorkable. All rights reserved.
//

import Foundation

import AdorkableAPIBase

public class SearchRoute: RouteBase<Bing> {
    
    public typealias ResultsHandler = (SuccessResult<[BingSearchResult]>) -> Void

    override public static var httpMethod : String {
        return "GET"
    }
    
    override public var path : String {
        return "/Bing/Search/Web"
    }
    
    var searchText : String
    
    init(searchText : String, timeoutInterval : NSTimeInterval = Bing.timeoutInterval, cachePolicy : NSURLRequestCachePolicy = Bing.cachePolicy) {
        self.searchText = searchText
        
        super.init(timeoutInterval: timeoutInterval, cachePolicy: cachePolicy)
    }
    
    override public var query : String {
        get {
            var result = "$format=json"
            
            RouteBase<Bing>.addParameter(&result, name: "Query", value: "\'\(self.searchText)\'")
            
            return result
        }
    }
    
    func start(configureUrlRequest : (urlRequest : NSMutableURLRequest) -> Void, resultsHandler : ResultsHandler) {
        
        let task = self.jsonTask(configureUrlRequest) { (result) -> Void in
            
            switch result {
            case .Success(let jsonObject):
                
                if let jsonDictionary = jsonObject as? NSDictionary
                {
                    let parseResults = self.dynamicType.parseResults(jsonDictionary)
                    resultsHandler(parseResults)
                } else
                {
                    let error = NSError(domain: "In results expected Dictionary, unexpected format " + _stdlib_getDemangledTypeName(jsonObject), code: 0, userInfo: nil)
                    resultsHandler(.Failure(error))
                }
                break
                
            case .Failure(let error):
                resultsHandler(.Failure(error))
                break
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
    
    internal class func parseResults(jsonResponse : NSDictionary) -> SuccessResult<[BingSearchResult]> {
        var result = Array<BingSearchResult>()
        
        if let d = jsonResponse["d"] as? NSDictionary
        {
            if let searchResults = d["results"] as? NSArray
            {
                for searchResultObject in searchResults
                {
                    if let searchResult = searchResultObject as? NSDictionary
                    {
                        if let searchResultObject = BingSearchResult(dictionary: searchResult)
                        {
                            result.append(searchResultObject)
                        } else
                        {
                            let error = NSError(domain: "Unable to parse search result \(searchResult) into BingSearchResult object", code: 0, userInfo: nil)
                            return .Failure(error)
                        }
                    }
                }
            }
        }
        
        return .Success(result)
    }
}
