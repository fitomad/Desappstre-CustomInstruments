//
//  HttpResult.swift
//  CoreTraktTV
//
//  Created by Adolfo on 10/4/18.
//  Copyright (c) 2018 Desappstre Studio. All rights reserved.
//
import Foundation

/**
 Posibles resultados al ejecutat una peticion HTTP
 para el feed de información de incidencias de la EMT.
 
 Los posibles valores devolvemos son:
 
 - Success: Recuperamos el contenido del stream
 - RequestError: Problema en la peticion HTTP
 - ConnectionError: Error general
 */
internal enum HttpResult
{
    /// La operacion ha terminado bien.
    /// Devolvemos el stream de datos reacuperados
    case success(data: Data, pagination: Pagination?)
    /// Algo ha salido mal.
    /// Devolvemos un mensaje con la descripcion del error
    /// y el codigo HTTP asociado
    case requestError(code: Int, message: String)
    /// Problemas de conexión con el servidor
    ///
    case connectionError
}
