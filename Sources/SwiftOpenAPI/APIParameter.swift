//
//  APIParameter.swift
//  OpenAPI
//
//  Created by Max on 08.11.2019.
//

import Foundation

public struct APIParameter: Encodable {
    enum Location: String, Encodable {
        case query
        case header
        case path
        case cookie
    }
    
    let name: String
    let location: Location
    let description: String?
    private(set) var required: Bool = true
    private(set) var deprecated: Bool = false
    private(set) var allowEmptyValue: Bool = false
    let example: String?

    private enum CodingKeys: String, CodingKey {
        case name
        case location = "in"
        case description
        case required
        case deprecated
        case allowEmptyValue
        case example
    }
    
    public static func query(name: String, description: String? = nil, required: Bool = true, deprecated: Bool = false, example: String? = nil) -> APIParameter {
        return APIParameter(name: name,
                            location: .query,
                            description: description,
                            required: required,
                            deprecated: deprecated,
                            allowEmptyValue: false,
                            example: example)
    }
    
    public static func path(name: String, description: String? = nil, example: String? = nil) -> APIParameter {
        return APIParameter(name: name,
                            location: .path,
                            description: description,
                            required: true,
                            deprecated: false,
                            allowEmptyValue: false,
                            example: example)
    }
    
    public static func header(name: String, description: String? = nil, required: Bool = true, deprecated: Bool = false, example: String? = nil) -> APIParameter {
        return APIParameter(name: name,
                            location: .header,
                            description: description,
                            required: required,
                            deprecated: deprecated,
                            allowEmptyValue: false,
                            example: example)
    }
}
