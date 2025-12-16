//
//  LDATests.swift
//  Swift6502
//
//  Created by James Weatherley on 17/11/2025.
//

import Testing
@testable import Swift6502

struct LDATests {
    @Test func testLDA_Immediate() async throws {
        let (cpu, memory) = await initCPU()
        defer { memory.deallocate() }
        
        for testOutput in loadTestOutputs {
            await cpu.reset()
            memory[0xA000] = Opcodes6502.LDA_Immediate.rawValue
            memory[0xA001] = testOutput.value
            
            await cpu.runForTicks(2)
            let a = await cpu.A
            let zFlag = await cpu.readFlag(.Z)
            let nFlag = await cpu.readFlag(.N)
            
            #expect(a == testOutput.value)
            #expect(zFlag == testOutput.Z)
            #expect(nFlag == testOutput.N)
        }
    }
    
    @Test func testLDA_ZeroPage() async throws {
        let (cpu, memory) = await initCPU()
        defer { memory.deallocate() }
        
        for testOutput in loadTestOutputs {
            await cpu.reset()
            memory[0xA000] = Opcodes6502.LDA_ZeroPage.rawValue
            memory[0xA001] = 0x42
            memory[0x42] = testOutput.value
            
            await cpu.runForTicks(3)
            let a = await cpu.A
            let zFlag = await cpu.readFlag(.Z)
            let nFlag = await cpu.readFlag(.N)
            
            #expect(a == testOutput.value)
            #expect(zFlag == testOutput.Z)
            #expect(nFlag == testOutput.N)
        }
    }
    
    @Test func testLDA_ZeroPageX() async throws {
        let (cpu, memory) = await initCPU()
        defer { memory.deallocate() }
        
        for testOutput in loadTestOutputs {
            await cpu.reset()
            await cpu.setX(0x10)
            memory[0xA000] = Opcodes6502.LDA_ZeroPageX.rawValue
            memory[0xA001] = 0x42
            memory[0x52] = testOutput.value
            
            await cpu.runForTicks(4)
            let a = await cpu.A
            let zFlag = await cpu.readFlag(.Z)
            let nFlag = await cpu.readFlag(.N)
            
            #expect(a == testOutput.value)
            #expect(zFlag == testOutput.Z)
            #expect(nFlag == testOutput.N)
        }
    }
    
    @Test func testLDA_Absolute() async throws {
        let (cpu, memory) = await initCPU()
        defer { memory.deallocate() }
        
        for testOutput in loadTestOutputs {
            await cpu.reset()
            memory[0xA000] = Opcodes6502.LDA_Absolute.rawValue
            memory[0xA001] = 0x73
            memory[0xA002] = 0x19
            memory[0x1973] = testOutput.value
            
            await cpu.runForTicks(4)
            let a = await cpu.A
            let zFlag = await cpu.readFlag(.Z)
            let nFlag = await cpu.readFlag(.N)
            
            #expect(a == testOutput.value)
            #expect(zFlag == testOutput.Z)
            #expect(nFlag == testOutput.N)
        }
    }
    
    @Test func testLDA_AbsoluteX() async throws {
        let (cpu, memory) = await initCPU()
        defer { memory.deallocate() }
        
        for testOutput in loadTestOutputs {
            await cpu.reset()
            await cpu.setX(0x20)
            memory[0xA000] = Opcodes6502.LDA_AbsoluteX.rawValue
            memory[0xA001] = 0x73
            memory[0xA002] = 0x19
            memory[0x1993] = testOutput.value
            
            let oldTickcount = await cpu.tickcount
            await cpu.runForTicks(4)
            let tickDelta = await cpu.tickcount - oldTickcount
            let a = await cpu.A
            let zFlag = await cpu.readFlag(.Z)
            let nFlag = await cpu.readFlag(.N)
            
            #expect(tickDelta == 4)
            #expect(a == testOutput.value)
            #expect(zFlag == testOutput.Z)
            #expect(nFlag == testOutput.N)
        }
        
        // Bonus page boundary crossing test.
        await cpu.reset()
        await cpu.setX(0x20)
        memory[0xA000] = Opcodes6502.LDA_AbsoluteX.rawValue
        memory[0xA001] = 0xF0
        memory[0xA002] = 0x19
        memory[0x1A10] = 0x42
        
        let oldTickcount = await cpu.tickcount
        await cpu.runForTicks(5)
        let tickDelta = await cpu.tickcount - oldTickcount
        let a = await cpu.A
        let zFlag = await cpu.readFlag(.Z)
        let nFlag = await cpu.readFlag(.N)
        
        #expect(tickDelta == 5)
        #expect(a == 0x42)
        #expect(zFlag == false)
        #expect(nFlag == false)
    }
    
    @Test func testLDA_AbsoluteY() async throws {
        let (cpu, memory) = await initCPU()
        defer { memory.deallocate() }
        
        for testOutput in loadTestOutputs {
            await cpu.reset()
            await cpu.setY(0x20)
            memory[0xA000] = Opcodes6502.LDA_AbsoluteY.rawValue
            memory[0xA001] = 0x73
            memory[0xA002] = 0x19
            memory[0x1993] = testOutput.value
            
            let oldTickcount = await cpu.tickcount
            await cpu.runForTicks(4)
            let tickDelta = await cpu.tickcount - oldTickcount
            let a = await cpu.A
            let zFlag = await cpu.readFlag(.Z)
            let nFlag = await cpu.readFlag(.N)
            
            #expect(tickDelta == 4)
            #expect(a == testOutput.value)
            #expect(zFlag == testOutput.Z)
            #expect(nFlag == testOutput.N)
        }
        
        // Bonus page boundary crossing test.
        await cpu.reset()
        await cpu.setY(0x20)
        memory[0xA000] = Opcodes6502.LDA_AbsoluteY.rawValue
        memory[0xA001] = 0xF0
        memory[0xA002] = 0x19
        memory[0x1A10] = 0x99
        
        let oldTickcount = await cpu.tickcount
        await cpu.runForTicks(5)
        let tickDelta = await cpu.tickcount - oldTickcount
        let a = await cpu.A
        let zFlag = await cpu.readFlag(.Z)
        let nFlag = await cpu.readFlag(.N)
        
        #expect(tickDelta == 5)
        #expect(a == 0x99)
        #expect(zFlag == false)
        #expect(nFlag == true)
    }
    
    @Test func testLDA_IndirectX() async throws {
        let (cpu, memory) = await initCPU()
        defer { memory.deallocate() }
        
        for testOutput in loadTestOutputs {
            await cpu.reset()
            await cpu.setX(0x20)
            memory[0xA000] = Opcodes6502.LDA_IndirectX.rawValue
            memory[0xA001] = 0x80
            memory[0xA0] = 0x69
            memory[0xA1] = 0x19
            memory[0x1969] = testOutput.value
            
            await cpu.runForTicks(6)
            let a = await cpu.A
            let zFlag = await cpu.readFlag(.Z)
            let nFlag = await cpu.readFlag(.N)
            
            #expect(a == testOutput.value)
            #expect(zFlag == testOutput.Z)
            #expect(nFlag == testOutput.N)
        }
    }
    
    @Test func testLDA_IndirectY() async throws {
        let (cpu, memory) = await initCPU()
        defer { memory.deallocate() }
        
        for testOutput in loadTestOutputs {
            await cpu.reset()
            await cpu.setY(0x20)
            memory[0xA000] = Opcodes6502.LDA_IndirectY.rawValue
            memory[0xA001] = 0x04
            memory[0x04] = 0x42
            memory[0x05] = 0x24
            memory[0x2462] = testOutput.value
            
            let oldTickcount = await cpu.tickcount
            await cpu.runForTicks(5)
            let tickDelta = await cpu.tickcount - oldTickcount
            let a = await cpu.A
            let zFlag = await cpu.readFlag(.Z)
            let nFlag = await cpu.readFlag(.N)
            
            #expect(tickDelta == 5)
            #expect(a == testOutput.value)
            #expect(zFlag == testOutput.Z)
            #expect(nFlag == testOutput.N)
        }
        
        // Bonus page boundary crossing test.
        do {
            await cpu.reset()
            await cpu.setY(0x20)
            memory[0xA000] = Opcodes6502.LDA_IndirectY.rawValue
            memory[0xA001] = 0xF0
            memory[0xF0] = 0xF0
            memory[0xF1] = 0x66
            memory[0x6710] = 0x34
            
            let  oldTickcount = await cpu.tickcount
            await cpu.runForTicks(6)
            let tickDelta = await cpu.tickcount - oldTickcount
            let a = await cpu.A
            let zFlag = await cpu.readFlag(.Z)
            let nFlag = await cpu.readFlag(.N)
            
            #expect(tickDelta == 6)
            #expect(a == 0x34)
            #expect(zFlag == false)
            #expect(nFlag == false)
        }
        
        // Bonus Y > 0x80 test.
        do {
            await cpu.reset()
            await cpu.setY(0xFF)
            memory[0xA000] = Opcodes6502.LDA_IndirectY.rawValue
            memory[0xA001] = 0xF0
            memory[0xF0] = 0x00
            memory[0xF1] = 0x66
            memory[0x66FF] = 0x42
            
            let oldTickcount = await cpu.tickcount
            await cpu.runForTicks(5)
            let tickDelta = await cpu.tickcount - oldTickcount
            let a = await cpu.A
            let zFlag = await cpu.readFlag(.Z)
            
            #expect(tickDelta == 5)
            #expect(a == 0x42)
            #expect(zFlag == false)
        }
    }
    
}
