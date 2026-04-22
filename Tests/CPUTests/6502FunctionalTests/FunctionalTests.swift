//
//  File.swift
//  Swift6502
//
//  Created by James Weatherley on 27/12/2025.
//

import Testing
import Foundation
@testable import Swift6502

private enum FunctionalTestFailure: Error, CustomStringConvertible {
    case invalidOpcode(InvalidOpcodeTrap)
    case stalled(pc: UInt16, tickcount: Int)
    case timeout(pc: UInt16, tickcount: Int)
    
    var description: String {
        switch self {
        case .invalidOpcode(let trap):
            return String(format: "Invalid opcode 0x%02X at 0x%04X", trap.opcode, trap.address)
        case .stalled(let pc, let tickcount):
            return String(format: "Execution stalled at 0x%04X after %d ticks", pc, tickcount)
        case .timeout(let pc, let tickcount):
            return String(format: "Timed out at 0x%04X after %d ticks", pc, tickcount)
        }
    }
}

struct FunctionalTests {
    private let startPC: UInt16 = 0x0400
    private let successPC: UInt16 = 0x3469
    private let ticksPerChunk = 10_000
    private let maxChunks = 50_000
    private let stalledChunkLimit = 3
    
    @Test func run6502Tests() async throws {
        let url = Bundle.module.url(
            forResource: "6502_functional_test",
            withExtension: "bin"
        )
        #expect(url != nil)
        
        guard let url else { return }
        let testsData = try Data(contentsOf: url)
        
        let memory = UnsafeMutablePointer<UInt8>.allocate(capacity: 0x10000)
        defer { memory.deallocate() }
        memset(memory, 0, 0x10000)
        
        testsData.withUnsafeBytes { (bytes: UnsafeRawBufferPointer) in
            let count = min(0x10000, bytes.count)
            if let base = bytes.baseAddress {
                memcpy(memory, base, count)
            }
        }
        
        let cpu = CPU6502(memory: MemoryWrapper(memory))
        await cpu.setPC(startPC)
        
        var previousPC: UInt16? = nil
        var unchangedChunks = 0
        
        for _ in 0..<maxChunks {
            await cpu.runForTicks(ticksPerChunk)
            
            if let trap = await cpu.invalidOpcodeTrap {
                throw FunctionalTestFailure.invalidOpcode(trap)
            }
            
            let pc = await cpu.PC
            if pc == successPC {
                return
            }
            
            if previousPC == pc {
                unchangedChunks += 1
                if unchangedChunks == stalledChunkLimit {
                    throw FunctionalTestFailure.stalled(
                        pc: pc,
                        tickcount: await cpu.tickcount
                    )
                }
            } else {
                unchangedChunks = 0
                previousPC = pc
            }
        }
        
        throw FunctionalTestFailure.timeout(
            pc: await cpu.PC,
            tickcount: await cpu.tickcount
        )
    }
}
