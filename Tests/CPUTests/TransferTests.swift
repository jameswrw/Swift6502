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
        
        await cpu.setA(0x64)
        memory[0xA000] = Opcodes6502.TAX.rawValue

        await cpu.runForTicks(2)
        #expect(cpu.A == 0x64)
        #expect(cpu.X == 0x64)
        #expect( cpu.readFlag(.Z) == false)
        #expect( cpu.readFlag(.N) == false)
        
        await cpu.reset()
        await cpu.setA(0x00)
        await cpu.setX(0x12)
        memory[0xA000] = Opcodes6502.TAX.rawValue

        await cpu.runForTicks(2)
        #expect(cpu.A == 0)
        #expect(cpu.X == 0)
        #expect( cpu.readFlag(.Z) == true)
        #expect( cpu.readFlag(.N) == false)
        
        await cpu.reset()
        await cpu.setA(0xFF)
        memory[0xA000] = Opcodes6502.TAX.rawValue

        await cpu.runForTicks(2)
        #expect(cpu.A == 0xFF)
        #expect(cpu.X == 0xFF)
        #expect( cpu.readFlag(.Z) == false)
        #expect( cpu.readFlag(.N) == true)
    }
    
    @Test func testTXA() async throws {
        let (cpu, memory) = initCPU()
        defer { memory.deallocate() }
        
        await cpu.setX(0x64)
        memory[0xA000] = Opcodes6502.TXA.rawValue

        await cpu.runForTicks(2)
        #expect(cpu.A == 0x64)
        #expect(cpu.X == 0x64)
        #expect( cpu.readFlag(.Z) == false)
        #expect( cpu.readFlag(.N) == false)
        
        await cpu.reset()
        await cpu.setX(0x00)
        await cpu.setA(0x12)
        memory[0xA000] = Opcodes6502.TXA.rawValue

        await cpu.runForTicks(2)
        #expect(cpu.A == 0)
        #expect(cpu.X == 0)
        #expect( cpu.readFlag(.Z) == true)
        #expect( cpu.readFlag(.N) == false)
        
        await cpu.reset()
        await cpu.setA(0x12)
        await cpu.setX(0xFF)
        memory[0xA000] = Opcodes6502.TXA.rawValue

        await cpu.runForTicks(2)
        #expect(cpu.A == 0xFF)
        #expect(cpu.X == 0xFF)
        #expect( cpu.readFlag(.Z) == false)
        #expect( cpu.readFlag(.N) == true)
    }
    
    @Test func testTAY() async throws {
        let (cpu, memory) = initCPU()
        defer { memory.deallocate() }
        
        await cpu.setA(0x64)
        memory[0xA000] = Opcodes6502.TAY.rawValue

        await cpu.runForTicks(2)
        #expect(cpu.A == 0x64)
        #expect(cpu.Y == 0x64)
        #expect( cpu.readFlag(.Z) == false)
        #expect( cpu.readFlag(.N) == false)
        
        await cpu.reset()
        await cpu.setA(0x00)
        await cpu.setY(0x12)
        memory[0xA000] = Opcodes6502.TAY.rawValue

        await cpu.runForTicks(2)
        #expect(cpu.A == 0)
        #expect(cpu.Y == 0)
        #expect( cpu.readFlag(.Z) == true)
        #expect( cpu.readFlag(.N) == false)
        
        await cpu.reset()
        await cpu.setA(0xFF)
        memory[0xA000] = Opcodes6502.TAY.rawValue

        await cpu.runForTicks(2)
        #expect(cpu.A == 0xFF)
        #expect(cpu.Y == 0xFF)
        #expect( cpu.readFlag(.Z) == false)
        #expect( cpu.readFlag(.N) == true)
    }
    
    @Test func testTYA() async throws {
        let (cpu, memory) = initCPU()
        defer { memory.deallocate() }
        
        await cpu.setY(0x64)
        memory[0xA000] = Opcodes6502.TYA.rawValue

        await cpu.runForTicks(2)
        #expect(cpu.A == 0x64)
        #expect(cpu.Y == 0x64)
        #expect( cpu.readFlag(.Z) == false)
        #expect( cpu.readFlag(.N) == false)
        
        await cpu.reset()
        await cpu.setY(0x00)
        await cpu.setA(0x12)
        memory[0xA000] = Opcodes6502.TYA.rawValue

        await cpu.runForTicks(2)
        #expect(cpu.A == 0)
        #expect(cpu.Y == 0)
        #expect( cpu.readFlag(.Z) == true)
        #expect( cpu.readFlag(.N) == false)
        
        await cpu.reset()
        await cpu.setA(0x12)
        await cpu.setY(0xFF)
        memory[0xA000] = Opcodes6502.TYA.rawValue

        await cpu.runForTicks(2)
        #expect(cpu.A == 0xFF)
        #expect(cpu.Y == 0xFF)
        #expect( cpu.readFlag(.Z) == false)
        #expect( cpu.readFlag(.N) == true)
    }
}
