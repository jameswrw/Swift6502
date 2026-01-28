//
//  File.swift
//  Swift6502
//
//  Created by James Weatherley on 27/12/2025.
//

import Testing
import Foundation
@testable import Swift6502

class FunctionalTests {
    
    // Allocate memory and CPU as optionals we control the lifetime of
    var memory: UnsafeMutablePointer<UInt8>? = nil
    var cpu: CPU6502? = nil
    
    func run() async {
        let clockspeedMHz = 1.0
        let fps = 60
        let frameInterval = UInt64(1_000_000_000 / fps)
        
        if let cpu {
            await cpu.setPC(0x400)
            await cpu.setOpCodeHook {
                (pc: UInt16,
                 opcode: Opcodes6502,
                 a: UInt8,
                 x: UInt8,
                 y: UInt8,
                 f: UInt8,
                 sp: UInt8) in
                
                if (pc == 0x37BB) {
                    print("Woo!")
                }
                let binaryFlags = String(f, radix: 2)
                let flags = String(repeating: "0", count: max(0, 8 - binaryFlags.count)) + binaryFlags
                print(
                    String(
                        format: "0x%04X:\t\(opcode)\tA: 0x%02X, X: 0x%02X, Y: 0x%02X, SP: 0x%02X, F: \(flags)",
                        pc, a, x, y, sp
                    )
                )
            }
            
            while true {
                await cpu.runForFrame(clockspeed: clockspeedMHz, fps: fps)
            }
            try? await Task.sleep(nanoseconds: frameInterval)
        }
    }
    
    @Test func run6502Tests() async throws {
        // Load the test binary resource
        let url = Bundle.module.url(
            forResource: "6502_functional_test",
            withExtension: "bin"
        )
        #expect(url != nil)
        
        guard let url else { return }
        let testsData = try Data(contentsOf: url)
        
        memory = UnsafeMutablePointer<UInt8>.allocate(capacity: 0x10000)
        memset(memory, 0, 0x10000)
        #expect(memory != nil)
        
        if let memory {
            testsData.withUnsafeBytes { (bytes: UnsafeRawBufferPointer) in
                let count = min(0x10000, bytes.count)
                if let base = bytes.baseAddress {
                    memcpy(memory, base, count)
                }
            }
            
             cpu = CPU6502(memory: MemoryWrapper(memory))
            
            // Need to determine what a successful completion looks like.
            await run()
        }
    }
}


