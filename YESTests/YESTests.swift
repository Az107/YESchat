//
//  YESTests.swift
//  YESTests
//
//  Created by Alberto Ruiz on 14/6/23.
//

import XCTest
@testable import YES
final class YESTests: XCTestCase {
    let url = Bundle.main.path(forResource: "perrina", ofType: "jpeg")
    
    func testChunkerize() throws {
        let data = FileManager.default.contents(atPath: url!)!
        let chunks = try BigChunkus.chunkerize(file: data, fileName: "", sender: "Placeholder")
        assert(chunks.count != 0)
        
    }
    
    func testAddChunk() throws {
        let data = FileManager.default.contents(atPath: url!)!
        let chunks = try BigChunkus.chunkerize(file: data, fileName: "", sender: "Placeholder")
        let bigChunkus = BigChunkus()
        XCTAssertNoThrow(try bigChunkus.addChunk(chunk: chunks.first!))
        assert(!bigChunkus.chunks.isEmpty)
        assert(bigChunkus.chunks.last?.chunk.count == chunks.first!.chunk.count)
    }
    
    func testUnchunkerize() throws {
        let data = FileManager.default.contents(atPath: url!)!
        let chunks = try BigChunkus.chunkerize(file: data, fileName: "", sender: "Placeholder")
        let bigChunkus = BigChunkus()
        XCTAssertNoThrow(try bigChunkus.addChunk(chunk: chunks.first!))
        let fileData = try bigChunkus.unChunkerize()
        assert(fileData.file == data)

    }

}
