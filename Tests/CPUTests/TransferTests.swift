//
//  TransferTests.swift
//  Swift6502
//
//  Created by James Weatherley on 13/11/2025.
//

import Testing
@testable import Swift6502

struct TransferTests {
    @Test func testTAX() async throws {
        let (cpu, memory) = initCPU()
        defer { memory.deallocate() }
        
        cpu.A = 0x64
        memory[0xA000] = Opcodes6502.TAX.rawValue

        await cpu.runForTicks(2)
        #expect(cpu.A == 0x64)
        #expect(cpu.X == 0x64)
        #expect(await cpu.readFlag(.Z) == false)
        #expect(await cpu.readFlag(.N) == false)
        
        await cpu.reset()
        cpu.A = 0x00
        cpu.X = 0x12
        memory[0xA000] = Opcodes6502.TAX.rawValue

        await cpu.runForTicks(2)
        #expect(cpu.A == 0)
        #expect(cpu.X == 0)
        #expect(await cpu.readFlag(.Z) == true)
        #expect(await cpu.readFlag(.N) == false)
        
        await cpu.reset()
        cpu.A = 0xFF
        memory[0xA000] = Opcodes6502.TAX.rawValue

        await cpu.runForTicks(2)
        #expect(cpu.A == 0xFF)
        #expect(cpu.X == 0xFF)
        #expect(await cpu.readFlag(.Z) == false)
        #expect(await cpu.readFlag(.N) == true)
    }
    
    @Test func testTXA() async throws {
        let (cpu, memory) = initCPU()
        defer { memory.deallocate() }
        
        cpu.X = 0x64
        memory[0xA000] = Opcodes6502.TXA.rawValue

        await cpu.runForTicks(2)
        #expect(cpu.A == 0x64)
        #expect(cpu.X == 0x64)
        #expect(await cpu.readFlag(.Z) == false)
        #expect(await cpu.readFlag(.N) == false)
        
        await cpu.reset()
        cpu.X = 0x00
        cpu.A = 0x12
        memory[0xA000] = Opcodes6502.TXA.rawValue

        await cpu.runForTicks(2)
        #expect(cpu.A == 0)
        #expect(cpu.X == 0)
        #expect(await cpu.readFlag(.Z) == true)
        #expect(await cpu.readFlag(.N) == false)
        
        await cpu.reset()
        cpu.A = 0x12
        cpu.X = 0xFF
        memory[0xA000] = Opcodes6502.TXA.rawValue

        await cpu.runForTicks(2)
        #expect(cpu.A == 0xFF)
        #expect(cpu.X == 0xFF)
        #expect(await cpu.readFlag(.Z) == false)
        #expect(await cpu.readFlag(.N) == true)
    }
    
    @Test func testTAY() async throws {
        let (cpu, memory) = initCPU()
        defer { memory.deallocate() }
        
        cpu.A = 0x64
        memory[0xA000] = Opcodes6502.TAY.rawValue

        await cpu.runForTicks(2)
        #expect(cpu.A == 0x64)
        #expect(cpu.Y == 0x64)
        #expect(await cpu.readFlag(.Z) == false)
        #expect(await cpu.readFlag(.N) == false)
        
        await cpu.reset()
        cpu.A = 0x00
        cpu.Y = 0x12
        memory[0xA000] = Opcodes6502.TAY.rawValue

        await cpu.runForTicks(2)
        #expect(cpu.A == 0)
        #expect(cpu.Y == 0)
        #expect(await cpu.readFlag(.Z) == true)
        #expect(await cpu.readFlag(.N) == false)
        
        await cpu.reset()
        cpu.A = 0xFF
        memory[0xA000] = Opcodes6502.TAY.rawValue

        await cpu.runForTicks(2)
        #expect(cpu.A == 0xFF)
        #expect(cpu.Y == 0xFF)
        #expect(await cpu.readFlag(.Z) == false)
        #expect(await cpu.readFlag(.N) == true)
    }
    
    @Test func testTYA() async throws {
        let (cpu, memory) = initCPU()
        defer { memory.deallocate() }
        
        cpu.Y = 0x64
        memory[0xA000] = Opcodes6502.TYA.rawValue

        await cpu.runForTicks(2)
        #expect(cpu.A == 0x64)
        #expect(cpu.Y == 0x64)
        #expect(await cpu.readFlag(.Z) == false)
        #expect(await cpu.readFlag(.N) == false)
        
        await cpu.reset()
        cpu.Y = 0x00
        cpu.A = 0x12
        memory[0xA000] = Opcodes6502.TYA.rawValue

        await cpu.runForTicks(2)
        #expect(cpu.A == 0)
        #expect(cpu.Y == 0)
        #expect(await cpu.readFlag(.Z) == true)
        #expect(await cpu.readFlag(.N) == false)
        
        await cpu.reset()
        cpu.A = 0x12
        cpu.Y = 0xFF
        memory[0xA000] = Opcodes6502.TYA.rawValue

        await cpu.runForTicks(2)
        #expect(cpu.A == 0xFF)
        #expect(cpu.Y == 0xFF)
        #expect(await cpu.readFlag(.Z) == false)
        #expect(await cpu.readFlag(.N) == true)
    }
}
