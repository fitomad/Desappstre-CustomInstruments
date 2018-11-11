//
//  TraktTVClient+Sync.swift
//  CoreTraktTV
//
//  Created by Adolfo Vera Blasco on 28/5/18.
//  Copyright © 2018 desappstre {eStudio}. All rights reserved.
//

import Foundation

//
// Shows Operations
//

extension TraktTVClient
{
    /**

    */
    public func appendToWatchlist(_ show: Show, handler: @escaping TraktPostCompletionHandler) -> Void
    {
        let watchlistURL = "https://api.trakt.tv/sync/watchlist"

        guard var request = self.makeURLRequest(string: watchlistURL, authenticationRequired: true) else
        {
            return
        }

        let postData = PostTrakt(shows: [ show ])

        request.httpMethod = "POST"
        request.httpBody = try? self.encoder.encode(postData)

        self.processRequest(request) { (result: HttpResult) -> Void in
            switch result
            {
            case .success(let data, _):
                    handler(true, nil)

                case .requestError(let code, let message):
                    print(message)
                    if let error = TraktError(rawValue: code)
                    {
                        handler(false, error)
                    }
                    else
                    {
                        handler(false, TraktError.badRequest)
                    }
                    
                case .connectionError:
                    handler(false, TraktError.serverIsDown)
            }
        }
    }
}
