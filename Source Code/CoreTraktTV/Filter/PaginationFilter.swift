//
//  PaginationFilter.swift
//  CoreTraktTV
//
//  Created by Adolfo Vera Blasco on 28/5/18.
//  Copyright © 2018 desappstre {eStudio}. All rights reserved.
//

import Foundation

public enum PaginationFilter
{
    case limit(resultCount: Int)

    case page(page: Int)
}

extension PaginationFilter: FilterValue
{
    ///
    public var queryItem: URLQueryItem
    {
        var key: String
        var value: String
        
        switch self
        {
            case .limit(let resultCount):
                key = "limit"
                value = "\(resultCount)"
            
            case .page(let page):
                key = "page"
                value = "\(page)"
        }

        return URLQueryItem(name: key, value: value)
    }
}
