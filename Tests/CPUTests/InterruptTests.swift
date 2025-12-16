//
//  InterruptTests.swift
//  Swift6502
//
//  Created by James Weatherley on 20/11/2025.
//

import Testing
@testable import Swift6502

struct interruptTests {
    
    @Test func testRTI() async throws {
        let (cpu, memory) = await initCPU()
        defer { memory.deallocate() }
        
        let oldFlags = await cpu.F
        await cpu.setF(0xAA)
        await cpu.pushWord(0x5678)
        await cpu.pushByte(oldFlags)
        memory[0xA000] = Opcodes6502.RTI.rawValue
        
        await cpu.runForTicks(6)
        let f = await cpu.F
        let pc = await cpu.PC

        #expect(f == oldFlags)
        #expect(pc == 0x5678)
    }
    
    @Test func testBRK() async throws {
        let (cpu, memory) = await initCPU()
        defer { memory.deallocate() }
        
        let irqVector = await cpu.irqVector
        
        memory[0xA000] = Opcodes6502.BRK.rawValue
        memory[Int(irqVector)] = 0x00
        memory[Int(irqVector + 1)] = 0x20
        
        await cpu.runForTicks(7)
        let pc = await cpu.PC

        #expect(pc == 0x2000)
    }
    
    @Test func testBRK_RTI() async throws {
        let (cpu, memory) = await initCPU()
        defer { memory.deallocate() }
        
        let irqVector = await cpu.irqVector

        memory[0xA000] = Opcodes6502.BRK.rawValue
        memory[Int(irqVector)] = 0x00
        memory[Int(irqVector + 1)] = 0x20
        memory[0x2000] = Opcodes6502.RTI.rawValue
        
        await cpu.runForTicks(7)
        let pc1 = await cpu.PC

        #expect(pc1 == 0x2000)
        
        await cpu.runForTicks(6)
        let pc2 = await cpu.PC

        #expect(pc2 == 0xA002)
    }
}
