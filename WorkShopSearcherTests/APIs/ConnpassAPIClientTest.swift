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
@testable import WorkShopSearcher

class ConnpassAPIClientTest: QuickSpec {
    override func spec() {
        describe("ConnpassAPIClientTest") {
            describe("fetchEvents") {
                var statusCode: Int = 0
                
                beforeEach {
                    statusCode = 0
                }
                afterEach {
                    sleep(1) /// APIのリクエストが連続でたくさん飛ばないように
                }
                context("when no query items") {
                    it("return not nil") {
                        let client = ConnpassAPIClient.shared
                        let searchQuery = ConnpassRequest.SearchQuery()
                        let result = client.fetchEvents(searchQuery: searchQuery)
                        result?.response { response in
                            statusCode = response.response?.statusCode ?? 0
                        }
                        expect(result).notTo(beNil())
                        expect(statusCode).toEventually(equal(200), timeout: 3)
                    }
                }
                context("when some query items") {
                    it("return not nil") {
                        let client = ConnpassAPIClient.shared
                        let searchQuery = ConnpassRequest.SearchQuery(keyword: ["swift"], ym: 2019)
                        let result = client.fetchEvents(searchQuery: searchQuery)
                        result?.response { response in
                            statusCode = response.response?.statusCode ?? 0
                        }
                        expect(result).notTo(beNil())
                        expect(statusCode).toEventually(equal(200), timeout: 3)
                    }
                }
            }
        }
    }
}
