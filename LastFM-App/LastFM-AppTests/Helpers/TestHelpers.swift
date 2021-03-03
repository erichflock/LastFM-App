//
//  TestHelpers.swift
//  LastFM-AppTests
//
//  Created by Erich Flock on 27.02.21.
//

import Foundation
@testable import LastFM_App

func executeRunLoop() {
    RunLoop.current.run(until: Date())
}
    
func createSomeAlbum() -> Album {
    return .init(name: "some name", imageURLString: "some image url", artistName: "some artist name")
}
