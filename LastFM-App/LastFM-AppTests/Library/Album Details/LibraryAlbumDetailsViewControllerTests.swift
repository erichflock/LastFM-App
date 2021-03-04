//
//  LibraryAlbumDetailsViewControllerTests.swift
//  LastFM-AppTests
//
//  Created by Erich Flock on 03.03.21.
//

import XCTest
@testable import LastFM_App

class LibraryAlbumDetailsViewControllerTests: XCTestCase {

    private var sut: LibraryAlbumDetailsViewController!
    
    override func setUpWithError() throws {
        sut = LibraryAlbumDetailsViewController(album: createSomeAlbum())
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
        XCTAssertNil(sut.albumDetailView.delegate, "precondition")
        
        sut.loadViewIfNeeded()
        
        XCTAssertNotNil(sut.albumDetailView.delegate)
    }
    
    func test_albumDetailView_whenViewDidLoad_shouldHaveViewModel() {
        XCTAssertNil(sut.albumDetailView.viewModel, "precondition")
        
        sut.loadViewIfNeeded()
        
        XCTAssertNotNil(sut.albumDetailView.viewModel)
    }
}

private class FakeCoreDataManager: CoreDataManagerSaveProtocol, CoreDataManagerDeleteProtocol & CoreDataManagerFetchAlbumProtocol {
    
    var saveAlbumCallCount = 0
    var deleteAlbumCallCount = 0
    
    func saveAlbum(newAlbum: Album) {
        saveAlbumCallCount += 1
    }
    
    func deleteAlbum(album: Album) {
        deleteAlbumCallCount += 1
    }
    
    func fetch(album: Album) -> Album? {
        return nil
    }
}
