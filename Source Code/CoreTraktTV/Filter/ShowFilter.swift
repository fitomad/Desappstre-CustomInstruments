//
//  ShowFilter.swift
//  CoreTraktTV
//
//  Created by Adolfo Vera Blasco on 28/5/18.
//  Copyright © 2018 desappstre {eStudio}. All rights reserved.
//

import Foundation


public enum ShowFilter
{
    ///
    case certifications(certifications: [ShowCertification])
    ///
    case networks(networks: [String])
    ///
    case status(status: [ShowStatus])
}

//
// MARK: - FilterValue Protocol
//

extension ShowFilter: FilterValue
{
    public var queryItem: URLQueryItem
    {
        var key: String
        var value: String
        
        switch self
        {
        case .certifications(let certifications):
            key = "certifications"
            value = certifications.map({ $0.rawValue }).joined(separator: ",")
            
        case . networks(let networks):
            key = "certifications"
            value = networks.joined(separator: ",")
            
        case .status(let status):
            key = "certifications"
            value = status.map({ $0.rawValue }).joined(separator: ",")
        }
        
        return URLQueryItem(name: key, value: value)
    }
}
