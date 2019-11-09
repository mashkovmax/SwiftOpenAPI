//
//  APIResponse.swift
//  OpenAPI
//
//  Created by Max on 08.11.2019.
//

import Foundation

public struct APIResponse: Encodable {
    
    public struct Header: Encodable {
        let description: String?
        let required: Bool
        let deprecated: Bool
        let allowEmptyValue: Bool

        public init(description: String? = nil,
                    required: Bool = false,
                    deprecated: Bool = false,
                    allowEmptyValue: Bool = false) {

            self.description = description
            self.required = required
            self.deprecated = deprecated
            self.allowEmptyValue = allowEmptyValue
        }
    }
    
    let description: String
    let headers: [String: Header]?
    private(set) var content: [String: APIMediaType]?
    
    public init(description: String, headers: [String: Header]? = nil, objects: [MIMEType: Any.Type] = [:]) {
        self.description = description
        self.headers = headers
        
        for (key, value) in objects {
            if self.content == nil {
                self.content = [:]
            }
            self.content?[key.rawValue] = APIMediaType(objectType: value)
        }
    }
}
