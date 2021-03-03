//
//  LibraryViewControllerTests.swift
//  LastFM-AppTests
//
//  Created by Erich Flock on 03.03.21.
//

import XCTest
@testable import LastFM_App

class LibraryViewControllerTests: XCTestCase {

    private var sut: LibraryViewController!
    
    override func setUpWithError() throws {
        sut = LibraryViewController()
    }

    override func tearDownWithError() throws {
        sut = nil
    }
    
    func test_whenViewWillAppear_shouldFetchSavedAlbums() {
        let coreDataManager = FakeCoreDataManager()
        sut.coreDataManager = coreDataManager
        XCTAssertEqual(coreDataManager.fetchAlbumsCallCount, 0, "precondition")
        XCTAssertNil(coreDataManager.fetchedAlbums)
        
        sut.viewWillAppear(false)
        
        XCTAssertEqual(coreDataManager.fetchAlbumsCallCount, 1)
        XCTAssertNotNil(coreDataManager.fetchedAlbums)
    }
}

private class FakeCoreDataManager: CoreDataManagerFetchProtocol {
    
    var fetchAlbumsCallCount = 0
    var fetchedAlbums: [Album]?
    
    func fetchAlbums() -> [Album] {
        fetchAlbumsCallCount += 1
        fetchedAlbums = []
        return []
    }
}
