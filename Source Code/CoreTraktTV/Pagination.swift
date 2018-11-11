//
//  Pagination.swift
//  CoreTraktTV
//
//  Created by Adolfo Vera Blasco on 28/5/18.
//  Copyright © 2018 desappstre {eStudio}. All rights reserved.
//

import Foundation

public struct Pagination
{
    /// Current page.
    public internal(set) var currentPage: Int
    /// Items per page.
    public internal(set) var itemsPageCount: Int
    /// Total number of pages.
    public internal(set) var pageCount: Int
    /// Total number of items.
    public internal(set) var itemsCount: Int

    /**

    */
    public func nextPage() -> [PaginationFilter]?
    {
        guard self.currentPage < self.pageCount else
        {
            return nil
        }
        
        let nextPage = self.currentPage + 1
        
        let filters = [
            PaginationFilter.limit(resultCount: self.itemsPageCount),
            PaginationFilter.page(page: nextPage)
        ]
        
        return filters
    }

    /**

    */
    public func previousPage() -> [PaginationFilter]?
    {
        guard self.currentPage > 1 else 
        {
            return nil
        }
        
        let previousPage = self.currentPage - 1
        
        let filters = [
            PaginationFilter.limit(resultCount: self.itemsPageCount),
            PaginationFilter.page(page: previousPage)
        ]
        
        return filters
    }
}
