//
//  AlbumDetailsViewTests.swift
//  LastFM-AppTests
//
//  Created by Erich Flock on 04.03.21.
//

import XCTest
@testable import LastFM_App

class AlbumDetailsViewTests: XCTestCase {

    private var sut: AlbumDetailView!
    
    override func setUpWithError() throws {
        sut = AlbumDetailView()
    }

    override func tearDownWithError() throws {
        sut = nil
    }

    func test_emptyTracksView_whenTracksIsNil_shouldNotBeNil() {
        XCTAssertNil(sut.emptyTracksView, "precondition")
        
        sut.viewModel = .init(album: .init(name: "some name", imageURLString: "some url", artistName: "some name", tracks: nil, isSaved: false))
        
        XCTAssertNotNil(sut.emptyTracksView)
    }
    
    func test_emptyTracksView_whenTracksIsEmpty_shouldNotBeNil() {
        XCTAssertNil(sut.emptyTracksView, "precondition")
        
        sut.viewModel = .init(album: .init(name: "some name", imageURLString: "some url", artistName: "some name", tracks: nil, isSaved: false))
        
        XCTAssertNotNil(sut.emptyTracksView)
    }
    
    func test_emptyTracksView_whenTracks_shouldBeNil() {
        XCTAssertNil(sut.emptyTracksView, "precondition")
        
        sut.viewModel = .init(album: .init(name: "some name", imageURLString: "some url", artistName: "some name", tracks: [.init(name: "some track")], isSaved: false))
        
        XCTAssertNil(sut.emptyTracksView)
    }

}
