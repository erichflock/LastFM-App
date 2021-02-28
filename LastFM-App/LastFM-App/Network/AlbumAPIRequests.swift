//
//  AlbumAPIRequests.swift
//  LastFM-App
//
//  Created by Erich Flock on 28.02.21.
//

import Alamofire

class AlbumAPIRequests {
    
    static func fetchAlbums(query: String, completion: @escaping ([AlbumAPIModel]?) -> Void) {
        var parameters = Parameters()
        parameters["method"] = Config.methodArtistTopAlbums
        parameters["api_key"] = ConfigKeys.APIKey
        parameters["format"] = Config.jsonFormat
        parameters["artist"] = query
        let url = Config.baseURL
        let request = AF.request(url, parameters: parameters)
        request.responseDecodable(of: AlbumsSearchResultRoot.self) { response in
            completion(response.value?.topAlbums?.albums)
        }
    }
    
    static func fetchAlbumInformation(albumName: String, artistName: String, completion: @escaping (AlbumInformation?) -> Void) {
        var parameters = Parameters()
        parameters["method"] = Config.methodAlbumGetInfo
        parameters["api_key"] = ConfigKeys.APIKey
        parameters["format"] = Config.jsonFormat
        parameters["artist"] = artistName
        parameters["album"] = albumName
        let url = Config.baseURL
        let request = AF.request(url, parameters: parameters)
        request.responseDecodable(of: AlbumInformationResultRoot.self) { response in
            completion(response.value?.albumInformation)
        }
    }
}

typealias AlbumAPIModel = AlbumsSearchResultRoot.TopAlbums.Album

struct AlbumsSearchResultRoot: Codable {
    
    var topAlbums: TopAlbums?
    
    enum CodingKeys: String, CodingKey {
        case topAlbums = "topalbums"
    }
    
    struct TopAlbums: Codable {
        
        var albums: [Album]?
        
        struct Album: Codable {
            var name: String?
            var image: [ImageTypeAPIModel]?
            var artist: Artist?
            
            struct Artist: Codable {
                var name: String?
            }
        }
        
        enum CodingKeys: String, CodingKey {
            case albums = "album"
        }
    }
}

typealias AlbumInformation = AlbumInformationResultRoot.AlbumInformation

struct AlbumInformationResultRoot: Codable {
    
    var albumInformation: AlbumInformation?
    
    struct AlbumInformation: Codable {
        var name: String?
        var artist: String?
        var image: [ImageTypeAPIModel]?
        var tracks: AlbumTracks?
        
        struct AlbumTracks: Codable {
            var tracks: [Track]
            
            struct Track: Codable {
                var name: String?
            }
            
            enum CodingKeys: String, CodingKey {
                case tracks = "track"
            }
        }

    }
    
    enum CodingKeys: String, CodingKey {
        case albumInformation = "album"
    }
}
