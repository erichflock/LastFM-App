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
    
    func test_removeBarButtonItem_whenTapped_shouldPresentAlertWithCancelAndYesActions() {
        let spySut = SpyLibraryViewController()
        spySut.loadViewIfNeeded()
        XCTAssertEqual(spySut.presentCallCount, 0, "precondition")
        XCTAssertNil(spySut.alertController, "precondition")
        
        spySut.removeBarButtonItem.tap()
        
        XCTAssertEqual(spySut.presentCallCount, 1)
        XCTAssertNotNil(spySut.alertController)
        XCTAssertEqual(spySut.alertController?.actions.count, 2)
        XCTAssertEqual(spySut.alertController?.actions[0].title, "Cancel")
        XCTAssertEqual(spySut.alertController?.actions[1].title, "Yes")
    }
    
    func test_removeBarButtonItem_whenYesActionTapped_shouldRemoveAllAlbums() {
        let spySut = SpyLibraryViewController()
        let coreDataManager = FakeCoreDataManager()
        spySut.coreDataManager = coreDataManager
        spySut.loadViewIfNeeded()
        spySut.removeBarButtonItem.tap()
        XCTAssertEqual(coreDataManager.deleteAllCallCount, 0)
        
        spySut.alertController?.tapButton(atIndex: 1)
        executeRunLoop()
        
        XCTAssertEqual(coreDataManager.deleteAllCallCount, 1)
    }
    
    func test_removeBarButtonItem_whenCancelActionTapped_shouldNotRemoveAlbums() {
        let spySut = SpyLibraryViewController()
        let coreDataManager = FakeCoreDataManager()
        spySut.coreDataManager = coreDataManager
        spySut.loadViewIfNeeded()
        spySut.removeBarButtonItem.tap()
        XCTAssertEqual(coreDataManager.deleteAllCallCount, 0)
        
        spySut.alertController?.tapButton(atIndex: 0)
        executeRunLoop()
        
        XCTAssertEqual(coreDataManager.deleteAllCallCount, 0)
    }
}

private class FakeCoreDataManager: CoreDataManagerFetchProtocol & CoreDataManagerDeleteAllProtocol {
    
    var fetchAlbumsCallCount = 0
    var deleteAllCallCount = 0
    var fetchedAlbums: [Album]?
    
    func fetchAlbums() -> [Album] {
        fetchAlbumsCallCount += 1
        fetchedAlbums = []
        return []
    }
    
    func deleteAll() {
        deleteAllCallCount += 1
    }
    
}

private class SpyLibraryViewController: LibraryViewController {
    
    var alertController: UIAlertController?
    var presentCallCount = 0
    
    override func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
        presentCallCount += 1
        if let alertController = viewControllerToPresent as? UIAlertController {
            self.alertController = alertController
        }
    }
}
