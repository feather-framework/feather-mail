//
//  XCTFeatherMailTests.swift
//  XCTFeatherMailTests
//
//  Created by Tibor Bodecs on 2023. 01. 16..
//

import XCTest
import FeatherService
import FeatherMail
import XCTFeatherMail

final class XCTFeatherMailTests: XCTestCase {

    func testNormal() async throws {
        let registry = ServiceRegistry()
        
        try await registry.addMail(XCTMyMailServiceContext(isTestError: false))
        try await registry.run()

        let mail = try await registry.mail()
        XCTAssertNotNil(mail)

        let mailTestSuite = MailTestSuite(mail)
        
        try await mailTestSuite.testAll(from: "from@from.from", to: "to@to.to")
        
        try await registry.shutdown()
    }
    
    func testError() async throws {
        let registry = ServiceRegistry()
        
        try await registry.addMail(XCTMyMailServiceContext(isTestError: true))
        try await registry.run()

        let mail = try await registry.mail()
        XCTAssertNotNil(mail)

        let mailTestSuite = MailTestSuite(mail)
        
        do {
            try await mailTestSuite.testAll(from: "from@from.from", to: "to@to.to")
            XCTAssert(false, "no exception")
        }
        catch let error as MailTestSuiteError {
            XCTAssertTrue(error.error as? XCTMailServiceError != nil)
        }
        catch {
            XCTAssert(false, "wrong exception")
        }
        
        try await registry.shutdown()
    }
}
