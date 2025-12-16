//
//  CMPTests.swift
//  Swift6502
//
//  Created by James Weatherley on 17/11/2025.
//

import Testing
@testable import Swift6502

struct CMPTests {
    @Test func testCMP_Immediate() async throws {
        let (cpu, memory) = await initCPU()
        defer { memory.deallocate() }
        
        for (i, CompareTestInput) in compareTestInputs.enumerated() {
            await cpu.reset()
            await cpu.setA(CompareTestInput.registerValue)
            memory[0xA000] = Opcodes6502.CMP_Immediate.rawValue
            memory[0xA001] = CompareTestInput.memory
            
            await cpu.runForTicks(2)
            await testCMP(cpu: cpu, expected: compareTestOutputs[i])
        }
    }
    
    @Test func testCMP_ZeroPage() async throws {
        let (cpu, memory) = await initCPU()
        defer { memory.deallocate() }
        
        for (i, CompareTestInput) in compareTestInputs.enumerated() {
            await cpu.reset()
            await cpu.setA(CompareTestInput.registerValue)
            memory[0xA000] = Opcodes6502.CMP_ZeroPage.rawValue
            memory[0xA001] = 0x55
            memory[0x55] = CompareTestInput.memory
            
            await cpu.runForTicks(3)
            await testCMP(cpu: cpu, expected: compareTestOutputs[i])
        }
    }
    
    @Test func testCMP_ZeroPageX() async throws {
        let (cpu, memory) = await initCPU()
        defer { memory.deallocate() }
        
        for (i, CompareTestInput) in compareTestInputs.enumerated() {
            await cpu.reset()
            await cpu.setA(CompareTestInput.registerValue)
            await cpu.setX(0x10)
            memory[0xA000] = Opcodes6502.CMP_ZeroPageX.rawValue
            memory[0xA001] = 0x55
            memory[0x65] = CompareTestInput.memory
            
            await cpu.runForTicks(4)
            await testCMP(cpu: cpu, expected: compareTestOutputs[i])
        }
    }
    
    @Test func testCMP_Absolute() async throws {
        let (cpu, memory) = await initCPU()
        defer { memory.deallocate() }
        
        for (i, CompareTestInput) in compareTestInputs.enumerated() {
            await cpu.reset()
            await cpu.setA(CompareTestInput.registerValue)
            memory[0xA000] = Opcodes6502.CMP_Absolute.rawValue
            memory[0xA001] = 0x34
            memory[0xA002] = 0x12
            memory[0x1234] = CompareTestInput.memory
            
            await cpu.runForTicks(4)
            await testCMP(cpu: cpu, expected: compareTestOutputs[i])
        }
    }
    
    @Test func testCMP_AbsoluteX() async throws {
        let (cpu, memory) = await initCPU()
        defer { memory.deallocate() }
        
        // No page boundary crossed.
        for (i, CompareTestInput) in compareTestInputs.enumerated() {
            await cpu.reset()
            await cpu.setA(CompareTestInput.registerValue)
            await cpu.setX(0x10)
            
            memory[0xA000] = Opcodes6502.CMP_AbsoluteX.rawValue
            memory[0xA001] = 0x78
            memory[0xA002] = 0x56
            memory[0x5688] = CompareTestInput.memory
            
            await cpu.runForTicks(4)
            await testCMP(cpu: cpu, expected: compareTestOutputs[i])
        }
        
        // Page boundary crossed.
        for (i, CompareTestInput) in compareTestInputs.enumerated() {
            await cpu.reset()
            await cpu.setA(CompareTestInput.registerValue)
            await cpu.setX(0x10)
            memory[0xA000] = Opcodes6502.CMP_AbsoluteX.rawValue
            memory[0xA001] = 0xF0
            memory[0xA002] = 0xA0
            memory[0xA100] = CompareTestInput.memory
            
            let oldTickcount = await cpu.tickcount
            await cpu.runForTicks(5)
            let tickDelta = await cpu.tickcount - oldTickcount
            
            #expect(tickDelta == 5)
            await testCMP(cpu: cpu, expected: compareTestOutputs[i])
        }
    }
    
    @Test func testCMP_AbsoluteY() async throws {
        let (cpu, memory) = await initCPU()
        defer { memory.deallocate() }
        
        // No page boundary crossed.
        for (i, CompareTestInput) in compareTestInputs.enumerated() {
            await cpu.reset()
            await cpu.setA(CompareTestInput.registerValue)
            await cpu.setY(0x10)
            memory[0xA000] = Opcodes6502.CMP_AbsoluteY.rawValue
            memory[0xA001] = 0x73
            memory[0xA002] = 0x19
            memory[0x1983] = CompareTestInput.memory
            
            let oldTickcount = await cpu.tickcount
            await cpu.runForTicks(4)
            let tickDelta = await cpu.tickcount - oldTickcount
            
            #expect(tickDelta == 4)
            await testCMP(cpu: cpu, expected: compareTestOutputs[i])
        }
        
        // Page boundary crossed.
        for (i, CompareTestInput) in compareTestInputs.enumerated() {
            await cpu.reset()
            await cpu.setA(CompareTestInput.registerValue)
            await cpu.setY(0x10)
            memory[0xA000] = Opcodes6502.CMP_AbsoluteY.rawValue
            memory[0xA001] = 0xF0
            memory[0xA002] = 0x40
            memory[0x4100] = CompareTestInput.memory
            
            let oldTickcount = await cpu.tickcount
            await cpu.runForTicks(5)
            let tickDelta = await cpu.tickcount - oldTickcount
            
            #expect(tickDelta == 5)
            await testCMP(cpu: cpu, expected: compareTestOutputs[i])
        }
    }
    
    @Test func testCMP_IndirectX() async throws {
        let (cpu, memory) = await initCPU()
        defer { memory.deallocate() }
        
        for (i, CompareTestInput) in compareTestInputs.enumerated() {
            await cpu.reset()
            await cpu.setA(CompareTestInput.registerValue)
            await cpu.setX(0x10)
            memory[0xA000] = Opcodes6502.CMP_IndirectX.rawValue
            memory[0xA001] = 0x42
            memory[0x52] = 0x73
            memory[0x53] = 0x19
            memory[0x1973] = CompareTestInput.memory
            
            await cpu.runForTicks(6)
            await testCMP(cpu: cpu, expected: compareTestOutputs[i])
        }
    }
    
    @Test func testCMP_IndirectY() async throws {
        let (cpu, memory) = await initCPU()
        defer { memory.deallocate() }
        
        // No page boundary crossed.
        for (i, CompareTestInput) in compareTestInputs.enumerated() {
            await cpu.reset()
            await cpu.setA(CompareTestInput.registerValue)
            await cpu.setY(0x10)
            memory[0xA000] = Opcodes6502.CMP_IndirectY.rawValue
            memory[0xA001] = 0x22
            memory[0x22] = 0x04
            memory[0x23] = 0x20
            memory[0x2014] = CompareTestInput.memory
            
            let oldTickcount = await cpu.tickcount
            await cpu.runForTicks(5)
            let tickDelta = await cpu.tickcount - oldTickcount
            
            #expect(tickDelta == 5)
            await testCMP(cpu: cpu, expected: compareTestOutputs[i])
        }
        
        // Page boundary crossed.
        for (i, CompareTestInput) in compareTestInputs.enumerated() {
            await cpu.reset()
            await cpu.setA(CompareTestInput.registerValue)
            await cpu.setY(0x40)
            memory[0xA000] = Opcodes6502.CMP_IndirectY.rawValue
            memory[0xA001] = 0x22
            memory[0x22] = 0xF0
            memory[0x23] = 0x30
            memory[0x3130] = CompareTestInput.memory
            
            let oldTickcount = await cpu.tickcount
            await cpu.runForTicks(6)
            let tickDelta = await cpu.tickcount - oldTickcount
            
            #expect(tickDelta == 6)
            await testCMP(cpu: cpu, expected: compareTestOutputs[i])
        }
    }
}

