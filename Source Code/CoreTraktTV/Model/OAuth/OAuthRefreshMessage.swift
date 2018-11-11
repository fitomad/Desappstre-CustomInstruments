//
//  OAuthRefreshMessage.swift
//  CoreTraktTV
//
//  Created by Adolfo Vera Blasco on 28/5/18.
//  Copyright © 2018 desappstre {eStudio}. All rights reserved.
//

import Foundation

protocol OAuthRefreshMessage: OAuthTokenMessage
{
    var refreshToken: String { get } 
}
