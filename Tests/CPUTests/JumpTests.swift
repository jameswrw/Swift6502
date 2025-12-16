//
//  JumpTests.swift
//  Swift6502
//
//  Created by James Weatherley on 13/11/2025.
//

import Testing
@testable import Swift6502

struct JumpTests {
    @Test func testJMP_Absolute() async throws {
        let (cpu, memory) = await initCPU()
        defer { memory.deallocate() }
        
        memory[0xA000] = Opcodes6502.JMP_Absolute.rawValue
        memory[0xA001] = 0x34
        memory[0xA002] = 0x12
        memory[0x1234] = Opcodes6502.LDA_Immediate.rawValue
        memory[0x1235] = 0xAA
        
        await cpu.runForTicks(3)
        let pc1 = await cpu.PC

        #expect(pc1 == 0x1234)
        
        await cpu.runForTicks(2)
        let a = await cpu.A
        let nFlag = await cpu.readFlag(.N)

        #expect(a == 0xAA)
        #expect(nFlag == true)
    }
    
    @Test func testJMP_Indirect() async throws {
        let (cpu, memory) = await initCPU()
        defer { memory.deallocate() }

        memory[0xA000] = Opcodes6502.JMP_Indirect.rawValue
        memory[0xA001] = 0x34
        memory[0xA002] = 0x12
        memory[0x1234] = 0x78
        memory[0x1235] = 0x56
        memory[0x5678] = Opcodes6502.LDA_Immediate.rawValue
        memory[0x5679] = 0x42
        
        await cpu.runForTicks(3)
        let pc1 = await cpu.PC

        #expect(pc1 == 0x5678)
        
        await cpu.runForTicks(2)
        let a = await cpu.A
        let f = await cpu.F

        #expect(a == 0x42)
        #expect(f == Flags.One.rawValue | Flags.I.rawValue)
    }
    
    @Test func testJSR_RTS() async throws {
        let (cpu, memory) = await initCPU()
        defer { memory.deallocate() }
        
        // Not much space at the rest vector, so:
        // • JMP to 0x1234
        // • JSR to 0x5578
        // • RTS should take us to 0x1237 - i.e. an advance of one from where we jumped from.
        memory[0xA000] = Opcodes6502.JMP_Absolute.rawValue
        memory[0xA001] = 0x34
        memory[0xA002] = 0x12
        memory[0x1234] = Opcodes6502.JSR.rawValue
        memory[0x1235] = 0x78
        memory[0x1236] = 0x56
        memory[0x5678] = Opcodes6502.RTS.rawValue

        // JMP 0x1234
        await cpu.runForTicks(3)
        let pcAfterJmp = await cpu.PC
        let spAfterJmp = await cpu.SP

        #expect(pcAfterJmp == 0x1234)
        #expect(spAfterJmp == 0xFF)

        // JSR 0x5678
        await cpu.runForTicks(6)
        let pcAfterJsr = await cpu.PC
        let spAfterJsr = await cpu.SP

        #expect(pcAfterJsr == 0x5678)
        #expect(spAfterJsr == 0xFD)

        // RTS
        await cpu.runForTicks(6)
        let pcAfterRts = await cpu.PC
        let spAfterRts = await cpu.SP

        #expect(pcAfterRts == 0x1237)
        #expect(spAfterRts == 0xFF)
    }
}

