//
//  GrantType.swift
//  CoreTraktTV
//
//  Created by Adolfo Vera Blasco on 28/5/18.
//  Copyright © 2018 desappstre {eStudio}. All rights reserved.
//

import Foundation

internal enum GrantType: String, Codable
{
    /// Using to obtain access token
    case authorizationCode = "authorization_code"
    /// Using for refresh
    case refreshToken = "refresh_token"
}
