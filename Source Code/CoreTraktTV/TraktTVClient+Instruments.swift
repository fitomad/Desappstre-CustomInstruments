//
//  TraktTVClient+Instruments.swift
//  CoreTraktTV
//
//  Created by Adolfo Vera Blasco on 05/11/2018.
//  Copyright © 2018 desappstre {estudio}. All rights reserved.
//

import os
import Foundation

extension TraktTVClient
{
    ///
    internal static let traktLog = OSLog(subsystem: "com.desappstre.CoreTraktTV./instruments", category: "TV Shows")
    
    ///
    internal var traktSignpost: OSSignpostID
    {
        return OSSignpostID(log: TraktTVClient.traktLog, object: self)
    }
}
