//
//  APIOperation.swift
//  OpenAPI
//
//  Created by Max on 08.11.2019.
//

import Foundation

struct APIOperation: Encodable {
    let tags: [String]
    let summary: String
    let description: String?
    let operationId: String?
    private(set) var parameters: [APIParameter]?
    let requestBody: APIRequest?
    let responses: [String: APIResponse]
}
