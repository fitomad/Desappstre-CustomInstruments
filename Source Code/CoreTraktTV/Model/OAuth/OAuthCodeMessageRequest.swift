//
//  OAuthCodeMessageRequest.swift
//  CoreTraktTV
//
//  Created by Adolfo Vera Blasco on 28/5/18.
//  Copyright © 2018 desappstre {eStudio}. All rights reserved.
//

import Foundation

internal struct OAuthCodeMessageRequest: OAuthCodeMessage, Codable
{
    /// OAuthToken
    
    public private(set) var clientSecret: String
    public private(set) var clientID: String
    public private(set) var redirectURI: String
    public var grantType: GrantType
    
    /// OAuthExchangeCodeToken
    
    public private(set) var code: String
    
    internal init(code: String)
    {
        self.code = code
        
        self.clientSecret = "clientSecret"
        self.clientID = "clientID"
        self.redirectURI = "asdfasdf"
        self.grantType = .authorizationCode
    }

    /**

    */
    private enum CodingKeys: String, CodingKey
    {
        case code = "code"
        case clientID = "client_id"
        case clientSecret = "client_secret"
        case redirectURI = "redirect_uri"
        case grantType = "grant_type"
    }
}
