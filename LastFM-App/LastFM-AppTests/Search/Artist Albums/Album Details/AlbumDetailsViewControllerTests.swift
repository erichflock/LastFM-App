//
//  AlbumDetailsViewControllerTests.swift
//  LastFM-AppTests
//
//  Created by Erich Flock on 03.03.21.
//

import XCTest
@testable import LastFM_App

class AlbumDetailsViewControllerTests: XCTestCase {

    private var sut: AlbumDetailsViewController!
    
    override func setUpWithError() throws {
        sut = AlbumDetailsViewController(albumTitle: "some title", artistName: "some artist name")
        sut.loadViewIfNeeded()
    }

    override func tearDownWithError() throws {
        sut = nil
    }

    func test_saveButton_whenSelected_shouldSaveAlbumToDB() {
        let coreDataManager = FakeCoreDataManager()
        sut.coreDataManager = coreDataManager
        XCTAssertEqual(coreDataManager.saveAlbumCallCount, 0, "precondition")
        
        sut.didTapSaveButton(isSelected: true, album: createSomeAlbum())
        
        XCTAssertEqual(coreDataManager.saveAlbumCallCount, 1)
    }
    
    func test_saveButton_whenUnselected_shouldDeleteAlbumFromDB() {
        let coreDataManager = FakeCoreDataManager()
        sut.coreDataManager = coreDataManager
        XCTAssertEqual(coreDataManager.deleteAlbumCallCount, 0, "precondition")
        
        sut.didTapSaveButton(isSelected: false, album: createSomeAlbum())
        
        XCTAssertEqual(coreDataManager.deleteAlbumCallCount, 1)
    }
    
    func test_albumDetailView_whenViewDidLoad_shouldHaveDelegate() {
        XCTAssertNotNil(sut.albumDetailView.delegate)
    }
}

private class FakeCoreDataManager: CoreDataManagerSaveProtocol, CoreDataManagerDeleteProtocol {
    
    var saveAlbumCallCount = 0
    var deleteAlbumCallCount = 0
    
    func saveAlbum(newAlbum: Album) {
        saveAlbumCallCount += 1
    }
    
    func deleteAlbum(album: Album) {
        deleteAlbumCallCount += 1
    }
    
}
