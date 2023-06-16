//
//  BigChungus.swift
//  YES
//
//  Created by Alberto Ruiz on 14/6/23.
//

import Foundation


struct Chunk {
    var sender: String
    var name: String
    var index: Int
    var total: Double
    var chunk: Data
    
}

struct fileMessage {
    
}

class BigChunkus {
    let chunkSize = 1024 * 1024
    var chunks: [Chunk] = []
    
    func clear() {
        self.chunks = []
    }
    
    func chunkerize(file: Data, fileName: String, sender: String) -> [Chunk] {
        var chunks: [Chunk] = []
        if (file.isEmpty) {return []} // TODO: replace with exception
        var offset = 0
        var index = 0
        let total = ceil(Double(file.count/self.chunkSize))
        
        while (offset < file.count - 1){
            var newOffset = offset+chunkSize
            if (newOffset > file.count) {newOffset = file.count - 1}
            chunks.append(Chunk(
                sender: sender,
                name: fileName,
                index: index,
                total: total,
                chunk: file.subdata(in: Range(offset...newOffset)))
            )
            offset = newOffset
            index+=1
        }
        
        return chunks
    }
    
    func unChunkerize(){
        
    }
}
