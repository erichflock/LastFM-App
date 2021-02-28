//
//  ArtistAPIRequests.swift
//  LastFM-App
//
//  Created by Erich Flock on 28.02.21.
//

import Alamofire

class ArtistAPIRequests {
    
    static func fetchArtist(query: String, completion: @escaping ([ArtistAPIModel]?) -> Void) {
        var parameters = Parameters()
        parameters["method"] = "artist.search"
        parameters["api_key"] = ConfigKeys.APIKey
        parameters["format"] = "json"
        parameters["artist"] = query.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)
        let url = ConfigURL.baseURL
        let request = AF.request(url, parameters: parameters)
        request.responseDecodable(of: ArtistSearchResultRoot.self) { response in
            completion(response.value?.results?.artistMatches?.artists)
        }
    }
}


typealias ArtistAPIModel = ArtistSearchResultRoot.ArtistSearchResults.ArtistMatches.Artist

struct ArtistSearchResultRoot: Codable {
    
    var results: ArtistSearchResults?
    
    struct ArtistSearchResults: Codable {
        
        var artistMatches: ArtistMatches?
        
        struct ArtistMatches: Codable {
            var artists: [Artist]?
            
            struct Artist: Codable {
                var name: String?
                var listeners: String?
                var image: [ImageType]?
                
                struct ImageType: Codable {
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
            }
            
            enum CodingKeys: String, CodingKey {
                case artists = "artist"
            }
        }
        
        enum CodingKeys: String, CodingKey {
            case artistMatches = "artistmatches"
        }
    }
}

protocol CaseIterableDefault: Codable & CaseIterable & RawRepresentable where RawValue: Codable {
    static var defaultValue: Self { get }
}

extension CaseIterableDefault {
    
    init(from decoder: Decoder) throws {
        let rawValue = try decoder.singleValueContainer().decode(RawValue.self)
        if let initValue = Self(rawValue: rawValue) {
            self = initValue
        } else {
            self = Self.defaultValue
        }
    }
}
