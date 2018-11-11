//
//  TraktTVClient
//  CoreTraktTV
//
//  Created by Adolfo Vera Blasco on 28/5/18.
//  Copyright © 2018 desappstre {eStudio}. All rights reserved.
//

import Foundation

public typealias TraktPaginatedCompletionHandler<T> = (_ results: [T]?, _ pagination: Pagination?, _ error: TraktError?) -> (Void)

public typealias TraktCompletionHandler<T> = (_ result: [T]?, _ error: TraktError?) -> (Void)

public typealias TraktPostCompletionHandler = (_ validOperation: Bool, _ error: TraktError?) -> (Void)

///
/// All API request will be *returned* here
///

internal typealias HttpRequestCompletionHandler = (_ result: HttpResult) -> (Void)


public class TraktTVClient
{
    ///
    public static let shared = TraktTVClient()

    internal let clientID: String
    internal let clientSecret: String
    internal let redirecURL: URL

    internal var accessToken: String?
    internal var refreshToken: String?

    internal let encoder: JSONEncoder
    internal let decoder: JSONDecoder
    
    /// HTTP session ...
    private var httpSession: URLSession!
    /// ...and his configuración
    private var httpConfiguration: URLSessionConfiguration!

    /**

    */
    private init()
    {
        self.clientID = "36a95812e853a7a48392c548f02985fa00e4a3ce7b7ffe9e902af167d8e40871"
        self.clientSecret = "1887c1fc011f0aa511504b4e9ab1acc8e689bfbb29e6254bad1ecea660d63799"
        self.redirecURL = URL(string: "serialer://oauth")!

        self.encoder = JSONEncoder()
        self.encoder.outputFormatting = .prettyPrinted
        
        self.decoder = JSONDecoder()
        self.decoder.dateDecodingStrategy = .iso8601
        
        self.httpConfiguration = URLSessionConfiguration.default
        self.httpConfiguration.httpMaximumConnectionsPerHost = 10
        
        let http_queue: OperationQueue = OperationQueue()
        http_queue.maxConcurrentOperationCount = 10
        
        self.httpSession = URLSession(configuration:self.httpConfiguration,
                                      delegate:nil,
                                      delegateQueue:http_queue)
    }

    //
    // MARK: - HTTP Methods
    //

    /**

    */
    internal func makeURLRequest(string uri: String, withFilters filters: [FilterValue]? = nil, paginationOptions pagination: [FilterValue]? = nil, authenticationRequired: Bool = false) -> URLRequest?
    {
        guard let url = URL(string: uri) else
        {
            return nil
        }

        var request: URLRequest = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData)

        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("2", forHTTPHeaderField: "trakt-api-version")
        request.addValue(self.clientID, forHTTPHeaderField: "trakt-api-key")

        if let accessToken = self.accessToken, authenticationRequired
        {
            request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        }

        return request
    }
    
    /**
 
    */
    private func recoverPaginationData(fromResponse response: HTTPURLResponse) -> Pagination?
    {
        guard let currentPageHeader = response.allHeaderFields["x-pagination-page"] as? String,
              let itemsPerPageHeader = response.allHeaderFields["x-pagination-limit"] as? String,
              let totalPagesHeader = response.allHeaderFields["x-pagination-page-count"] as? String,
              let totalItemsHeader = response.allHeaderFields["x-pagination-item-count"] as? String
        else
        {
            return nil
        }
        
        guard let currentPage = Int(currentPageHeader),
              let itemsPerPage = Int(itemsPerPageHeader),
              let totalPages = Int(totalPagesHeader),
              let totalItems = Int(totalItemsHeader)
        else
        {
            return nil
        }
        
        return Pagination(currentPage: currentPage, itemsPageCount: itemsPerPage, pageCount: totalPages, itemsCount: totalItems)
    }

    /**
        URL request operation
        - Parameters:
            - request: `URLRequest` requested
            - completionHandler: HTTP operation result
    */
    internal func processRequest(_ request: URLRequest, httpHandler: @escaping HttpRequestCompletionHandler) -> Void
    {
        let data_task: URLSessionDataTask = self.httpSession.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            if let error = error
            {
                #if targetEnvironment(simulator)
                    print(error.localizedDescription)
                #endif
                
                httpHandler(HttpResult.connectionError)
                return
            }

            guard let data = data, let http_response = response as? HTTPURLResponse else
            {
                httpHandler(HttpResult.connectionError)
                return
            }

            switch http_response.statusCode
            {
                case 200:
                    let pagination = self.recoverPaginationData(fromResponse: http_response)
                    httpHandler(HttpResult.success(data: data, pagination: pagination))
                    
                default:
                    let code: Int = http_response.statusCode
                    let message: String = HTTPURLResponse.localizedString(forStatusCode: code)

                    httpHandler(HttpResult.requestError(code: code, message: message))
            }
        })

        data_task.resume()
    }
}
