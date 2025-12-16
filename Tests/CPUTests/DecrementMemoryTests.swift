//
//  DecrementMemoryTests.swift
//  Swift6502
//
//  Created by James Weatherley on 13/11/2025.
//

import Testing
@testable import Swift6502

struct DecrementMemoryTests {
    @Test func testDEC_ZeroPage() async throws {
        let (cpu, memory) = initCPU()
        defer { memory.deallocate() }
        
        // Simple decrement.
        memory[0xA000] = Opcodes6502.DEC_ZeroPage.rawValue
        memory[0xA001] = 0x42
        memory[0x42] = 0x0A
        
        await cpu.runForTicks(5)
        #expect(cpu.PC == 0xA002)
        #expect(memory[0x42] == 0x09)
        #expect(await cpu.readFlag(.Z) == false)
        #expect(await cpu.readFlag(.N) == false)

        // Decrement that sets the N flag.
        await cpu.reset()
        memory[0xA000] = Opcodes6502.DEC_ZeroPage.rawValue
        memory[0xA001] = 0x42
        memory[0x42] = 0x88

        await cpu.runForTicks(5)
        #expect(cpu.PC == 0xA002)
        #expect(memory[0x42] == 0x87)
        #expect(await cpu.readFlag(.Z) == false)
        #expect(await cpu.readFlag(.N) == true)
        
        // Decrement that sets the Z flag.
        await cpu.reset()
        memory[0xA000] = Opcodes6502.DEC_ZeroPage.rawValue
        memory[0xA001] = 0x42
        memory[0x42] = 0x01

        await cpu.runForTicks(5)
        #expect(cpu.PC == 0xA002)
        #expect(memory[0x42] == 0x00)
        #expect(await cpu.readFlag(.Z) == true)
        #expect(await cpu.readFlag(.N) == false)
    }
    
    @Test func testDEC_ZeroPageX() async throws {
        let (cpu, memory) = initCPU()
        defer { memory.deallocate() }
        
        // Simple decrement.
        memory[0xA000] = Opcodes6502.DEC_ZeroPageX.rawValue
        memory[0xA001] = 0x70
        cpu.X = 0x03
        memory[0x73] = 0x0A
        
        await cpu.runForTicks(6)
        #expect(cpu.PC == 0xA002)
        #expect(memory[0x73] == 0x09)
        #expect(await cpu.readFlag(.Z) == false)
        #expect(await cpu.readFlag(.N) == false)

        // Decrement that sets the N flag.
        await cpu.reset()
        memory[0xA000] = Opcodes6502.DEC_ZeroPageX.rawValue
        memory[0xA001] = 0x70
        cpu.X = 0x03
        memory[0x73] = 0x88

        await cpu.runForTicks(6)
        #expect(cpu.PC == 0xA002)
        #expect(memory[0x73] == 0x87)
        #expect(await cpu.readFlag(.Z) == false)
        #expect(await cpu.readFlag(.N) == true)
        
        // Decrement that sets the Z flag.
        await cpu.reset()
        memory[0xA000] = Opcodes6502.DEC_ZeroPageX.rawValue
        memory[0xA001] = 0x70
        cpu.X = 0x03
        memory[0x73] = 0x01

        await cpu.runForTicks(6)
        #expect(cpu.PC == 0xA002)
        #expect(memory[0x73] == 0x00)
        #expect(await cpu.readFlag(.Z) == true)
        #expect(await cpu.readFlag(.N) == false)
        
        // Decrement that checks that (opcode argument + X) wraps around.
        await cpu.reset()
        memory[0xA000] = Opcodes6502.DEC_ZeroPageX.rawValue
        memory[0xA001] = 0xFF
        cpu.X = 0x74
        memory[0x73] = 0x00
        
        await cpu.runForTicks(6)
        #expect(cpu.PC == 0xA002)
        #expect(memory[0x73] == 0xFF)
        #expect(await cpu.readFlag(.Z) == false)
        #expect(await cpu.readFlag(.N) == true)
    }
    
    @Test func testDEC_Absolute() async throws {
        let (cpu, memory) = initCPU()
        defer { memory.deallocate() }
        
        // Simple decrement.
        memory[0xA000] = Opcodes6502.DEC_Absolute.rawValue
        memory[0xA001] = 0x73
        memory[0xA002] = 0x19
        memory[0x1973] = 0x0A
        
        await cpu.runForTicks(6)
        #expect(cpu.PC == 0xA003)
        #expect(memory[0x1973] == 0x09)
        #expect(await cpu.readFlag(.Z) == false)
        #expect(await cpu.readFlag(.N) == false)

        // Decrement that sets the N flag.
        await cpu.reset()
        memory[0xA000] = Opcodes6502.DEC_Absolute.rawValue
        memory[0xA001] = 0x73
        memory[0xA002] = 0x19
        memory[0x1973] = 0x88

        await cpu.runForTicks(6)
        #expect(cpu.PC == 0xA003)
        #expect(memory[0x1973] == 0x87)
        #expect(await cpu.readFlag(.Z) == false)
        #expect(await cpu.readFlag(.N) == true)
        
        // Decrement that sets the Z flag.
        await cpu.reset()
        memory[0xA000] = Opcodes6502.DEC_Absolute.rawValue
        memory[0xA001] = 0x73
        memory[0xA002] = 0x19
        memory[0x1973] = 0x01

        await cpu.runForTicks(6)
        #expect(cpu.PC == 0xA003)
        #expect(memory[0x1973] == 0x00)
        #expect(await cpu.readFlag(.Z) == true)
        #expect(await cpu.readFlag(.N) == false)
    }
    
    @Test func testDEC_AbsoluteX() async throws {
        let (cpu, memory) = initCPU()
        defer { memory.deallocate() }
        
        // Simple decrement.
        memory[0xA000] = Opcodes6502.DEC_AbsoluteX.rawValue
        memory[0xA001] = 0x00
        memory[0xA002] = 0xF0
        cpu.X = 0x0D
        memory[0xF00D] = 0x66
        
        await cpu.runForTicks(7)
        #expect(cpu.PC == 0xA003)
        #expect(memory[0xF00D] == 0x65)
        #expect(await cpu.readFlag(.Z) == false)
        #expect(await cpu.readFlag(.N) == false)

        // Decrement that sets the N flag.
        await cpu.reset()
        memory[0xA000] = Opcodes6502.DEC_AbsoluteX.rawValue
        memory[0xA001] = 0x00
        memory[0xA002] = 0xF0
        cpu.X = 0x0D
        memory[0xF00D] = 0x99

        await cpu.runForTicks(7)
        #expect(cpu.PC == 0xA003)
        #expect(memory[0xF00D] == 0x98)
        #expect(await cpu.readFlag(.Z) == false)
        #expect(await cpu.readFlag(.N) == true)
        
        // Decrement that sets the Z flag.
        await cpu.reset()
        memory[0xA000] = Opcodes6502.DEC_AbsoluteX.rawValue
        memory[0xA001] = 0x00
        memory[0xA002] = 0xF0
        cpu.X = 0x0D
        memory[0xF00D] = 0x01

        await cpu.runForTicks(7)
        #expect(cpu.PC == 0xA003)
        #expect(memory[0xF00D] == 0x00)
        #expect(await cpu.readFlag(.Z) == true)
        #expect(await cpu.readFlag(.N) == false)
        
        // Decrement that checks that (opcode argument + X) wraps around.
        await cpu.reset()
        memory[0xA000] = Opcodes6502.DEC_AbsoluteX.rawValue
        memory[0xA001] = 0xFF
        memory[0xA002] = 0xFF
        cpu.X = 0x12
        memory[0x11] = 0x36
        
        await cpu.runForTicks(7)
        #expect(cpu.PC == 0xA003)
        #expect(memory[0x11] == 0x35)
        #expect(await cpu.readFlag(.Z) == false)
        #expect(await cpu.readFlag(.N) == false)
    }
}
