//
//  ADCHexTests.swift
//  Swift6502
//
//  Created by James Weatherley on 20/11/2025.
//

import Testing
@testable import Swift6502

struct ADCHexTests {
    fileprivate let carryPayloads = [
        AddSubtractTestPayload(initialA: 0x35, operand: 0x42, result: 0x78, Z: false, N: false, C: false, V: false),
        AddSubtractTestPayload(initialA: 0x45, operand: 0x44, result: 0x8A, Z: false, N: true, C: false, V: true),
        AddSubtractTestPayload(initialA: 0x75, operand: 0x10, result: 0x86, Z: false, N: true, C: false, V: true),
        AddSubtractTestPayload(initialA: 0xFE, operand: 0x01, result: 0x00, Z: true, N: false, C: true, V: false),
    ]
    
    fileprivate let noCarryPayloads = [
        AddSubtractTestPayload(initialA: 0x35, operand: 0x42, result: 0x77, Z: false, N: false, C: false, V: false),
        AddSubtractTestPayload(initialA: 0x45, operand: 0x44, result: 0x89, Z: false, N: true, C: false, V: true),
        AddSubtractTestPayload(initialA: 0x75, operand: 0x10, result: 0x85, Z: false, N: true, C: false, V: true),
        AddSubtractTestPayload(initialA: 0xFE, operand: 0x02, result: 0x00, Z: true, N: false, C: true, V: false),
    ]
    
    @Test func testADC_Immediate() async throws {
        let (cpu, memory) = await initCPU()
        defer { memory.deallocate() }

        var useCarry = true
        for _ in 0...1 {
            let payloads = (useCarry ? carryPayloads : noCarryPayloads)
            
            for payload in payloads {
                await cpu.reset()
                useCarry ? await cpu.setFlag(.C) : await cpu.clearFlag(.C)
                await cpu.setA(payload.initialA)
                memory[0xA000] = Opcodes6502.ADC_Immediate.rawValue
                memory[0xA001] = payload.operand
                
                await cpu.runForTicks(2)
                let a = await cpu.A
                let zFlag = await cpu.readFlag(.Z)
                let nFlag = await cpu.readFlag(.N)
                let cFlag = await cpu.readFlag(.C)
                let vFlag = await cpu.readFlag(.V)
                
                #expect(a == payload.result)
                #expect(zFlag == payload.Z)
                #expect(nFlag == payload.N)
                #expect(cFlag == payload.C)
                #expect(vFlag == payload.V)
            }
            useCarry.toggle()
        }
    }
    
    @Test func testADC_ZeroPage() async throws {
        let (cpu, memory) = await initCPU()
        defer { memory.deallocate() }

        var useCarry = true
        for _ in 0...1 {
            let payloads = (useCarry ? carryPayloads : noCarryPayloads)
            for payload in payloads {
                await cpu.reset()
                useCarry ? await cpu.setFlag(.C) : await cpu.clearFlag(.C)
                await cpu.setA(payload.initialA)
                memory[0xA000] = Opcodes6502.ADC_ZeroPage.rawValue
                memory[0xA001] = 0x42
                memory[0x42] = payload.operand
                
                await cpu.runForTicks(3)
                let a = await cpu.A
                let zFlag = await cpu.readFlag(.Z)
                let nFlag = await cpu.readFlag(.N)
                let cFlag = await cpu.readFlag(.C)
                let vFlag = await cpu.readFlag(.V)
                
                #expect(a == payload.result)
                #expect(zFlag == payload.Z)
                #expect(nFlag == payload.N)
                #expect(cFlag == payload.C)
                #expect(vFlag == payload.V)
            }
            useCarry.toggle()
        }
    }
    
    @Test func testADC_ZeroPageX() async throws {
        let (cpu, memory) = await initCPU()
        defer { memory.deallocate() }

        var useCarry = true
        for _ in 0...1 {
            let payloads = (useCarry ? carryPayloads : noCarryPayloads)
            
            for payload in payloads {
                await cpu.reset()
                useCarry ? await cpu.setFlag(.C) : await cpu.clearFlag(.C)
                await cpu.setA(payload.initialA)
                await cpu.setX(0x20)
                memory[0xA000] = Opcodes6502.ADC_ZeroPageX.rawValue
                memory[0xA001] = 0x42
                memory[0x62] = payload.operand
                
                await cpu.runForTicks(4)
                let a = await cpu.A
                let zFlag = await cpu.readFlag(.Z)
                let nFlag = await cpu.readFlag(.N)
                let cFlag = await cpu.readFlag(.C)
                let vFlag = await cpu.readFlag(.V)
                
                #expect(a == payload.result)
                #expect(zFlag == payload.Z)
                #expect(nFlag == payload.N)
                #expect(cFlag == payload.C)
                #expect(vFlag == payload.V)
            }
            useCarry.toggle()
        }
    }
    
    @Test func testADC_Absolute() async throws {
        let (cpu, memory) = await initCPU()
        defer { memory.deallocate() }

        var useCarry = true
        for _ in 0...1 {
            let payloads = (useCarry ? carryPayloads : noCarryPayloads)
            
            for payload in payloads {
                await cpu.reset()
                useCarry ? await cpu.setFlag(.C) : await cpu.clearFlag(.C)
                await cpu.setA(payload.initialA)
                memory[0xA000] = Opcodes6502.ADC_Absolute.rawValue
                memory[0xA001] = 0x34
                memory[0xA002] = 0x12
                memory[0x1234] = payload.operand
                
                await cpu.runForTicks(4)
                let a = await cpu.A
                let zFlag = await cpu.readFlag(.Z)
                let nFlag = await cpu.readFlag(.N)
                let cFlag = await cpu.readFlag(.C)
                let vFlag = await cpu.readFlag(.V)
                
                #expect(a == payload.result)
                #expect(zFlag == payload.Z)
                #expect(nFlag == payload.N)
                #expect(cFlag == payload.C)
                #expect(vFlag == payload.V)
            }
            useCarry.toggle()
        }
    }
    
    @Test func testADC_AbsoluteX() async throws {
        let (cpu, memory) = await initCPU()
        defer { memory.deallocate() }

        var useCarry = true
        for _ in 0...1 {
            let payloads = (useCarry ? carryPayloads : noCarryPayloads)
            
            for payload in payloads {
                await cpu.reset()
                useCarry ? await cpu.setFlag(.C) : await cpu.clearFlag(.C)
                await cpu.setA(payload.initialA)
                await cpu.setX(0x20)
                memory[0xA000] = Opcodes6502.ADC_AbsoluteX.rawValue
                memory[0xA001] = 0x34
                memory[0xA002] = 0x12
                memory[0x1254] = payload.operand
                
                await cpu.runForTicks(4)
                let a = await cpu.A
                let zFlag = await cpu.readFlag(.Z)
                let nFlag = await cpu.readFlag(.N)
                let cFlag = await cpu.readFlag(.C)
                let vFlag = await cpu.readFlag(.V)
                
                #expect(a == payload.result)
                #expect(zFlag == payload.Z)
                #expect(nFlag == payload.N)
                #expect(cFlag == payload.C)
                #expect(vFlag == payload.V)
            }
            useCarry.toggle()
        }
        
        // Test crossing page boundary adds a tick.
        await cpu.reset()
        await cpu.setFlag(.C)
        await cpu.setA(0x25)
        await cpu.setX(0x20)
        memory[0xA000] = Opcodes6502.ADC_AbsoluteX.rawValue
        memory[0xA001] = 0xF0
        memory[0xA002] = 0x56
        memory[0x5710] = 0x32
        
        await cpu.runForTicks(5)
        let a = await cpu.A
        let zFlag = await cpu.readFlag(.Z)
        let nFlag = await cpu.readFlag(.N)
        let cFlag = await cpu.readFlag(.C)
        let vFlag = await cpu.readFlag(.V)
        
        #expect(a == 0x58)
        #expect(zFlag == false)
        #expect(nFlag == false)
        #expect(cFlag == false)
        #expect(vFlag == false)
    }
    
    @Test func testADC_AbsoluteY() async throws {
        let (cpu, memory) = await initCPU()
        defer { memory.deallocate() }

        var useCarry = true
        for _ in 0...1 {
            let payloads = (useCarry ? carryPayloads : noCarryPayloads)
            
            for payload in payloads {
                await cpu.reset()
                useCarry ? await cpu.setFlag(.C) : await cpu.clearFlag(.C)
                await cpu.setA(payload.initialA)
                await cpu.setY(0x20)
                memory[0xA000] = Opcodes6502.ADC_AbsoluteY.rawValue
                memory[0xA001] = 0x34
                memory[0xA002] = 0x12
                memory[0x1254] = payload.operand
                
                await cpu.runForTicks(4)
                let a = await cpu.A
                let zFlag = await cpu.readFlag(.Z)
                let nFlag = await cpu.readFlag(.N)
                let cFlag = await cpu.readFlag(.C)
                let vFlag = await cpu.readFlag(.V)
                
                #expect(a == payload.result)
                #expect(zFlag == payload.Z)
                #expect(nFlag == payload.N)
                #expect(cFlag == payload.C)
                #expect(vFlag == payload.V)
            }
            useCarry.toggle()
        }
        
        // Test crossing page boundary adds a tick.
        await cpu.reset()
        await cpu.setFlag(.C)
        await cpu.setA(0x25)
        await cpu.setY(0x20)
        memory[0xA000] = Opcodes6502.ADC_AbsoluteY.rawValue
        memory[0xA001] = 0xF0
        memory[0xA002] = 0x56
        memory[0x5710] = 0x32
        
        await cpu.runForTicks(5)
        let a = await cpu.A
        let zFlag = await cpu.readFlag(.Z)
        let nFlag = await cpu.readFlag(.N)
        let cFlag = await cpu.readFlag(.C)
        let vFlag = await cpu.readFlag(.V)
        
        #expect(a == 0x58)
        #expect(zFlag == false)
        #expect(nFlag == false)
        #expect(cFlag == false)
        #expect(vFlag == false)
    }
    
    @Test func testADC_IndirectX() async throws {
        let (cpu, memory) = await initCPU()
        defer { memory.deallocate() }

        var useCarry = true
        for _ in 0...1 {
            let payloads = (useCarry ? carryPayloads : noCarryPayloads)
            
            for payload in payloads {
                await cpu.reset()
                useCarry ? await cpu.setFlag(.C) : await cpu.clearFlag(.C)
                await cpu.setA(payload.initialA)
                await cpu.setX(0x20)
                memory[0xA000] = Opcodes6502.ADC_IndirectX.rawValue
                memory[0xA001] = 0x34
                memory[0x54] = 0x78
                memory[0x55] = 0x56
                memory[0x5678] = payload.operand
                
                await cpu.runForTicks(6)
                let a = await cpu.A
                let zFlag = await cpu.readFlag(.Z)
                let nFlag = await cpu.readFlag(.N)
                let cFlag = await cpu.readFlag(.C)
                let vFlag = await cpu.readFlag(.V)
                
                #expect(a == payload.result)
                #expect(zFlag == payload.Z)
                #expect(nFlag == payload.N)
                #expect(cFlag == payload.C)
                #expect(vFlag == payload.V)
            }
            useCarry.toggle()
        }
    }
    
    @Test func testADC_IndirectY() async throws {
        let (cpu, memory) = await initCPU()
        defer { memory.deallocate() }

        var useCarry = true
        for _ in 0...1 {
            let payloads = (useCarry ? carryPayloads : noCarryPayloads)
            
            for payload in payloads {
                await cpu.reset()
                useCarry ? await cpu.setFlag(.C) : await cpu.clearFlag(.C)
                await cpu.setA(payload.initialA)
                await cpu.setY(0x20)
                memory[0xA000] = Opcodes6502.ADC_IndirectY.rawValue
                memory[0xA001] = 0x34
                memory[0x34] = 0x78
                memory[0x35] = 0x56
                memory[0x5698] = payload.operand
                
                await cpu.runForTicks(5)
                let a = await cpu.A
                let zFlag = await cpu.readFlag(.Z)
                let nFlag = await cpu.readFlag(.N)
                let cFlag = await cpu.readFlag(.C)
                let vFlag = await cpu.readFlag(.V)
                
                #expect(a == payload.result)
                #expect(zFlag == payload.Z)
                #expect(nFlag == payload.N)
                #expect(cFlag == payload.C)
                #expect(vFlag == payload.V)
            }
            useCarry.toggle()
        }
        
        // Test crossing page boundary adds a tick.
        await cpu.reset()
        await cpu.setFlag(.C)
        await cpu.setA(0x56)
        await cpu.setY(0x20)
        memory[0xA000] = Opcodes6502.ADC_IndirectY.rawValue
        memory[0xA001] = 0x55
        memory[0x55] = 0xF0
        memory[0x56] = 0x88
        memory[0x8910] = 0x42
        
        await cpu.runForTicks(6)
        let a = await cpu.A
        let zFlag = await cpu.readFlag(.Z)
        let nFlag = await cpu.readFlag(.N)
        let cFlag = await cpu.readFlag(.C)
        let vFlag = await cpu.readFlag(.V)
        
        #expect(a == 0x99)
        #expect(zFlag == false)
        #expect(nFlag == true)
        #expect(cFlag == false)
        #expect(vFlag == true)
    }
}
