//
//  Album.swift
//  LastFM-App
//
//  Created by Erich Flock on 28.02.21.
//

struct Album {
    var name: String
    var imageURLString: String
    var artistName: String
    var tracks: [Track]?
    
    struct Track {
        var name: String
    }
}
