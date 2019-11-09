//
//  APIRequest.swift
//  OpenAPI
//
//  Created by Max on 08.11.2019.
//

import Foundation

public struct APIRequest: Encodable {
    let description: String?
    private(set) var content: [String: APIMediaType]?
    let required: Bool
    
    public init(description: String? = nil, objects: [MIMEType: Any.Type], required: Bool = true) {
        self.description = description
        
        for (key, value) in objects {
            if self.content == nil {
                self.content = [:]
            }
            self.content?[key.rawValue] = APIMediaType(objectType: value)
        }
        
        self.required = required
    }
}
