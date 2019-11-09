//
//  APIPath.swift
//  OpenAPI
//
//  Created by Max on 08.11.2019.
//

import Foundation

struct APIPath: Encodable {
    var summary: String?
    var description: String?
    var get: APIOperation?
    var put: APIOperation?
    var post: APIOperation?
    var delete: APIOperation?
    var options: APIOperation?
    var head: APIOperation?
    var patch: APIOperation?
    var trace: APIOperation?
//    var parameters: [Parameter]?
}
