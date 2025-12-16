//
//  IncrementRegisterTests.swift
//  Swift6502
//
//  Created by James Weatherley on 13/11/2025.
//

import Testing
@testable import Swift6502

struct IncrementRegisterTests {
    @Test func testINX() async throws {
        let (cpu, memory) = initCPU()
        defer { memory.deallocate() }
        
        memory[0xA000] = Opcodes6502.INX.rawValue
        await cpu.setX(0x64)

        await cpu.runForTicks(2)
        #expect(cpu.X == 0x65)
        #expect( cpu.readFlag(.Z) == false)
        #expect( cpu.readFlag(.N) == false)
        
        await cpu.reset()
        memory[0xA000] = Opcodes6502.INX.rawValue
        await cpu.setX(0xFF)

        await cpu.runForTicks(2)
        #expect(cpu.X == 0x00)
        #expect( cpu.readFlag(.Z) == true)
        #expect( cpu.readFlag(.N) == false)
        
        await cpu.reset()
        memory[0xA000] = Opcodes6502.INX.rawValue
        await cpu.setX(0x7F)

        await cpu.runForTicks(2)
        #expect(cpu.X == 0x80)
        #expect( cpu.readFlag(.Z) == false)
        #expect( cpu.readFlag(.N) == true)
    }
    
    @Test func testINY() async throws {
        let (cpu, memory) = initCPU()
        defer { memory.deallocate() }
        
        memory[0xA000] = Opcodes6502.INY.rawValue
        await cpu.setY(0x64)

        await cpu.runForTicks(2)
        #expect(cpu.Y == 0x65)
        #expect( cpu.readFlag(.Z) == false)
        #expect( cpu.readFlag(.N) == false)
        
        await cpu.reset()
        memory[0xA000] = Opcodes6502.INY.rawValue
        await cpu.setY(0xFF)

        await cpu.runForTicks(2)
        #expect(cpu.Y == 0x00)
        #expect( cpu.readFlag(.Z) == true)
        #expect( cpu.readFlag(.N) == false)
        
        await cpu.reset()
        memory[0xA000] = Opcodes6502.INY.rawValue
        await cpu.setY(0x7F)

        await cpu.runForTicks(2)
        #expect(cpu.Y == 0x80)
        #expect( cpu.readFlag(.Z) == false)
        #expect( cpu.readFlag(.N) == true)
    }
}
