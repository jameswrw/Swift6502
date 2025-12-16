//
//  MiscTests.swift
//  Swift6502
//
//  Created by James Weatherley on 13/11/2025.
//

import Testing
@testable import Swift6502

struct MiscTests {
    @Test func testNOP() async throws {
        let (cpu, memory) = await initCPU()
        defer { memory.deallocate() }
        
        memory[0xA000] = Opcodes6502.NOP.rawValue

        await cpu.runForTicks(2)
        let a = await cpu.A
        let x = await cpu.X
        let y = await cpu.Y
        let sp = await cpu.SP
        let pc = await cpu.PC
        let f = await cpu.F

        #expect(a == 0)
        #expect(x == 0)
        #expect(y == 0)
        #expect(sp == 0xFF)
        #expect(pc == 0xA001)
        #expect(f == Flags.One.rawValue | Flags.I.rawValue)
    }
}
