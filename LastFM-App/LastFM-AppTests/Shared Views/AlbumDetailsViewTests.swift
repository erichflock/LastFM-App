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

    func test_emptyTracksView_whenTracksIsNil_shouldNotBeHidden() {
        XCTAssertTrue(sut.emptyTracksView.isHidden, "precondition")

        sut.viewModel = .init(album: .init(name: "some name", imageURLString: "some url", artistName: "some name", tracks: nil, isSaved: false))

        XCTAssertFalse(sut.emptyTracksView.isHidden)
    }

    func test_emptyTracksView_whenTracksIsEmpty_shouldNotBeHidden() {
        XCTAssertTrue(sut.emptyTracksView.isHidden, "precondition")

        sut.viewModel = .init(album: .init(name: "some name", imageURLString: "some url", artistName: "some name", tracks: nil, isSaved: false))

        XCTAssertFalse(sut.emptyTracksView.isHidden)
    }

    func test_emptyTracksView_whenTracks_shouldBeHidden() {
        XCTAssertTrue(sut.emptyTracksView.isHidden, "precondition")

        sut.viewModel = .init(album: .init(name: "some name", imageURLString: "some url", artistName: "some name", tracks: [.init(name: "some track")], isSaved: false))

        XCTAssertTrue(sut.emptyTracksView.isHidden)
    }

}
