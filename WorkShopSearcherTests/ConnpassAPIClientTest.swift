//
//  ConnpassAPIClientTest.swift
//  WorkShopSearcherTests
//
//  Created by 伊藤凌也 on 2019/04/06.
//  Copyright © 2019 ry-itto. All rights reserved.
//

import XCTest
import Quick
import Nimble
import Alamofire
@testable import WorkShopSearcher

class ConnpassAPIClientTest: QuickSpec {
    override func spec() {
        describe("ConnpassAPIClientTest") {
            describe("fetchEvents") {
                context("when successfully") {
                    it("return not nil") {
                        let client = ConnpassAPIClient()
                        let searchQuery = ConnpassRequest.SearchQuery()
                        let result = client.fetchEvents(searchQuery: searchQuery)
                        expect(result).notTo(beNil())
                    }
                }
            }
        }
    }
}
