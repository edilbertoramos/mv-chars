//
//  MVServiceResponse.swift
//  MVChars
//
//  Created by Edilberto Ramos on 23/07/22.
//

import Foundation

public struct MVServiceResponse<T> {
    
    public let success: Bool
    public let data: T?
    public let error: MVError?
    public let statusCode: Int?
    public let errorMessage: String?
    
    public var isSuccess: Bool { return success }
    
    fileprivate init(success: Bool = false, data: T?, error: MVError?, statusCode: Int?, errorMessage: String?) {
        self.success = success
        self.data = data
        self.error = error
        self.statusCode = statusCode
        self.errorMessage = errorMessage
    }
    
    public init(withError error: MVError, statusCode: Int? = nil, errorMessage: String? = nil) {
        self.init(success: false, data: nil, error: error, statusCode: statusCode, errorMessage: errorMessage)
    }
    
    public init(withData data: T, statusCode: Int? = nil) {
        self.init(success: true, data: data, error: nil, statusCode: statusCode, errorMessage: nil)
    }
    
    public func logError() -> MVError {
        print("Error: \(error!), message: \(errorMessage ?? "")")
        return error!
    }
    
}
