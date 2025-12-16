//
//  IncrementMemoryTests.swift
//  Swift6502
//
//  Created by James Weatherley on 13/11/2025.
//

import Testing
@testable import Swift6502

struct IncrementMemoryTests {
    @Test func testINC_ZeroPage() async throws {
        let (cpu, memory) = await initCPU()
        defer { memory.deallocate() }
        
        // Simple increment.
        memory[0xA000] = Opcodes6502.INC_ZeroPage.rawValue
        memory[0xA001] = 0x42
        memory[0x42] = 0x00
        
        await cpu.runForTicks(5)
        
        var pc = await cpu.PC
        var zFlag = await cpu.readFlag(.Z)
        var nFlag = await cpu.readFlag(.N)
        
        #expect(pc == 0xA002)
        #expect(memory[0x42] == 1)
        #expect(zFlag == false)
        #expect(nFlag == false)

        // Increment that sets the N flag.
        await cpu.reset()
        memory[0xA000] = Opcodes6502.INC_ZeroPage.rawValue
        memory[0xA001] = 0x42
        memory[0x42] = 0x7F

        await cpu.runForTicks(5)
        
        pc = await cpu.PC
        zFlag = await cpu.readFlag(.Z)
        nFlag = await cpu.readFlag(.N)
        
        #expect(pc == 0xA002)
        #expect(memory[0x42] == 0x80)
        #expect(zFlag == false)
        #expect(nFlag == true)
        
        // Increment that sets the Z flag.
        await cpu.reset()
        memory[0xA000] = Opcodes6502.INC_ZeroPage.rawValue
        memory[0xA001] = 0x42
        memory[0x42] = 0xFF

        await cpu.runForTicks(5)
        
        pc = await cpu.PC
        zFlag = await cpu.readFlag(.Z)
        nFlag = await cpu.readFlag(.N)
        
        #expect(pc == 0xA002)
        #expect(memory[0x42] == 0x00)
        #expect(zFlag == true)
        #expect(nFlag == false)
    }
    
    @Test func testINC_ZeroPageX() async throws {
        let (cpu, memory) = await initCPU()
        defer { memory.deallocate() }
        
        // Simple increment.
        memory[0xA000] = Opcodes6502.INC_ZeroPageX.rawValue
        memory[0xA001] = 0x70
        await cpu.setX(0x03)
        memory[0x73] = 0x00
        
        await cpu.runForTicks(6)
        
        var pc = await cpu.PC
        var zFlag = await cpu.readFlag(.Z)
        var nFlag = await cpu.readFlag(.N)
        
        #expect(pc == 0xA002)
        #expect(memory[0x73] == 0x1)
        #expect(zFlag == false)
        #expect(nFlag == false)

        // Increment that sets the N flag.
        await cpu.reset()
        memory[0xA000] = Opcodes6502.INC_ZeroPageX.rawValue
        memory[0xA001] = 0x70
        await cpu.setX(0x03)
        memory[0x73] = 0x7F

        await cpu.runForTicks(6)
        
        pc = await cpu.PC
        zFlag = await cpu.readFlag(.Z)
        nFlag = await cpu.readFlag(.N)
        
        #expect(pc == 0xA002)
        #expect(memory[0x73] == 0x80)
        #expect(zFlag == false)
        #expect(nFlag == true)
        
        // Increment that sets the Z flag.
        await cpu.reset()
        memory[0xA000] = Opcodes6502.INC_ZeroPageX.rawValue
        memory[0xA001] = 0x70
        await cpu.setX(0x03)
        memory[0x73] = 0xFF

        await cpu.runForTicks(6)
        
        pc = await cpu.PC
        zFlag = await cpu.readFlag(.Z)
        nFlag = await cpu.readFlag(.N)
        
        #expect(pc == 0xA002)
        #expect(memory[0x73] == 0x00)
        #expect(zFlag == true)
        #expect(nFlag == false)
        
        // Increment that checks that (opcode argument + X) wraps around.
        await cpu.reset()
        memory[0xA000] = Opcodes6502.INC_ZeroPageX.rawValue
        memory[0xA001] = 0xFF
        await cpu.setX(0x74)
        memory[0x73] = 0x00
        
        await cpu.runForTicks(6)
        
        pc = await cpu.PC
        zFlag = await cpu.readFlag(.Z)
        nFlag = await cpu.readFlag(.N)
        
        #expect(pc == 0xA002)
        #expect(memory[0x73] == 0x01)
        #expect(zFlag == false)
        #expect(nFlag == false)
        
    }
    
    @Test func testINC_Absolute() async throws {
        let (cpu, memory) = await initCPU()
        defer { memory.deallocate() }
        
        // Simple increment.
        memory[0xA000] = Opcodes6502.INC_Absolute.rawValue
        memory[0xA001] = 0x73
        memory[0xA002] = 0x19
        memory[0x1973] = 0x00
        
        await cpu.runForTicks(6)
        
        var pc = await cpu.PC
        var zFlag = await cpu.readFlag(.Z)
        var nFlag = await cpu.readFlag(.N)
        
        #expect(pc == 0xA003)
        #expect(memory[0x1973] == 1)
        #expect(zFlag == false)
        #expect(nFlag == false)

        // Increment that sets the N flag.
        await cpu.reset()
        memory[0xA000] = Opcodes6502.INC_Absolute.rawValue
        memory[0xA001] = 0x73
        memory[0xA002] = 0x19
        memory[0x1973] = 0x7F

        await cpu.runForTicks(6)
        
        pc = await cpu.PC
        zFlag = await cpu.readFlag(.Z)
        nFlag = await cpu.readFlag(.N)
    
        #expect(pc == 0xA003)
        #expect(memory[0x1973] == 0x80)
        #expect(zFlag == false)
        #expect(nFlag == true)
        
        // Increment that sets the Z flag.
        await cpu.reset()
        memory[0xA000] = Opcodes6502.INC_Absolute.rawValue
        memory[0xA001] = 0x73
        memory[0xA002] = 0x19
        memory[0x1973] = 0xFF

        await cpu.runForTicks(6)
        
        pc = await cpu.PC
        zFlag = await cpu.readFlag(.Z)
        nFlag = await cpu.readFlag(.N)
        
        #expect(pc == 0xA003)
        #expect(memory[0x1973] == 0x00)
        #expect(zFlag == true)
        #expect(nFlag == false)
    }
    
    @Test func testINC_AbsoluteX() async throws {
        let (cpu, memory) = await initCPU()
        defer { memory.deallocate() }
        
        // Simple increment.
        memory[0xA000] = Opcodes6502.INC_AbsoluteX.rawValue
        memory[0xA001] = 0x00
        memory[0xA002] = 0xF0
        await cpu.setX(0x0D)
        memory[0xF00D] = 0x00
        
        await cpu.runForTicks(7)
        
        var pc = await cpu.PC
        var zFlag = await cpu.readFlag(.Z)
        var nFlag = await cpu.readFlag(.N)
        
        #expect(pc == 0xA003)
        #expect(memory[0xF00D] == 1)
        #expect(zFlag == false)
        #expect(nFlag == false)

        // Increment that sets the N flag.
        await cpu.reset()
        memory[0xA000] = Opcodes6502.INC_AbsoluteX.rawValue
        memory[0xA001] = 0x00
        memory[0xA002] = 0xF0
        await cpu.setX(0x0D)
        memory[0xF00D] = 0x7F

        await cpu.runForTicks(7)
        
        pc = await cpu.PC
        zFlag = await cpu.readFlag(.Z)
        nFlag = await cpu.readFlag(.N)
        
        #expect(pc == 0xA003)
        #expect(memory[0xF00D] == 0x80)
        #expect(zFlag == false)
        #expect(nFlag == true)
        
        // Increment that sets the Z flag.
        await cpu.reset()
        memory[0xA000] = Opcodes6502.INC_AbsoluteX.rawValue
        memory[0xA001] = 0x00
        memory[0xA002] = 0xF0
        await cpu.setX(0x0D)
        memory[0xF00D] = 0xFF

        await cpu.runForTicks(7)
        
        pc = await cpu.PC
        zFlag = await cpu.readFlag(.Z)
        nFlag = await cpu.readFlag(.N)
        
        #expect(pc == 0xA003)
        #expect(memory[0xF00D] == 0x00)
        #expect(zFlag == true)
        #expect(nFlag == false)
    
        // Increment that checks that (opcode argument + X) wraps around.
        await cpu.reset()
        memory[0xA000] = Opcodes6502.INC_AbsoluteX.rawValue
        memory[0xA001] = 0xFF
        memory[0xA002] = 0xFF
        await cpu.setX(0x12)
        memory[0x11] = 0x00
        
        await cpu.runForTicks(7)
        
        pc = await cpu.PC
        zFlag = await cpu.readFlag(.Z)
        nFlag = await cpu.readFlag(.N)
        
        #expect(pc == 0xA003)
        #expect(memory[0x11] == 0x01)
        #expect(zFlag == false)
        #expect(nFlag == false)
    }
}
