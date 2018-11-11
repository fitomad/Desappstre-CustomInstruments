//
//  TraktTVClient+Show.swift
//  CoreTraktTV
//
//  Created by Adolfo Vera Blasco on 28/5/18.
//  Copyright © 2018 desappstre {eStudio}. All rights reserved.
//

import os
import Foundation

//
// Shows Operations
//

extension TraktTVClient
{
    /**

    */
    public func trendingShows(filteringBy filters: [FilterValue]? = nil, pagination: [FilterValue]? = nil, handler: @escaping TraktPaginatedCompletionHandler<TrendyShow>) -> Void
    {
        os_log(.debug, log: TraktTVClient.traktLog, "Operación Trending Shows.")

        let signpost = self.traktSignpost
        os_signpost(.begin, log: TraktTVClient.traktLog, name: "Trending Shows", signpostID: signpost, "Recuperando Trending Shows.")
        
        let trendingURL = "https://api.trakt.tv/shows/trending"

        guard let request = self.makeURLRequest(string: trendingURL, withFilters: filters, paginationOptions: pagination) else
        {
            os_signpost(.end, log: TraktTVClient.traktLog, name: "Trending Shows", signpostID: signpost, "URL mal formada %@", trendingURL)
            
            
            handler(nil, nil, .preconditionFailed)
            return 
        }

        self.processRequest(request) { (result: HttpResult) -> Void in
            switch result
            {
                case .success(let data, let pagination):
                    os_log(.info, log: TraktTVClient.traktLog, "Trending Shows. Descargados %{iec-bytes}d bytes", data.count)
            
                    if let shows = try? self.decoder.decode([TrendyShow].self, from: data)
                    {
                        os_log(.info, log: TraktTVClient.traktLog, "Recibidos %d trending shows", shows.count)
                        os_signpost(.end, log: TraktTVClient.traktLog, name: "Trending Shows", signpostID: signpost, "Descargados %{public}@ bytes. Disponibles %{public}@ shows", "\(data.count)", "\(shows.count)")
                        
                        handler(shows, pagination, nil)
                    }
                case .requestError(let code, let message):
                    os_log(.error, "Se ha producido un error al recibir los Trending Shows. Código %d, %@", code, message)                
                    os_signpost(.end, log: TraktTVClient.traktLog, name: "Trending Shows", signpostID: signpost, "Error en la petición. Código %d - %@", code, message)
                    
                    let error = TraktError(httpCode: code)
                    handler(nil, nil, error)

                case .connectionError:
                    os_log(.error, "Error de conexión.")
                    os_signpost(.end, log: TraktTVClient.traktLog, name: "Trending Shows", signpostID: signpost, "Error de conexión")
                    
                    handler(nil, nil, TraktError.serverIsDown)
            }
        }
    }

    /**

    */
    public func popularShows(filteringBy filters: [FilterValue]? = nil, pagination: [FilterValue]? = nil, handler: @escaping TraktPaginatedCompletionHandler<Show>) -> Void
    {
        os_log(.debug, log: TraktTVClient.traktLog, "Operación Popular Shows")
        
        let signpost = self.traktSignpost
        os_signpost(.begin, log: TraktTVClient.traktLog, name: "Popular Shows", signpostID: signpost, "Recuperamos los Popular Shows.")
        
        let popularURL = "https://api.trakt.tv/shows/popular"
        
        guard let request = self.makeURLRequest(string: popularURL, withFilters: filters, paginationOptions: pagination) else
        {
            os_log(.error, "URL mal formada - %@", popularURL)
            os_signpost(.end, log: TraktTVClient.traktLog, name: "Popular Shows", signpostID: signpost, "URL mal formada.")
            
            handler(nil, nil, .preconditionFailed)
            return 
        }

        self.processRequest(request) { (result: HttpResult) -> Void in
            switch result
            {
            case .success(let data, let pagination):
                os_log(.info, log: TraktTVClient.traktLog, "Descargados %{iec-bytes}d bytes", data.count)
                os_signpost(.end, log: TraktTVClient.traktLog, name: "Popular Shows", signpostID: signpost, "Descargados %{iec-bytes}d bytes", data.count)

                if let shows = try? self.decoder.decode([Show].self, from: data)
                {
                    os_log(.info, log: TraktTVClient.traktLog, "Recibidos %d popular shows", shows.count)

                    handler(shows, pagination, nil)
                }                
            
            case .requestError(let code, let message):
                os_log(.error, "Se ha producido un error al recibir los Popular Shows. Código %d, %@", code, message)                
                os_signpost(.end, log: TraktTVClient.traktLog, name: "Popular Shows", signpostID: signpost, "Se ha producido un error al recibir los Popular Shows. Código %d, %@", code, message)
            
                let error = TraktError(httpCode: code)
                handler(nil, nil, error)

            case .connectionError:
                os_log(.error, "Error de conexión.")
                os_signpost(.end, log: TraktTVClient.traktLog, name: "Popular Shows", signpostID: signpost, "Error de conexión")
            
                handler(nil, nil, TraktError.serverIsDown)
            }
        }
    }

    /**

    */
    public func searchShow(_ named: String, filteringBy filters: [FilterValue]? = nil, pagination: [FilterValue]? = nil, handler: @escaping TraktPaginatedCompletionHandler<SearchResult>) -> Void
    {
        os_log(.debug, "Buscando shows con el nombre %{public}@", named)
        
        let signpost = self.traktSignpost
        os_signpost(.begin,
                    log: TraktTVClient.traktLog,
                    name: "Search Show",
                    signpostID: signpost,
                    "Buscando Shows con el nombre %{public}@", named)
        
        let searchURL = "https://api.trakt.tv/search/show?query=\(named)"

        guard let request = self.makeURLRequest(string: searchURL, withFilters: filters, paginationOptions: pagination) else
        {
            os_log(.error, "URL mal formada - %@", searchURL)
            os_signpost(.end,
                        log: TraktTVClient.traktLog,
                        name: "Search Show",
                        signpostID: signpost,
                        "URL mal formada.")
            
            handler(nil, nil, .preconditionFailed)
                    
            return 
        }

        self.processRequest(request) { (result: HttpResult) -> Void in
            switch result
            {
            case .success(let data, let pagination):
                os_log(.info, "Búsqueda correcta. Descargados %{iec-bytes}d", data.count)
                os_signpost(.event, log: TraktTVClient.traktLog, name: "Search Show", signpostID: signpost, "Descargados %{iec-bytes}d bytes", data.count)

                if let shows = try? self.decoder.decode([SearchResult].self, from: data)
                {
                    
                    os_signpost(.end,
                                log: TraktTVClient.traktLog,
                                name: "Search Show",
                                signpostID: signpost,
                                "Shows recuperados %@. Tamaño de la descarga %@ bytes", "\(shows.count)", "\(data.count)")
                    
                    handler(shows, pagination, nil)
                }
            case .requestError(let code, let message):
                os_log(.error, "Se ha producido un error al buscar. Código %d, %@", code, message)
                os_signpost(.end, log: TraktTVClient.traktLog, name: "Search Show", signpostID: signpost, "Se ha producido un error al buscar. Código %d, %@", code, message)
                
                let error = TraktError(httpCode: code)
                handler(nil, nil, error)

            case .connectionError:
                os_log(.error, "Se ha producido un error de conexión.")
                os_signpost(.end, log: TraktTVClient.traktLog, name: "Search Show", signpostID: signpost, "Error de conexión")
                
                handler(nil, nil, TraktError.serverIsDown)
            }
        }
    }
}
