//
//  PostTrakt.swift
//  CoreTraktTV
//
//  Created by Adolfo Vera Blasco on 29/5/18.
//  Copyright © 2018 desappstre {eStudio}. All rights reserved.
//

import Foundation

public struct PostTrakt: Codable
{
    /// Shows que vamos a actualizar
    public private(set) var shows: [Show]?

    /**

    */
    private enum CodingKeys: String, CodingKey
    {
        case shows
    }
}