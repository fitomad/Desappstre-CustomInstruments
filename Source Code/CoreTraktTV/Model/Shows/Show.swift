//
//  Show.swift
//  CoreTraktTV
//
//  Created by Adolfo Vera Blasco on 29/5/18.
//  Copyright © 2018 desappstre {eStudio}. All rights reserved.
//

import Foundation

public struct Show: Codable
{
    public private(set) var title: String
    public private(set) var year: Int?
    public private(set) var identifiers: Identifiers

    /**

    */
    private enum CodingKeys: String, CodingKey
    {
        case title
        case year
        case identifiers = "ids"
    }
}
