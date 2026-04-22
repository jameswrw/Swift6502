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
    
    @Test func testInvalidOpcodeHaltsExecutionAndCapturesTrap() async throws {
        let (cpu, memory) = await initCPU()
        defer { memory.deallocate() }
        
        memory[0xA000] = 0xFF
        memory[0xA001] = Opcodes6502.LDA_Immediate.rawValue
        memory[0xA002] = 0x42
        
        await cpu.runForTicks(10)
        
        let trap = await cpu.invalidOpcodeTrap
        let isHalted = await cpu.isHalted
        let tickcount = await cpu.tickcount
        let pc = await cpu.PC
        let a = await cpu.A
        
        #expect(trap == InvalidOpcodeTrap(opcode: 0xFF, address: 0xA000))
        #expect(isHalted == true)
        #expect(tickcount == 0)
        #expect(pc == 0xA001)
        #expect(a == 0)
        
        await cpu.runForTicks(2)
        let tickcountAfterSecondRun = await cpu.tickcount
        let pcAfterSecondRun = await cpu.PC
        
        #expect(tickcountAfterSecondRun == 0)
        #expect(pcAfterSecondRun == 0xA001)
    }
}
