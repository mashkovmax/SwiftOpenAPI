//
//  APIDocument.swift
//  App
//
//  Created by Max on 07.11.2019.
//

import Foundation

public struct APIDocument {
    let encoder: JSONEncoder
    let decoder: JSONDecoder
    let openapi = "3.0.1"
    let info: Info
    var components: Components = .init()
    var paths: [String: APIPath] = [:]
    
    struct Components: Encodable {
        var schemas: [String: Schema] = [:]
    }

    public init(info: Info, encoder: JSONEncoder, decoder: JSONDecoder) {
        self.info = info
        self.encoder = encoder
        self.decoder = decoder
    }
    
    public mutating func addSchema<T: Encodable>(for value: T) throws {
        let schema = try Schema(value: value,
                                encoder: encoder,
                                decoder: decoder)
        let key = String(describing: T.self)
        
        components.schemas[key] = schema
    }
    
    public mutating func addController(_ controller: APIController) {
        for route in controller.routes {

            let key = route.path
            
            if self.paths[key] == nil {
                var path = APIPath()
                path.summary = controller.summary
                path.description = controller.description
                
                self.paths[key] = path
            }
            
            let operation = APIOperation(tags: [controller.name],
                                         summary: route.summary,
                                         description: route.description,
                                         operationId: nil,
                                         parameters: route.parameters,
                                         requestBody: route.request,
                                         responses: route.responses)
            
            switch route.method {
            case .get:
                self.paths[key]?.get = operation
            case .trace:
                self.paths[key]?.trace = operation
            case .delete:
                self.paths[key]?.delete = operation
            case .head:
                self.paths[key]?.head = operation
            case .options:
                self.paths[key]?.options = operation
            case .patch:
                self.paths[key]?.patch = operation
            case .post:
                self.paths[key]?.post = operation
            case .put:
                self.paths[key]?.put = operation
            }
        }
    }
}

extension APIDocument: Encodable {
    
    private enum CodingKeys: String, CodingKey {
        case openapi
        case info
        case components
        case paths
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(openapi, forKey: .openapi)
        try container.encode(info, forKey: .info)
        try container.encode(paths, forKey: .paths)
        try container.encode(components, forKey: .components)
    }
}

extension APIDocument {
    
    public struct Info: Encodable {
        let title: String
        let version: String
        let description: String?
        let termsOfService: String?
        let contact: Contact?
        let license: License?

        public init(
            title: String,
            version: String,
            description: String? = nil,
            termsOfService: String? = nil,
            contact: Contact? = nil,
            license: License? = nil
        ) {
            self.title = title
            self.version = version
            self.description = description
            self.termsOfService = termsOfService
            self.contact = contact
            self.license = license
        }
    }
    
    public struct Contact: Encodable {
        let name: String?
        let url: URL?
        let email: String?

        public init(
            name: String?,
            email: String? = nil,
            url: URL? = nil
        ) {
            self.name = name
            self.email = email
            self.url = url
        }
    }
    
    public struct License: Encodable {
        let name: String
        let url: URL?

        public init(name: String, url: URL? = nil) {
            self.name = name
            self.url = url
        }
    }
}
