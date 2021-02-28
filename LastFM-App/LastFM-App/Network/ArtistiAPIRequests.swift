//
//  ArtistAPIRequests.swift
//  LastFM-App
//
//  Created by Erich Flock on 28.02.21.
//

import Alamofire

class ArtistAPIRequests {
    
    static func fetchArtists(query: String, completion: @escaping ([ArtistAPIModel]?) -> Void) {
        var parameters = Parameters()
        parameters["method"] = Config.artistSearch
        parameters["api_key"] = ConfigKeys.APIKey
        parameters["format"] = Config.jsonFormat
        parameters["artist"] = query.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)
        let url = Config.baseURL
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
