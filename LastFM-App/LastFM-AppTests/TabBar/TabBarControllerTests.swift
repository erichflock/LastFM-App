//
//  TabBarControllerTests.swift
//  LastFM-AppTests
//
//  Created by Erich Flock on 27.02.21.
//

import XCTest
@testable import LastFM_App

class TabBarControllerTests: XCTestCase {

    private var sut: TabBarController!
    
    override func setUpWithError() throws {
        sut = TabBarController()
        sut.loadViewIfNeeded()
    }

    override func tearDownWithError() throws {
        sut = nil
    }
    
    func test_tabBar_whenViewDidLoad_imageOfFirstItemShouldBeExpectedImage() {
        let expectedImage = UIImage(named: "music.library")
        
        XCTAssertEqual(sut.tabBar.items?[0].image, expectedImage)
    }
    
    func test_tabBar_whenViewDidLoad_imageOfSecondItemShouldBeExpectedImage() {
        let expectedImage = UIImage(systemName: "magnifyingglass")
        
        XCTAssertEqual(sut.tabBar.items?[1].image, expectedImage)
    }
    
    func test_tabBar_whenViewDidLoad_tabBarShouldHaveTwoItems() {
        XCTAssertEqual(sut.tabBar.items?.count, 2)
    }
}
