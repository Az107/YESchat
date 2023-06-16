//
//  YESTests.swift
//  YESTests
//
//  Created by Alberto Ruiz on 14/6/23.
//

import XCTest
@testable import YES
final class YESTests: XCTestCase {

    let bigChunkus: BigChunkus = BigChunkus()
    func testExample() throws {
        let url = Bundle.main.path(forResource: "photo", ofType: "jpeg")
        let data = FileManager.default.contents(atPath: url!)!
        let chunks = bigChunkus.chunkerize(file: data, fileName: "", sender: "Placeholder")
        assert(chunks.count != 0)
        
    }

}
