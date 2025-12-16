//
//  RORTests.swift
//  Swift6502
//
//  Created by James Weatherley on 13/11/2025.
//

import Testing
@testable import Swift6502

struct RORTests {
    @Test func testROR_Accumulator() async throws {
        let (cpu, memory) = initCPU()
        defer { memory.deallocate() }
        
        // Simple right rotate.
        memory[0xA000] = Opcodes6502.ROR_Accumulator.rawValue
        cpu.A = 0x08
        
        await cpu.runForTicks(2)
        #expect(cpu.A == 0x04)
        #expect(await cpu.readFlag(.Z) == false)
        #expect(await cpu.readFlag(.N) == false)
        #expect(await cpu.readFlag(.C) == false)
        
        // Right rotate zero with carry flag initially unset.
        await cpu.reset()
        memory[0xA000] = Opcodes6502.ROR_Accumulator.rawValue
        cpu.A = 0x01
        
        await cpu.runForTicks(2)
        #expect(cpu.A == 0x00)
        #expect(await cpu.readFlag(.Z) == true)
        #expect(await cpu.readFlag(.N) == false)
        #expect(await cpu.readFlag(.C) == true)
        
        // Right rotate zero with carry flag initially set.
        await cpu.reset()
        memory[0xA000] = Opcodes6502.ROR_Accumulator.rawValue
        cpu.A = 0x01
        await cpu.setFlag(.C)
        
        await cpu.runForTicks(2)
        #expect(cpu.A == 0x80)
        #expect(await cpu.readFlag(.Z) == false)
        #expect(await cpu.readFlag(.N) == true)
        #expect(await cpu.readFlag(.C) == true)
        
        // Right rotate that sets the zero flag.
        await cpu.reset()
        memory[0xA000] = Opcodes6502.ROR_Accumulator.rawValue
        cpu.A = 0x00
        
        await cpu.runForTicks(2)
        #expect(cpu.A == 0x00)
        #expect(cpu.PC == 0xA001)
        #expect(await cpu.readFlag(.Z) == true)
        #expect(await cpu.readFlag(.N) == false)
        #expect(await cpu.readFlag(.C) == false)
    }
    
    @Test func testROR_ZeroPage() async throws {
        let (cpu, memory) = initCPU()
        defer { memory.deallocate() }
        
        // Simple right rotate.
        memory[0xA000] = Opcodes6502.ROR_ZeroPage.rawValue
        memory[0xA001] = 0xBB
        memory[0xBB] = 0x42
        
        await cpu.runForTicks(5)
        #expect(memory[0xBB] == 0x21)
        #expect(cpu.PC == 0xA002)
        #expect(await cpu.readFlag(.Z) == false)
        #expect(await cpu.readFlag(.N) == false)
        #expect(await cpu.readFlag(.C) == false)
        
        // Right rotate that sets negative and carry flag.
        await cpu.reset()
        memory[0xA000] = Opcodes6502.ROR_ZeroPage.rawValue
        memory[0xA001] = 0xBB
        memory[0xBB] = 0x01
        
        await cpu.runForTicks(5)
        #expect(memory[0xBB] == 0x00)
        #expect(cpu.PC == 0xA002)
        #expect(await cpu.readFlag(.Z) == true)
        #expect(await cpu.readFlag(.N) == false)
        #expect(await cpu.readFlag(.C) == true)
        
        // Right rotate that clears the negative flag.
        await cpu.reset()
        await cpu.setFlag(.N)
        memory[0xA000] = Opcodes6502.ROR_ZeroPage.rawValue
        memory[0xA001] = 0xBB
        memory[0xBB] = 0xFE
        
        await cpu.runForTicks(5)
        #expect(memory[0xBB] == 0x7F)
        #expect(cpu.PC == 0xA002)
        #expect(await cpu.readFlag(.Z) == false)
        #expect(await cpu.readFlag(.N) == false)
        #expect(await cpu.readFlag(.C) == false)
    }
    
    @Test func testROR_ZeroPageX() async throws {
        let (cpu, memory) = initCPU()
        defer { memory.deallocate() }
        
        // Simple right shift
        cpu.X = 0x0A
        memory[0xA000] = Opcodes6502.ROR_ZeroPageX.rawValue
        memory[0xA001] = 0x50
        memory[0x5A] = 0x04
        
        await cpu.runForTicks(6)
        #expect(memory[0x5A] == 0x02)
        #expect(cpu.PC == 0xA002)
        #expect(await cpu.readFlag(.Z) == false)
        #expect(await cpu.readFlag(.N) == false)
        #expect(await cpu.readFlag(.C) == false)
        
        // Right rotate that sets negative and carry flags.
        await cpu.reset()
        cpu.X = 0x0A
        memory[0xA000] = Opcodes6502.ROR_ZeroPageX.rawValue
        memory[0xA001] = 0x50
        memory[0x5A] = 0x01
        
        await cpu.runForTicks(6)
        #expect(memory[0x5A] == 0x00)
        #expect(cpu.PC == 0xA002)
        #expect(await cpu.readFlag(.Z) == true)
        #expect(await cpu.readFlag(.N) == false)
        #expect(await cpu.readFlag(.C) == true)
        
        // Right rotate that clears the negative flag.
        await cpu.reset()
        cpu.X = 0x0A
        await cpu.setFlag(.N)
        memory[0xA000] = Opcodes6502.ROR_ZeroPageX.rawValue
        memory[0xA001] = 0x50
        memory[0x5A] = 0xFE
        
        await cpu.runForTicks(6)
        #expect(memory[0x5A] == 0x7F)
        #expect(cpu.PC == 0xA002)
        #expect(await cpu.readFlag(.Z) == false)
        #expect(await cpu.readFlag(.N) == false)
        #expect(await cpu.readFlag(.C) == false)
    }
    
    @Test func testROR_Absolute() async throws {
        let (cpu, memory) = initCPU()
        defer { memory.deallocate() }
        
        // Simple right rotate.
        memory[0xA000] = Opcodes6502.ROR_Absolute.rawValue
        memory[0xA001] = 0x11
        memory[0xA002] = 0x22
        memory[0x2211] = 0x08
        
        await cpu.runForTicks(6)
        #expect(memory[0x2211] == 0x04)
        #expect(cpu.PC == 0xA003)
        #expect(await cpu.readFlag(.Z) == false)
        #expect(await cpu.readFlag(.N) == false)
        #expect(await cpu.readFlag(.C) == false)
        
        // Right rotate that sets negative and carry flags.
        await cpu.reset()
        memory[0xA000] = Opcodes6502.ROR_Absolute.rawValue
        memory[0xA001] = 0x11
        memory[0xA002] = 0x22
        memory[0x2211] = 0x01
        
        await cpu.runForTicks(6)
        #expect(memory[0x2211] == 0x00)
        #expect(cpu.PC == 0xA003)
        #expect(await cpu.readFlag(.Z) == true)
        #expect(await cpu.readFlag(.N) == false)
        #expect(await cpu.readFlag(.C) == true)
        
        // Right rotate that clears the negative flag.
        await cpu.reset()
        await cpu.setFlag(.N)
        memory[0xA000] = Opcodes6502.ROR_Absolute.rawValue
        memory[0xA001] = 0x11
        memory[0xA002] = 0x22
        memory[0x2211] = 0xFE
        
        await cpu.runForTicks(6)
        #expect(memory[0x2211] == 0x7F)
        #expect(cpu.PC == 0xA003)
        #expect(await cpu.readFlag(.Z) == false)
        #expect(await cpu.readFlag(.N) == false)
        #expect(await cpu.readFlag(.C) == false)
    }
    
    @Test func testROR_AbsoluteX() async throws {
        let (cpu, memory) = initCPU()
        defer { memory.deallocate() }
        
        // Simple left rotate
        cpu.X = 0xAA
        memory[0xA000] = Opcodes6502.ROR_AbsoluteX.rawValue
        memory[0xA001] = 0x50
        memory[0xA002] = 0x50
        memory[0x50FA] = 0x04
        
        await cpu.runForTicks(7)
        #expect(memory[0x50FA] == 0x02)
        #expect(cpu.PC == 0xA003)
        #expect(await cpu.readFlag(.Z) == false)
        #expect(await cpu.readFlag(.N) == false)
        #expect(await cpu.readFlag(.C) == false)
        
        // Right rotate that sets negative and carry flags.
        await cpu.reset()
        cpu.X = 0xAA
        memory[0xA000] = Opcodes6502.ROR_AbsoluteX.rawValue
        memory[0xA001] = 0x50
        memory[0xA002] = 0x50
        memory[0x50FA] = 0x01
        
        await cpu.runForTicks(7)
        #expect(memory[0x50FA] == 0x00)
        #expect(cpu.PC == 0xA003)
        #expect(await cpu.readFlag(.Z) == true)
        #expect(await cpu.readFlag(.N) == false)
        #expect(await cpu.readFlag(.C) == true)
        
        // Right rotate that clears the negative flag.
        await cpu.reset()
        cpu.X = 0xAA
        await cpu.setFlag(.N)
        memory[0xA000] = Opcodes6502.LSR_AbsoluteX.rawValue
        memory[0xA001] = 0x50
        memory[0xA002] = 0x50
        memory[0x50FA] = 0xFE
        
        await cpu.runForTicks(7)
        #expect(memory[0x50FA] == 0x7F)
        #expect(cpu.PC == 0xA003)
        #expect(await cpu.readFlag(.Z) == false)
        #expect(await cpu.readFlag(.N) == false)
        #expect(await cpu.readFlag(.C) == false)
    }
}
