//
//  TraktTVClient+OAuth.swift
//  CoreTraktTV
//
//  Created by Adolfo Vera Blasco on 28/5/18.
//  Copyright © 2018 desappstre {eStudio}. All rights reserved.
//

import Foundation

/**

*/
public typealias TraktOAuthCompletionHandler = (_ authenticated: Bool, _ error: TraktError?) -> Void

//
// OAuth Operations
//

extension TraktTVClient
{  
    /**
        Returns the *login for authorition* URL
        in order to gain access for your app

        You should open this URL in a `SFSafariViewController`
        and register a *Custom URL Scheme* in your `Info.plist`

        - Parameter clienteID: Your app clientID
        - Returns: The login URL in Trakt.TV
    */
    public func authorizationURL() -> URL?
    {
        var components = URLComponents(string: "https://api.trakt.tv/oauth/authorize")

        let queryItems: [URLQueryItem] = [
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "client_id", value: self.clientID),
            URLQueryItem(name: "redirect_uri", value: self.redirecURL.absoluteString),
            URLQueryItem(name: "state", value: " ")
        ]

        components?.queryItems = queryItems

        return components?.url
    }

    /**

    */
    public func exchange(code: String, handler: @escaping TraktOAuthCompletionHandler) -> Void
    {
        guard let exchangeURL = URL(string: "https://api.trakt.tv/oauth/token") else
        {
            return
        }

        let message = OAuthCodeMessageRequest(code: code)

        guard let bodyData = try? self.encoder.encode(message) else
        {
            return
        }

        var request = URLRequest(url: exchangeURL)
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = bodyData

        self.processTokenRequest(request, handler: handler)
    }

    /**

    */
    public func exchange(refreshToken: String, handler: @escaping TraktOAuthCompletionHandler) -> Void
    {
        guard let exchangeURL = URL(string: "https://api.trakt.tv/oauth/token") else
        {
            return
        }

        let message = OAuthRefreshMessageRequest(token: refreshToken)

        guard let bodyData = try? self.encoder.encode(message) else
        {
            return
        }

        var request = URLRequest(url: exchangeURL)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        request.httpBody = bodyData

        self.processTokenRequest(request, handler: handler)
    }

    /**

    */
    private func processTokenRequest(_ request: URLRequest, handler: @escaping TraktOAuthCompletionHandler) -> Void
    {
        self.processRequest(request) { (result: HttpResult) -> Void in
            switch result
            {
                case .success(let data, _):
                    if let tokenResponse = try? self.decoder.decode(OAuthTokenResponse.self, from: data)
                    {
                        self.accessToken = tokenResponse.accessToken
                        self.refreshToken = tokenResponse.refreshToken

                        handler(true, nil)
                    }
                    else
                    {
                        handler(false, TraktError.preconditionFailed)
                    }

                case .requestError(let code, let message):
                    #if targetEnvironment(simulator)
                        print(message)
                    #endif

                    let error = TraktError(httpCode: code)
                    handler(false, error)

                case .connectionError:
                    handler(false, TraktError.serverIsDown)
            }
        }
    }

    /**

    */
    public func revoke(accessToken: String) -> Void
    {
        guard let exchangeURL = URL(string: "https://api.trakt.tv/oauth/revoke") else
        {
            return
        }

        var request = URLRequest(url: exchangeURL)
        request.httpMethod = "POST"

        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer [access_token]", forHTTPHeaderField: "Authorization")
        request.addValue("2", forHTTPHeaderField: "trakt-api-version")
        request.addValue("[client_id]", forHTTPHeaderField: "trakt-api-key")

        request.httpBody = "token=\(accessToken)".data(using: .utf8)

    }
}
