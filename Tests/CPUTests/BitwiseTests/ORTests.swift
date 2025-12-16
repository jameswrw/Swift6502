//
//  ORTests.swift
//  Swift6502
//
//  Created by James Weatherley on 17/11/2025.
//

import Testing
@testable import Swift6502

struct ORTests {
    
    fileprivate let payloads = [
        BitwiseTestPayload(initialA: 0x55, operand: 0x42, result: 0x57, Z: false, N: false),
        BitwiseTestPayload(initialA: 0xF0, operand: 0xCC, result: 0xFC, Z: false, N: true),
        BitwiseTestPayload(initialA: 0x00, operand: 0x00, result: 0x00, Z: true, N: false),
    // BitwiseTestPayload(initialA: 0x00, operand: 0x00, Z: true, N: true), Impossible we can't be negative OR zero at the same time.
    ]
    
    @Test func testORA_Immediate() async throws {
        let (cpu, memory) = await initCPU()
        defer { memory.deallocate() }
        
        for payload in payloads {
            await cpu.reset()
            await cpu.setA(payload.initialA)
            memory[0xA000] = Opcodes6502.ORA_Immediate.rawValue
            memory[0xA001] = payload.operand
            
            await cpu.runForTicks(2)
            let a = await cpu.A
            let zFlag = await cpu.readFlag(.Z)
            let nFlag = await cpu.readFlag(.N)
            
            #expect(a == payload.result)
            #expect(zFlag == payload.Z)
            #expect(nFlag == payload.N)
        }
    }
    
    @Test func testORA_ZeroPage() async throws {
        let (cpu, memory) = await initCPU()
        defer { memory.deallocate() }
        
        for payload in payloads {
            await cpu.reset()
            await cpu.setA(payload.initialA)
            memory[0xA000] = Opcodes6502.ORA_ZeroPage.rawValue
            memory[0xA001] = 0x06
            memory[0x06] = payload.operand
            
            await cpu.runForTicks(2)
            let a = await cpu.A
            let zFlag = await cpu.readFlag(.Z)
            let nFlag = await cpu.readFlag(.N)
            
            #expect(a == payload.result)
            #expect(zFlag == payload.Z)
            #expect(nFlag == payload.N)
        }
    }
    
    @Test func testORA_ZeroPageX() async throws {
        let (cpu, memory) = await initCPU()
        defer { memory.deallocate() }
        
        for payload in payloads {
            await cpu.reset()
            await cpu.setA(payload.initialA)
            await cpu.setX(0x10)
            memory[0xA000] = Opcodes6502.ORA_ZeroPageX.rawValue
            memory[0xA001] = 0x32
            memory[0x42] = payload.operand
            
            await cpu.runForTicks(4)
            let a = await cpu.A
            let zFlag = await cpu.readFlag(.Z)
            let nFlag = await cpu.readFlag(.N)
            
            #expect(a == payload.result)
            #expect(zFlag == payload.Z)
            #expect(nFlag == payload.N)
        }
    }
    
    @Test func testORA_Absolute() async throws {
        let (cpu, memory) = await initCPU()
        defer { memory.deallocate() }
        
        for payload in payloads {
            await cpu.reset()
            await cpu.setA(payload.initialA)
            memory[0xA000] = Opcodes6502.ORA_Absolute.rawValue
            memory[0xA001] = 0x34
            memory[0xA002] = 0x12
            memory[0x1234] = payload.operand
            
            await cpu.runForTicks(4)
            let a = await cpu.A
            let zFlag = await cpu.readFlag(.Z)
            let nFlag = await cpu.readFlag(.N)
            
            #expect(a == payload.result)
            #expect(zFlag == payload.Z)
            #expect(nFlag == payload.N)
        }
    }
    
    @Test func testORA_AbsoluteX() async throws {
        let (cpu, memory) = await initCPU()
        defer { memory.deallocate() }
        
        for payload in payloads {
            await cpu.reset()
            await cpu.setA(payload.initialA)
            await cpu.setX(0x10)
            memory[0xA000] = Opcodes6502.ORA_AbsoluteX.rawValue
            memory[0xA001] = 0x78
            memory[0xA002] = 0x56
            memory[0x5688] = payload.operand
            
            await cpu.runForTicks(4)
            let a = await cpu.A
            let zFlag = await cpu.readFlag(.Z)
            let nFlag = await cpu.readFlag(.N)
            
            #expect(a == payload.result)
            #expect(zFlag == payload.Z)
            #expect(nFlag == payload.N)
        }
        
        // Test crossing a page boundary takes five ticks instead of four.
        await cpu.reset()
        await cpu.setA(0x33)
        await cpu.setX(0x20)
        memory[0xA000] = Opcodes6502.ORA_AbsoluteX.rawValue
        memory[0xA001] = 0xF0
        memory[0xA002] = 0x56
        memory[0x5710] = 0x17
        
        let oldTickcount = await cpu.tickcount
        await cpu.runForTicks(5)
        let tickDelta = await cpu.tickcount - oldTickcount
        let a = await cpu.A
        let zFlag = await cpu.readFlag(.Z)
        let nFlag = await cpu.readFlag(.N)
        
        #expect(tickDelta == 5)
        #expect(a == 0x37)
        #expect(zFlag == false)
        #expect(nFlag == false)
    }
    
    @Test func testORA_AbsoluteY() async throws {
        let (cpu, memory) = await initCPU()
        defer { memory.deallocate() }
        
        for payload in payloads {
            await cpu.reset()
            await cpu.setA(payload.initialA)
            await cpu.setY(0x10)
            memory[0xA000] = Opcodes6502.ORA_AbsoluteY.rawValue
            memory[0xA001] = 0x78
            memory[0xA002] = 0x56
            memory[0x5688] = payload.operand
            
            await cpu.runForTicks(4)
            let a = await cpu.A
            let zFlag = await cpu.readFlag(.Z)
            let nFlag = await cpu.readFlag(.N)
            
            #expect(a == payload.result)
            #expect(zFlag == payload.Z)
            #expect(nFlag == payload.N)
        }
        
        // Test crossing a page boundary takes five ticks instead of four.
        await cpu.reset()
        await cpu.setA(0x33)
        await cpu.setY(0x20)
        memory[0xA000] = Opcodes6502.ORA_AbsoluteY.rawValue
        memory[0xA001] = 0xF0
        memory[0xA002] = 0x56
        memory[0x5710] = 0x17
        
        let oldTickcount = await cpu.tickcount
        await cpu.runForTicks(5)
        let tickDelta = await cpu.tickcount - oldTickcount
        let a = await cpu.A
        let zFlag = await cpu.readFlag(.Z)
        let nFlag = await cpu.readFlag(.N)
        
        #expect(tickDelta == 5)
        #expect(a == 0x37)
        #expect(zFlag == false)
        #expect(nFlag == false)
    }
    
    @Test func testORA_IndirectX() async throws {
        let (cpu, memory) = await initCPU()
        defer { memory.deallocate() }
        
        for payload in payloads {
            await cpu.reset()
            await cpu.setA(payload.initialA)
            await cpu.setX(0x20)
            memory[0xA000] = Opcodes6502.ORA_IndirectX.rawValue
            memory[0xA001] = 0x66
            memory[0x86] = 0x73
            memory[0x87] = 0x19
            memory[0x1973] = payload.operand
            
            await cpu.runForTicks(6)
            let a = await cpu.A
            let zFlag = await cpu.readFlag(.Z)
            let nFlag = await cpu.readFlag(.N)
            
            #expect(a == payload.result)
            #expect(zFlag == payload.Z)
            #expect(nFlag == payload.N)
        }
    }
    
    @Test func testORA_IndirectY() async throws {
        let (cpu, memory) = await initCPU()
        defer { memory.deallocate() }
        
        for payload in payloads {
            await cpu.reset()
            await cpu.setA(payload.initialA)
            await cpu.setY(0x20)
            memory[0xA000] = Opcodes6502.ORA_IndirectY.rawValue
            memory[0xA001] = 0x66
            memory[0x66] = 0x73
            memory[0x67] = 0x19
            memory[0x1993] = payload.operand
            
            await cpu.runForTicks(5)
            let a = await cpu.A
            let zFlag = await cpu.readFlag(.Z)
            let nFlag = await cpu.readFlag(.N)
            
            #expect(a == payload.result)
            #expect(zFlag == payload.Z)
            #expect(nFlag == payload.N)
        }
        
        // Test crossing a page boundary takes five ticks instead of four.
        await cpu.reset()
        await cpu.setA(0x7F)
        await cpu.setY(0x20)
        memory[0xA000] = Opcodes6502.ORA_IndirectY.rawValue
        memory[0xA001] = 0x66
        memory[0x66] = 0xF0
        memory[0x67] = 0x19
        memory[0x1A10] = 0x87
        
        await cpu.runForTicks(5)
        let a = await cpu.A
        let zFlag = await cpu.readFlag(.Z)
        let nFlag = await cpu.readFlag(.N)
        
        #expect(a == 0xFF)
        #expect(zFlag == false)
        #expect(nFlag == true)
    }
}

