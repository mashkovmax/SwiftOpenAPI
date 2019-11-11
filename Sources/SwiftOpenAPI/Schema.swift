//
//  Schema.swift
//  App
//
//  Created by Max Mashkov on 07.11.2019.
//

import Foundation
import AnyCodable

final class Schema: Encodable {
    struct DataType {
        let type: String
        let format: String?

        public static let int32 = DataType(type: "integer", format: "int32")
        public static let int64 = DataType(type: "integer", format: "int64")
        public static let float = DataType(type: "number", format: "float")
        public static let double = DataType(type: "number", format: "double")
        public static let string = DataType(type: "string", format: nil)
        public static let byte = DataType(type: "string", format: "byte")
        public static let binary = DataType(type: "string", format: "binary")
        public static let boolean = DataType(type: "boolean", format: nil)
        public static let date = DataType(type: "string", format: "date")
        public static let dateTime = DataType(type: "string", format: "date-time")
        public static let password = DataType(type: "string", format: "password")
    }
    
    let type: String?
    private(set) var format: String?
    private(set) var items: [Schema]?
    private(set) var required: Set<String>?
    private(set) var properties: [String: Schema]?
    private(set) var example: String?
    
    private struct DateValue: Decodable {
        let date: Date
    }
    
    init<T: Encodable>(value: T, encoder: JSONEncoder, decoder: JSONDecoder) throws {
        let checkedValue: Any
        
        if let value = value as? AnyCodable {
            checkedValue = value.value
        } else {
            checkedValue = value
        }
        
        switch checkedValue {
        case is Int32:
            self.type = DataType.int32.type
            self.format = DataType.int32.format
            self.example = String(describing: value)
        case is Int:
            self.type = DataType.int64.type
            self.format = DataType.int64.format
            self.example = String(describing: value)
        case is Float:
            self.type = DataType.float.type
            self.format = DataType.int64.format
            self.example = String(describing: value)
        case is Double:
            self.type = DataType.double.type
            self.format = DataType.double.format
            self.example = String(describing: value)
        case is Bool:
            self.type = DataType.boolean.type
            self.format = DataType.boolean.format
            self.example = String(describing: value)
        case is Date:
            self.type = DataType.dateTime.type
            self.format = DataType.dateTime.format
            self.example = String(describing: value)
        case is String:
            let dateJson = [
                "date": String(describing: checkedValue)
            ]

            if let data = try? encoder.encode(dateJson),
                (try? decoder.decode(DateValue.self, from: data)) != nil {
                
                self.type = DataType.dateTime.type
                self.format = DataType.dateTime.format
                self.example = String(describing: checkedValue)
            } else {
                self.type = DataType.string.type
                self.format = DataType.string.format
                self.example = String(describing: value)
            }
        case let array as [AnyCodable]:
            self.type = "array"
            self.items = try array.map { try Schema(value: $0,
                                                    encoder: encoder,
                                                    decoder: decoder) }
        default:
            self.type = "object"
            
            let mirror = Mirror(reflecting: value)
            
            let data = try encoder.encode(value)
            let json = try decoder.decode([String: AnyCodable].self, from: data)
            
            for (jsonKey, jsonValue) in json {
                
                let propertyKey = jsonKey.camelCased
                
                let mirroredValues = mirror.children.filter({ $0.label == propertyKey }).map({ $0.value })
                
                if mirroredValues.isEmpty {
                    addRequiredProperty(jsonKey)
                    
                    let childSchema = try Schema(value: jsonValue, encoder: encoder, decoder: decoder)

                    addProperty(childSchema, forKey: jsonKey)
                } else {
                    for value in mirroredValues {
                        if !isOptional(value) {
                            addRequiredProperty(jsonKey)
                        }
                        
                        let childSchema = try Schema(value: jsonValue, encoder: encoder, decoder: decoder)
                        
                        addProperty(childSchema, forKey: jsonKey)
                    }
                }
            }
        }
    }
    
    private func addProperty(_ schema: Schema, forKey key: String) {
        if self.properties == nil {
            self.properties = [:]
        }
        
        self.properties?[key] = schema
    }
    
    private func addRequiredProperty(_ key: String) {
        if self.required == nil {
            self.required = []
        }
        
        self.required?.insert(key)
    }
}

private func isOptional<T>(_ any: T) -> Bool {
    let mirror = Mirror(reflecting: any)
    return mirror.displayStyle == .optional
}
