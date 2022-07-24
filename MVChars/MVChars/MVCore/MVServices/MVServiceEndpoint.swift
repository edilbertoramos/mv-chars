//
//  MVServiceEndpoint.swift
//  MVChars
//
//  Created by Edilberto Ramos on 23/07/22.
//

import Foundation

public protocol MVServiceEndpoint {
    
    var endpoint: String { get }
    
}

// MARK: - Default
extension MVServiceEndpoint where Self: RawRepresentable, Self.RawValue == String {
    
    public var endpoint: String { rawValue }
    
}
