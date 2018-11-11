//
//  SearchKind.swift
//  CoreTraktTV
//
//  Created by Adolfo Vera Blasco on 05/11/2018.
//  Copyright © 2018 desappstre {estudio}. All rights reserved.
//

import Foundation

public enum SearchKind: String, Codable
{
    case movie
    case tvShow = "show"
    case episode
    case person
    case list
}
