//
//  OAuthRefreshMessageRequest.swift
//  CoreTraktTV
//
//  Created by Adolfo Vera Blasco on 28/5/18.
//  Copyright © 2018 desappstre {eStudio}. All rights reserved.
//

import Foundation

internal struct OAuthRefreshMessageRequest: OAuthRefreshMessage, Codable
{
    /// OAuthToken
    
    internal var clientSecret: String
    internal var clientID: String
    internal var redirectURI: String
    internal var grantType: GrantType
    
    /// OAuthRefreshMessage
    
    internal var refreshToken: String
    
    internal init(token: String)
    {
        self.refreshToken = token
        
        self.clientSecret = "clientSecret"
        self.clientID = "clientID"
        self.redirectURI = "asdfasdf"
        self.grantType = .refreshToken
    }
    


    /**

    */
    private enum CodingKeys: String, CodingKey
    {
        case refreshToken = "code"
        case clientID = "client_id"
        case clientSecret = "client_secret"
        case redirectURI = "redirect_uri"
        case grantType = "grant_type"
    }
}
