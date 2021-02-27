//
//  SearchTableViewControllerTests.swift
//  LastFM-AppTests
//
//  Created by Erich Flock on 27.02.21.
//

import XCTest
@testable import LastFM_App

class SearchTableViewControllerTests: XCTestCase {
    
    private var sut: SearchTableViewController!
    
    override func setUpWithError() throws {
        sut = SearchTableViewController()
        sut.loadViewIfNeeded()
    }

    override func tearDownWithError() throws {
        sut = nil
    }
    
    func test_tableView_whenDidSelectRow_shouldPushToArtistAlbumsVC() {
        _ = UINavigationController(rootViewController: sut)
        XCTAssertEqual(sut.navigationController?.viewControllers.count, 1, "precondition")
        
        sut.tableView(sut.tableView, didSelectRowAt: IndexPath(row: 0, section: 0))
        executeRunLoop()
        
        XCTAssertEqual(sut.navigationController?.viewControllers.count, 2)
        XCTAssertTrue(sut.navigationController?.viewControllers[1] is ArtistAlbumsViewController)
    }
}
