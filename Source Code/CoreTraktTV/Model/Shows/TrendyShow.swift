//
//  TrendyShow.swift
//  CoreTraktTV
//
//  Created by Adolfo Vera Blasco on 29/5/18.
//  Copyright © 2018 desappstre {eStudio}. All rights reserved.
//

import Foundation

public struct TrendyShow: Codable
{
    public private(set) var watchers: Int
    public private(set) var show: Show

    /**

    */
    private enum CodingKeys: String, CodingKey
    {
        case watchers
        case show
    }
}