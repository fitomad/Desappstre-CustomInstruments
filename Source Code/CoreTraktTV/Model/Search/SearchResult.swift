//
//  SearchResult.swift
//  CoreTraktTV
//
//  Created by Adolfo Vera Blasco on 05/11/2018.
//  Copyright © 2018 desappstre {estudio}. All rights reserved.
//

import Foundation

public struct SearchResult: Codable
{
    ///
    public private(set) var kind: SearchKind
    ///
    public private(set) var score: Double
    ///
    public private(set) var show: Show
    
    /**
 
    */
    private enum CodingKeys: String, CodingKey
    {
        case kind = "type"
        case score
        case show
    }
}
