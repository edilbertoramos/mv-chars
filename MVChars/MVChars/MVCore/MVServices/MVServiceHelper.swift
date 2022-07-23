//
//  MVServiceHelper.swift
//  MVChars
//
//  Created by Edilberto Ramos on 23/07/22.
//

import Foundation
import Alamofire

public struct MVServiceHelper {
    
    static public var baseUrl: String {
        // TODO: - Move to plist file
        return "http://gateway.marvel.com/"
    }
    
    static public func makeUrl(_ url: String = baseUrl, withEndPoint service: MVServiceEndpoint) -> String {
        return "\(baseUrl)/\(service.endpoint)"
    }
    
    static public func makeUrl(_ url: String = baseUrl, withEndPoint service: MVServiceEndpoint, pathParameters parameters: String...) -> String {
        return String(format: makeUrl(url, withEndPoint: service), parameters)
    }
    
}

// MARK: - Brigde
extension MVServiceHelper {

    // MARK: Codable Object
    static public func get<T: Codable>(url: String, parameters: Parameters? = nil, headers: HTTPHeaders? = nil, callbackForObject callback: @escaping (MVServiceResponse<T>) -> Void) {
        request(url: url, method: .get, parameters: parameters, headers: headers, callbackForObject: callback)
    }
    
    // MARK: Codable Array
    static public func get<T: Codable>(url: String, parameters: Parameters? = nil, headers: HTTPHeaders? = nil, callbackForObjectArray callback: @escaping (MVServiceResponse<[T]>) -> Void) {
        request(url: url, method: .get, parameters: parameters, headers: headers, callbackForObjectArray: callback)
    }
    
}

// MARK: - Response
extension MVServiceHelper {
    
    static public func responseForObject<T: Codable>(response: AFDataResponse<Data>, callback: @escaping (MVServiceResponse<T>) -> Void) {
        switch response.result {
        case .success(let data):
            do {
                let decoder = JSONDecoder()
                let object = try decoder.decode(T.self, from: data)
                callback(MVServiceResponse(
                    withData: object,
                    statusCode: response.response?.statusCode)
                )
            } catch {
                print(error.localizedDescription)
                callback(MVServiceResponse(
                    withError: MVServiceError.responseObjectError,
                    statusCode: response.response?.statusCode)
                )
            }
        case .failure(let error):
            var errorMessage: String? = error.errorDescription
            if let data = error.downloadResumeData,
               let message = String(data: data, encoding: .utf8) {
                errorMessage = message
            }
            
            callback(MVServiceResponse(
                withError: MVServiceError.requestFailure,
                statusCode: response.response?.statusCode,
                errorMessage: errorMessage)
            )
        }
    }
    
    static public func responseForArray<T: Decodable>(response: AFDataResponse<Data>, callback: @escaping (MVServiceResponse<[T]>) -> Void) {
        switch response.result {
        case .success(let data):
            do {
                let decoder = JSONDecoder()
                let object = try decoder.decode([T].self, from: data)
                callback(MVServiceResponse(
                    withData: object,
                    statusCode: response.response?.statusCode)
                )
            } catch {
                print(error.localizedDescription)
                callback(MVServiceResponse(
                    withError: MVServiceError.responseObjectError,
                    statusCode: response.response?.statusCode)
                )
            }
        case .failure(let error):
            var errorMessage: String? = error.errorDescription
            if let data = error.downloadResumeData,
               let message = String(data: data, encoding: .utf8) {
                errorMessage = message
            }
            
            callback(MVServiceResponse(
                withError: MVServiceError.requestFailure,
                statusCode: response.response?.statusCode,
                errorMessage: errorMessage)
            )
        }
    }
    
}

// MARK: - Requests
extension MVServiceHelper {
    
    fileprivate static func request<T: Codable>(url: String, method: HTTPMethod, parameters: Parameters?, headers: HTTPHeaders?, callbackForObject callback: @escaping (MVServiceResponse<T>) -> Void) {
        AF.request(
            url,
            method: method,
            parameters: parameters,
            encoding: method == .get ? URLEncoding.default : JSONEncoding.default,
            headers: headers
        ).validate(
            statusCode: [
                MVServiceHttpStatusCode.success.code,
                MVServiceHttpStatusCode.accepted.code,
                MVServiceHttpStatusCode.created.code
            ]
        ).responseData(completionHandler: { (response) in
            responseForObject(response: response, callback: callback)
        })
    }
    
    fileprivate static func request<T: Codable>(url: String, method: HTTPMethod, parameters: Parameters?, headers: HTTPHeaders?, callbackForObjectArray callback: @escaping (MVServiceResponse<[T]>) -> Void) {
        AF.request(
            url,
            method: method,
            parameters: parameters,
            encoding: method == .get ? URLEncoding.default : JSONEncoding.default,
            headers: headers
        ).validate(
            statusCode: [
                MVServiceHttpStatusCode.success.code,
                MVServiceHttpStatusCode.accepted.code,
                MVServiceHttpStatusCode.created.code
            ]
        ).responseData(completionHandler: { (response) in
            responseForArray(response: response, callback: callback)
        })
    }
    
}
