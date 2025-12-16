//
//  LDXTests.swift
//  Swift6502
//
//  Created by James Weatherley on 17/11/2025.
//

import Testing
@testable import Swift6502

struct LDXTests {
    @Test func testLDX_Immediate() async throws {
        let (cpu, memory) = await initCPU()
        defer { memory.deallocate() }
        
        for testOutput in loadTestOutputs {
            await cpu.reset()
            memory[0xA000] = Opcodes6502.LDX_Immediate.rawValue
            memory[0xA001] = testOutput.value
            
            await cpu.runForTicks(2)
            let x = await cpu.X
            let zFlag = await cpu.readFlag(.Z)
            let nFlag = await cpu.readFlag(.N)
            
            #expect(x == testOutput.value)
            #expect(zFlag == testOutput.Z)
            #expect(nFlag == testOutput.N)
        }
    }
    
    @Test func testLDX_ZeroPage() async throws {
        let (cpu, memory) = await initCPU()
        defer { memory.deallocate() }
        
        for testOutput in loadTestOutputs {
            await cpu.reset()
            memory[0xA000] = Opcodes6502.LDX_ZeroPage.rawValue
            memory[0xA001] = 0x42
            memory[0x42] = testOutput.value
            
            await cpu.runForTicks(3)
            let x = await cpu.X
            let zFlag = await cpu.readFlag(.Z)
            let nFlag = await cpu.readFlag(.N)
            
            #expect(x == testOutput.value)
            #expect(zFlag == testOutput.Z)
            #expect(nFlag == testOutput.N)
        }
    }
    
    @Test func testLDA_ZeroPageY() async throws {
        let (cpu, memory) = await initCPU()
        defer { memory.deallocate() }
        
        for testOutput in loadTestOutputs {
            await cpu.reset()
            await cpu.setY(0x10)
            memory[0xA000] = Opcodes6502.LDX_ZeroPageY.rawValue
            memory[0xA001] = 0x42
            memory[0x52] = testOutput.value
            
            await cpu.runForTicks(4)
            let x = await cpu.X
            let zFlag = await cpu.readFlag(.Z)
            let nFlag = await cpu.readFlag(.N)
            
            #expect(x == testOutput.value)
            #expect(zFlag == testOutput.Z)
            #expect(nFlag == testOutput.N)
        }
    }
    
    @Test func testLDX_Absolute() async throws {
        let (cpu, memory) = await initCPU()
        defer { memory.deallocate() }
        
        for testOutput in loadTestOutputs {
            await cpu.reset()
            memory[0xA000] = Opcodes6502.LDX_Absolute.rawValue
            memory[0xA001] = 0x73
            memory[0xA002] = 0x19
            memory[0x1973] = testOutput.value
            
            await cpu.runForTicks(4)
            let x = await cpu.X
            let zFlag = await cpu.readFlag(.Z)
            let nFlag = await cpu.readFlag(.N)
            
            #expect(x == testOutput.value)
            #expect(zFlag == testOutput.Z)
            #expect(nFlag == testOutput.N)
        }
    }
    
    @Test func testLDX_AbsoluteY() async throws {
        let (cpu, memory) = await initCPU()
        defer { memory.deallocate() }
        
        for testOutput in loadTestOutputs {
            await cpu.reset()
            await cpu.setY(0x20)
            memory[0xA000] = Opcodes6502.LDX_AbsoluteY.rawValue
            memory[0xA001] = 0x73
            memory[0xA002] = 0x19
            memory[0x1993] = testOutput.value
            
            let oldTickcount = await cpu.tickcount
            await cpu.runForTicks(4)
            let tickDelta = await cpu.tickcount - oldTickcount
            let x = await cpu.X
            let zFlag = await cpu.readFlag(.Z)
            let nFlag = await cpu.readFlag(.N)
            
            #expect(tickDelta == 4)
            #expect(x == testOutput.value)
            #expect(zFlag == testOutput.Z)
            #expect(nFlag == testOutput.N)
        }
        
        // Bonus page boundary crossing test.
        await cpu.reset()
        await cpu.setY(0x20)
        memory[0xA000] = Opcodes6502.LDX_AbsoluteY.rawValue
        memory[0xA001] = 0xF0
        memory[0xA002] = 0x19
        memory[0x1A10] = 0x99
        
        let oldTickcount = await cpu.tickcount
        await cpu.runForTicks(5)
        let tickDelta = await cpu.tickcount - oldTickcount
        let x = await cpu.X
        let zFlag = await cpu.readFlag(.Z)
        let nFlag = await cpu.readFlag(.N)
        
        #expect(tickDelta == 5)
        #expect(x == 0x99)
        #expect(zFlag == false)
        #expect(nFlag == true)
    }
}

