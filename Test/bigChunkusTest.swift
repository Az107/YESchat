//
//  bigChungusTest.swift
//  YES
//
//  Created by Alberto Ruiz on 14/6/23.
//

import XCTest

final class bigChungusTest: XCTestCase {

    let bigChunkus: BigChunkus = BigChunkus()
    func testExample() throws {
        let data = FileManager.default.contents(atPath: "./photo.jpeg") ?? Data()
        let chunks = bigChunkus.chunkerize(file: data, fileName: "", sender: "Placeholder")
        assert(chunks.count != 0)
        
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
