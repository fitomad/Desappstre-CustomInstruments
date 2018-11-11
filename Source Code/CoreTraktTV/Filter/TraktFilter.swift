//
//  TraktFilter.swift
//  CoreTraktTV
//
//  Created by Adolfo Vera Blasco on 28/5/18.
//  Copyright © 2018 desappstre {eStudio}. All rights reserved.
//

import Foundation


/**
 
 */
public enum TraktFilter
{
    case query(term: String)
    
    case year(year: Int)
    
    case genres(genres: [String])
    
    case languages(languages: [String])
    
    case countries(countries: [String])
    
    case runtime(durationRangeStart: Int, durationRangeEnd: Int)
    
    case ratings(ratingRangeStart: Int, ratingRangeEnd: Int)
}

//
// MARK: - FilterValue Protocol
//

extension TraktFilter: FilterValue
{
    public var queryItem: URLQueryItem
    {
        var key: String
        var value: String
        
        switch self
        {
        case .query(let term):
            key = "query"
            value = term
            
        case .year(let year):
            key = "year"
            value = "\(year)"
            
        case .genres(let genres):
            key = "genres"
            value = genres.joined(separator: ",")
            
        case .languages(let languages):
            key = "languages"
            value = languages.joined(separator: ",")
            
        case .countries(let countries):
            key = "countries"
            value = countries.joined(separator: ",")
            
        case .runtime(let durationRangeStart, let durationRangeEnd):
            key = "runtime"
            value = "\(durationRangeStart)-\(durationRangeEnd)"
            
        case .ratings(let ratingRangeStart, let ratingRangeEnd):
            key = "ratings"
            value = "\(ratingRangeStart)-\(ratingRangeEnd)"
        }
        
        return URLQueryItem(name: key, value: value)
    }
}
