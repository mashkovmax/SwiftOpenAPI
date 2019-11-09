//
//  APIMediaType.swift
//  OpenAPI
//
//  Created by Max on 08.11.2019.
//

import Foundation

public struct APIMediaType: Encodable {
    
    struct SchemaRef: Encodable {
        let ref: String
        
        private enum CodingKeys: String, CodingKey {
            case ref = "$ref"
        }
        
        init(objectType: Any.Type) {
            self.ref = "#/components/schemas/" + String(describing: objectType)
        }
    }
    
    let schema: SchemaRef
    
    init(objectType: Any.Type) {
        self.schema = .init(objectType: objectType)
    }
}
