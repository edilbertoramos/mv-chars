//
//  MVServiceError.swift
//  MVChars
//
//  Created by Edilberto Ramos on 23/07/22.
//

import Foundation

public enum MVServiceError: MVError {
    
    case requestFailure
    case responseObjectError
    
    public var description: String {
        switch self {
        case .requestFailure:
            return "service_request_error"
            
        case .responseObjectError:
            return "service_json_error"
        }
    }
    
}
