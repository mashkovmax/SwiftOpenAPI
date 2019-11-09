//
//  APIController.swift
//  OpenAPI
//
//  Created by Max on 08.11.2019.
//

import Foundation

public struct APIController {
    
    public struct Route {
        
        public enum HttpMethod {
            case options
            case get
            case head
            case post
            case patch
            case put
            case delete
            case trace
        }
        
        let method: HttpMethod
        let path: String
        let summary: String
        let description: String?
        let parameters: [APIParameter]?
        let request: APIRequest?
        let responses: [String: APIResponse]
        
        public init(method: HttpMethod,
                    path: String,
                    summary: String,
                    description: String? = nil,
                    parameters: [APIParameter]? = nil,
                    request: APIRequest? = nil,
                    responses: [String: APIResponse]) {
            
            self.method = method
            self.path = path
            self.summary = summary
            self.description = description
            self.parameters = parameters
            self.request = request
            self.responses = responses
        }
    }
    
    let name: String
    let summary: String
    let description: String?
    let routes: [Route]
    
    public init(name: String,
                summary: String,
                description: String? = nil,
                routes: [Route]) {
        
        self.name = name
        self.summary = summary
        self.description = description
        self.routes = routes
    }
}
