//
//  DecrementRegisterTests.swift
//  Swift6502
//
//  Created by James Weatherley on 13/11/2025.
//

import Testing
@testable import Swift6502

struct DecrementRegisterTests {
    @Test func testDEX() async throws {
        let (cpu, memory) = initCPU()
        defer { memory.deallocate() }
        
        memory[0xA000] = Opcodes6502.DEX.rawValue
        cpu.X = 0x64

        await cpu.runForTicks(2)
        #expect(cpu.X == 0x63)
        #expect(await cpu.readFlag(.Z) == false)
        #expect(await cpu.readFlag(.N) == false)
        
        await cpu.reset()
        memory[0xA000] = Opcodes6502.DEX.rawValue
        cpu.X = 0x00

        await cpu.runForTicks(2)
        #expect(cpu.X == 0xFF)
        #expect(await cpu.readFlag(.Z) == false)
        #expect(await cpu.readFlag(.N) == true)
        
        await cpu.reset()
        memory[0xA000] = Opcodes6502.DEX.rawValue
        cpu.X = 0x01

        await cpu.runForTicks(2)
        #expect(cpu.X == 0x00)
        #expect(await cpu.readFlag(.Z) == true)
        #expect(await cpu.readFlag(.N) == false)
    }
    
    @Test func testDEY() async throws {
        let (cpu, memory) = initCPU()
        defer { memory.deallocate() }
        
        cpu.Y = 0x64
        memory[0xA000] = Opcodes6502.DEY.rawValue

        await cpu.runForTicks(2)
        #expect(cpu.Y == 0x63)
        #expect(await cpu.readFlag(.Z) == false)
        #expect(await cpu.readFlag(.N) == false)
        
        await cpu.reset()
        memory[0xA000] = Opcodes6502.DEY.rawValue
        cpu.Y = 0x00

        await cpu.runForTicks(2)
        #expect(cpu.Y == 0xFF)
        #expect(await cpu.readFlag(.Z) == false)
        #expect(await cpu.readFlag(.N) == true)
        
        await cpu.reset()
        memory[0xA000] = Opcodes6502.DEY.rawValue
        cpu.Y = 0x01

        await cpu.runForTicks(2)
        #expect(cpu.Y == 0x00)
        #expect(await cpu.readFlag(.Z) == true)
        #expect(await cpu.readFlag(.N) == false)
    }
}
