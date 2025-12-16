//
//  ROLTests.swift
//  Swift6502
//
//  Created by James Weatherley on 13/11/2025.
//

import Testing
@testable import Swift6502

struct ROLTests {
    @Test func testROL_Accumulator() async throws {
        let (cpu, memory) = initCPU()
        defer { memory.deallocate() }
        
        // Simple left rotate.
        memory[0xA000] = Opcodes6502.ROL_Accumulator.rawValue
        cpu.A = 0x01
        
        await cpu.runForTicks(2)
        #expect(cpu.A == 0x02)
        #expect(await cpu.readFlag(.Z) == false)
        #expect(await cpu.readFlag(.N) == false)
        #expect(await cpu.readFlag(.C) == false)
        
        // Left rotate that sets carry flag which is initially unset.
        await cpu.reset()
        memory[0xA000] = Opcodes6502.ROL_Accumulator.rawValue
        cpu.A = 0x80
        
        await cpu.runForTicks(2)
        #expect(cpu.A == 0x00)
        #expect(await cpu.readFlag(.Z) == true)
        #expect(await cpu.readFlag(.N) == false)
        #expect(await cpu.readFlag(.C) == true)
        
        // Left rotate that sets carry flag which is initially set.
        await cpu.reset()
        memory[0xA000] = Opcodes6502.ROL_Accumulator.rawValue
        cpu.A = 0x80
        await cpu.setFlag(.C)
        
        await cpu.runForTicks(2)
        #expect(cpu.A == 0x01)
        #expect(await cpu.readFlag(.Z) == false)
        #expect(await cpu.readFlag(.N) == false)
        #expect(await cpu.readFlag(.C) == true)
        
        // Left rotate that sets negative flag.
        await cpu.reset()
        memory[0xA000] = Opcodes6502.ROL_Accumulator.rawValue
        cpu.A = 0x42
        
        await cpu.runForTicks(2)
        #expect(cpu.A == 0x84)
        #expect(cpu.PC == 0xA001)
        #expect(await cpu.readFlag(.Z) == false)
        #expect(await cpu.readFlag(.N) == true)
        #expect(await cpu.readFlag(.C) == false)
        
        // Left rotate that sets zero flag.
        await cpu.reset()
        memory[0xA000] = Opcodes6502.ROL_Accumulator.rawValue
        cpu.A = 0x00
        
        await cpu.runForTicks(2)
        #expect(cpu.A == 0x00)
        #expect(cpu.PC == 0xA001)
        #expect(await cpu.readFlag(.Z) == true)
        #expect(await cpu.readFlag(.N) == false)
        #expect(await cpu.readFlag(.C) == false)
    }
    
    @Test func testROL_ZeroPage() async throws {
        let (cpu, memory) = initCPU()
        defer { memory.deallocate() }
        
        // Simple left rotate.
        memory[0xA000] = Opcodes6502.ROL_ZeroPage.rawValue
        memory[0xA001] = 0x11
        memory[0x11] = 0x21
        
        await cpu.runForTicks(5)
        #expect(memory[0x11] == 0x42)
        #expect(cpu.PC == 0xA002)
        #expect(await cpu.readFlag(.Z) == false)
        #expect(await cpu.readFlag(.N) == false)
        #expect(await cpu.readFlag(.C) == false)
        
        // Left rotate that sets zero and carry flags.
        await cpu.reset()
        memory[0xA000] = Opcodes6502.ROL_ZeroPage.rawValue
        memory[0xA001] = 0x11
        memory[0x11] = 0x80
        
        await cpu.runForTicks(5)
        #expect(memory[0x11] == 0x00)
        #expect(cpu.PC == 0xA002)
        #expect(await cpu.readFlag(.Z) == true)
        #expect(await cpu.readFlag(.N) == false)
        #expect(await cpu.readFlag(.C) == true)
        
        // Left rotate that sets negative flag.
        await cpu.reset()
        memory[0xA000] = Opcodes6502.ROL_ZeroPage.rawValue
        memory[0xA001] = 0x11
        memory[0x11] = 0x40
        
        await cpu.runForTicks(5)
        #expect(memory[0x11] == 0x80)
        #expect(cpu.PC == 0xA002)
        #expect(await cpu.readFlag(.Z) == false)
        #expect(await cpu.readFlag(.N) == true)
        #expect(await cpu.readFlag(.C) == false)
        
        // Left rotate that sets zero flag.
        await cpu.reset()
        memory[0xA000] = Opcodes6502.ROL_ZeroPage.rawValue
        memory[0xA001] = 0xAA
        memory[0xAA] = 0x00
        
        await cpu.runForTicks(2)
        #expect(cpu.A == 0x00)
        #expect(cpu.PC == 0xA002)
        #expect(await cpu.readFlag(.Z) == true)
        #expect(await cpu.readFlag(.N) == false)
        #expect(await cpu.readFlag(.C) == false)
    }
    
    @Test func testROL_ZeroPageX() async throws {
        let (cpu, memory) = initCPU()
        defer { memory.deallocate() }
        
        // Simple left rotate
        cpu.X = 0x0A
        memory[0xA000] = Opcodes6502.ROL_ZeroPageX.rawValue
        memory[0xA001] = 0x50
        memory[0x5A] = 0x04
        
        await cpu.runForTicks(6)
        #expect(memory[0x5A] == 0x08)
        #expect(cpu.PC == 0xA002)
        #expect(await cpu.readFlag(.Z) == false)
        #expect(await cpu.readFlag(.N) == false)
        #expect(await cpu.readFlag(.C) == false)
        
        // Left rotate that sets carry flag.
        await cpu.reset()
        cpu.X = 0x0A
        memory[0xA000] = Opcodes6502.ROL_ZeroPageX.rawValue
        memory[0xA001] = 0x50
        memory[0x5A] = 0x80
        
        await cpu.runForTicks(6)
        #expect(memory[0x5A] == 0x00)
        #expect(cpu.PC == 0xA002)
        #expect(await cpu.readFlag(.Z) == true)
        #expect(await cpu.readFlag(.N) == false)
        #expect(await cpu.readFlag(.C) == true)
        
        // Left rotate that sets negative flag.
        await cpu.reset()
        cpu.X = 0x0A
        memory[0xA000] = Opcodes6502.ASL_ZeroPageX.rawValue
        memory[0xA001] = 0x50
        memory[0x5A] = 0x40
        
        await cpu.runForTicks(6)
        #expect(memory[0x5A] == 0x80)
        #expect(cpu.PC == 0xA002)
        #expect(await cpu.readFlag(.Z) == false)
        #expect(await cpu.readFlag(.N) == true)
        #expect(await cpu.readFlag(.C) == false)
        
        // Left rotate that sets zero flag.
        await cpu.reset()
        cpu.X = 0x0A
        memory[0xA000] = Opcodes6502.ROL_ZeroPageX.rawValue
        memory[0xA001] = 0x50
        memory[0x5A] = 0x00
        
        await cpu.runForTicks(2)
        #expect(cpu.A == 0x00)
        #expect(cpu.PC == 0xA002)
        #expect(await cpu.readFlag(.Z) == true)
        #expect(await cpu.readFlag(.N) == false)
        #expect(await cpu.readFlag(.C) == false)
    }
    
    @Test func testROL_Absolute() async throws {
        let (cpu, memory) = initCPU()
        defer { memory.deallocate() }
        
        // Simple left rotate.
        memory[0xA000] = Opcodes6502.ROL_Absolute.rawValue
        memory[0xA001] = 0x11
        memory[0xA002] = 0x22
        memory[0x2211] = 0x15
        
        await cpu.runForTicks(6)
        #expect(memory[0x2211] == 0x2A)
        #expect(cpu.PC == 0xA003)
        #expect(await cpu.readFlag(.Z) == false)
        #expect(await cpu.readFlag(.N) == false)
        #expect(await cpu.readFlag(.C) == false)
        
        // Left rotate that sets carry flag.
        await cpu.reset()
        memory[0xA000] = Opcodes6502.ROL_Absolute.rawValue
        memory[0xA001] = 0x11
        memory[0xA002] = 0x22
        memory[0x2211] = 0x80
        
        await cpu.runForTicks(6)
        #expect(memory[0x2211] == 0x00)
        #expect(cpu.PC == 0xA003)
        #expect(await cpu.readFlag(.Z) == true)
        #expect(await cpu.readFlag(.N) == false)
        #expect(await cpu.readFlag(.C) == true)
        
        // Left rotate that sets negative flag.
        await cpu.reset()
        memory[0xA000] = Opcodes6502.ROL_Absolute.rawValue
        memory[0xA001] = 0x11
        memory[0xA002] = 0x22
        memory[0x2211] = 0x40
        
        await cpu.runForTicks(6)
        #expect(memory[0x2211] == 0x80)
        #expect(cpu.PC == 0xA003)
        #expect(await cpu.readFlag(.Z) == false)
        #expect(await cpu.readFlag(.N) == true)
        #expect(await cpu.readFlag(.C) == false)
        
        // Left rotate that sets zero flag.
        await cpu.reset()
        memory[0xA000] = Opcodes6502.ROL_Absolute.rawValue
        memory[0xA001] = 0x50
        memory[0xA002] = 0x60
        memory[0x6050] = 0x00
        
        await cpu.runForTicks(2)
        #expect(memory[0x6050] == 0x00)
        #expect(cpu.PC == 0xA003)
        #expect(await cpu.readFlag(.Z) == true)
        #expect(await cpu.readFlag(.N) == false)
        #expect(await cpu.readFlag(.C) == false)
    }
    
    @Test func testROL_AbsoluteX() async throws {
        let (cpu, memory) = initCPU()
        defer { memory.deallocate() }
        
        // Simple left rotate
        cpu.X = 0xAA
        memory[0xA000] = Opcodes6502.ROL_AbsoluteX.rawValue
        memory[0xA001] = 0x50
        memory[0xA002] = 0x50
        memory[0x50FA] = 0x04
        
        await cpu.runForTicks(7)
        #expect(memory[0x50FA] == 0x08)
        #expect(cpu.PC == 0xA003)
        #expect(await cpu.readFlag(.Z) == false)
        #expect(await cpu.readFlag(.N) == false)
        #expect(await cpu.readFlag(.C) == false)
        
        // Left rotate that sets carry flag.
        await cpu.reset()
        cpu.X = 0xAA
        memory[0xA000] = Opcodes6502.ROL_AbsoluteX.rawValue
        memory[0xA001] = 0x50
        memory[0xA002] = 0x50
        memory[0x50FA] = 0x80
        
        await cpu.runForTicks(7)
        #expect(memory[0x50FA] == 0x00)
        #expect(cpu.PC == 0xA003)
        #expect(await cpu.readFlag(.Z) == true)
        #expect(await cpu.readFlag(.N) == false)
        #expect(await cpu.readFlag(.C) == true)
        
        // Left rotate that sets negative flag.
        await cpu.reset()
        cpu.X = 0xAA
        memory[0xA000] = Opcodes6502.ASL_AbsoluteX.rawValue
        memory[0xA001] = 0x50
        memory[0xA002] = 0x50
        memory[0x50FA] = 0x40
        
        await cpu.runForTicks(7)
        #expect(memory[0x50FA] == 0x80)
        #expect(cpu.PC == 0xA003)
        #expect(await cpu.readFlag(.Z) == false)
        #expect(await cpu.readFlag(.N) == true)
        #expect(await cpu.readFlag(.C) == false)
        
        // Left rotate that sets zero flag.
        await cpu.reset()
        cpu.X = 0xAA
        memory[0xA000] = Opcodes6502.ROL_AbsoluteX.rawValue
        memory[0xA001] = 0x50
        memory[0xA002] = 0x60
        memory[0x60FA] = 0x00
        
        await cpu.runForTicks(2)
        #expect(memory[0x60FA] == 0x00)
        #expect(cpu.PC == 0xA003)
        #expect(await cpu.readFlag(.Z) == true)
        #expect(await cpu.readFlag(.N) == false)
        #expect(await cpu.readFlag(.C) == false)
    }
}
