//
//  AlbumAPIRequests.swift
//  LastFM-App
//
//  Created by Erich Flock on 28.02.21.
//

import Alamofire

class AlbumAPIRequests {
    
    static func fetchAlbums(query: String, completion: @escaping ([Album]?) -> Void) {
        var parameters = Parameters()
        parameters["method"] = Config.artistTopAlbums
        parameters["api_key"] = ConfigKeys.APIKey
        parameters["format"] = Config.jsonFormat
        parameters["artist"] = query.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)
        let url = Config.baseURL
        let request = AF.request(url, parameters: parameters)
        request.responseDecodable(of: AlbumsSearchResultRoot.self) { response in
            completion(response.value?.topAlbums?.albums)
        }
    }

}

typealias Album = AlbumsSearchResultRoot.TopAlbums.Album

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
        }
        
        enum CodingKeys: String, CodingKey {
            case albums = "album"
        }
    }
}
