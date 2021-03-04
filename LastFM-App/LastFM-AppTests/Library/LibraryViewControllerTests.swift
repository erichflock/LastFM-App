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
        
        sut.viewWillAppear(false)
        
        XCTAssertEqual(coreDataManager.fetchAlbumsCallCount, 1)
    }
    
    func test_removeBarButtonItem_whenTappedAndSavedAlbumsNotEmpty_shouldPresentAlertWithCancelAndYesActions() {
        let spySut = SpyLibraryViewController()
        let coreDataManager = FakeCoreDataManager()
        coreDataManager.savedAlbums = [createSomeAlbum()]
        spySut.coreDataManager = coreDataManager
        spySut.viewWillAppear(false)
        XCTAssertFalse(spySut.albums.isEmpty, "precondition")
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
        coreDataManager.savedAlbums = [createSomeAlbum()]
        spySut.coreDataManager = coreDataManager
        spySut.viewWillAppear(false)
        spySut.removeBarButtonItem.tap()
        XCTAssertFalse(spySut.albums.isEmpty, "precondition")
        XCTAssertEqual(coreDataManager.deleteAllCallCount, 0)
        
        spySut.alertController?.tapButton(atIndex: 1)
        executeRunLoop()
        
        XCTAssertEqual(coreDataManager.deleteAllCallCount, 1)
    }
    
    func test_removeBarButtonItem_whenCancelActionTapped_shouldNotRemoveAlbums() {
        let spySut = SpyLibraryViewController()
        let coreDataManager = FakeCoreDataManager()
        coreDataManager.savedAlbums = [createSomeAlbum()]
        spySut.coreDataManager = coreDataManager
        spySut.viewWillAppear(false)
        spySut.removeBarButtonItem.tap()
        XCTAssertFalse(spySut.albums.isEmpty, "precondition")
        XCTAssertEqual(coreDataManager.deleteAllCallCount, 0)
        
        spySut.alertController?.tapButton(atIndex: 0)
        executeRunLoop()
        
        XCTAssertEqual(coreDataManager.deleteAllCallCount, 0)
    }
    
    func test_removeBarButtonItem_whenTappedAndNoAlbums_shouldNotShowAlert() {
        let spySut = SpyLibraryViewController()
        spySut.viewWillAppear(false)
        XCTAssertTrue(spySut.albums.isEmpty, "precondition")
        XCTAssertEqual(spySut.presentCallCount, 0, "precondition")
        XCTAssertNil(spySut.alertController, "precondition")
        
        spySut.removeBarButtonItem.tap()
        
        XCTAssertEqual(spySut.presentCallCount, 0)
        XCTAssertNil(spySut.alertController)
    }
    
}

private class FakeCoreDataManager: CoreDataManagerFetchProtocol & CoreDataManagerDeleteAllProtocol {
    
    var fetchAlbumsCallCount = 0
    var deleteAllCallCount = 0
    var savedAlbums: [Album] = []
    
    func fetchAlbums() -> [Album] {
        fetchAlbumsCallCount += 1
        return savedAlbums
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
