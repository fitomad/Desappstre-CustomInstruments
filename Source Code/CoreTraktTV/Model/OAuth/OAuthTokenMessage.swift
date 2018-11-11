//
//  OAuthTokenMessage.swift
//  CoreTraktTV
//
//  Created by Adolfo Vera Blasco on 28/5/18.
//  Copyright © 2018 desappstre {eStudio}. All rights reserved.
//

import Foundation

internal protocol OAuthTokenMessage
{
    var clientSecret: String { get }
    var clientID: String { get }
    var redirectURI: String { get } 
    var grantType: GrantType { get }
}
