//
//  String+CamelCase.swift
//  OpenAPI
//
//  Created by Max Mashkov on 07.11.2019.
//

import Foundation

extension String {
    
    var camelCased: String {
        return self
                .split(separator: "_")
                .map { String($0) }
                .enumerated()
                .map { $0.offset > 0 ? $0.element.capitalized : $0.element.lowercased() }
                .joined()
    }
}
