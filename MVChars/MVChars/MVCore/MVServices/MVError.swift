//
//  MVError.swift
//  MVChars
//
//  Created by Edilberto Ramos on 23/07/22.
//

import Foundation

public protocol MVError: Error, CustomStringConvertible {}

extension Error {
    
    public var description: String { return "\(self)" }
    
}
