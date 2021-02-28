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
        parameters["method"] = Config.artistTopAlbums
        parameters["api_key"] = ConfigKeys.APIKey
        parameters["format"] = Config.jsonFormat
        parameters["artist"] = query
        let url = Config.baseURL
        let request = AF.request(url, parameters: parameters)
        request.responseDecodable(of: AlbumsSearchResultRoot.self) { response in
            completion(response.value?.topAlbums?.albums)
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
