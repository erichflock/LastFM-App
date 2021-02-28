//
//  ImageTypeAPIModel.swift
//  LastFM-App
//
//  Created by Erich Flock on 28.02.21.
//

struct ImageTypeAPIModel: Codable {
    var text: String?
    var size: Size
    
    enum Size: String, Codable, CaseIterableDefault {
        case small, medium, large, extralarge, mega, unknown
        static var defaultValue = unknown
    }
    
    enum CodingKeys: String, CodingKey {
        case text = "#text"
        case size
    }
}

