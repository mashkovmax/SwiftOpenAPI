//
//  MIMEType.swift
//  OpenAPI
//
//  Created by Max on 08.11.2019.
//

import Foundation

public enum MIMEType: String, Encodable {
    case json = "application/json"
    case formUrlencoded = "application/x-www-form-urlencoded"
    case multipartFormData = "multipart/form-data"
    case textPlain = "text/plain"

    case imagePNG = "image/png"
    case imageJPEG = "image/jpeg"
    case imageGIF = "image/gif"

    case all = "*/*"
}
