//
//  SearchTableViewControllerTests.swift
//  LastFM-AppTests
//
//  Created by Erich Flock on 04.03.21.
//

import XCTest
@testable import LastFM_App

class SearchTableViewControllerTests: XCTestCase {

    private var sut: SearchTableViewController!
    
    override func setUpWithError() throws {
        sut = SearchTableViewController()
    }

    override func tearDownWithError() throws {
        sut = nil
    }

    func test_emptySearchView_whenViewDidLoad_shouldNotBeNil() {
        XCTAssertNil(sut.emptySearchView, "precondition")
        
        sut.loadViewIfNeeded()
        
        XCTAssertNotNil(sut.emptySearchView)
    }

}
