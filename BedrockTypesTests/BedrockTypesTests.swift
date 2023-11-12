//
//  BedrockTypesTests.swift
//  BedrockTypesTests
//
//  Created by Stormacq, Sebastien on 09/11/2023.
//

import XCTest
import BedrockTypes

final class BedrockTypesTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testEncodeBedrockClaudeModelParameters() throws {
        
        // given
        let claudeParams = BedrockClaudeModelParameters(prompt: "test")
        
        // when
        XCTAssertNoThrow(try claudeParams.encode())
        let data = try claudeParams.encode()
        
        // then
        let string = String(data: data, encoding: .utf8)
        XCTAssertNotNil(string)
        print(string!)
    }



}
