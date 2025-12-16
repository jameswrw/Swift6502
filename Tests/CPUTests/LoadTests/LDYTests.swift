//
//  LDYTests.swift
//  Swift6502
//
//  Created by James Weatherley on 17/11/2025.
//

import Testing
@testable import Swift6502

struct TestLDY {
    @Test func testLDX_Immediate() async throws {
        let (cpu, memory) = initCPU()
        defer { memory.deallocate() }
        
        for testOutput in loadTestOutputs {
            await cpu.reset()
            memory[0xA000] = Opcodes6502.LDY_Immediate.rawValue
            memory[0xA001] = testOutput.value
            
            await cpu.runForTicks(2)
            #expect(cpu.Y == testOutput.value)
            
            let zFlag = await cpu.readFlag(.Z)
            let nFlag = await cpu.readFlag(.N)
            #expect(zFlag == testOutput.Z)
            #expect(nFlag == testOutput.N)
        }
    }
    
    @Test func testLDX_ZeroPage() async throws {
        let (cpu, memory) = initCPU()
        defer { memory.deallocate() }
        
        for testOutput in loadTestOutputs {
            await cpu.reset()
            memory[0xA000] = Opcodes6502.LDY_ZeroPage.rawValue
            memory[0xA001] = 0x42
            memory[0x42] = testOutput.value
            
            await cpu.runForTicks(3)
            #expect(cpu.Y == testOutput.value)
            
            let zFlag = await cpu.readFlag(.Z)
            let nFlag = await cpu.readFlag(.N)
            #expect(zFlag == testOutput.Z)
            #expect(nFlag == testOutput.N)
        }
    }
    
    @Test func testLDY_ZeroPageX() async throws {
        let (cpu, memory) = initCPU()
        defer { memory.deallocate() }
        
        for testOutput in loadTestOutputs {
            await cpu.reset()
            cpu.X = 0x10
            memory[0xA000] = Opcodes6502.LDY_ZeroPageX.rawValue
            memory[0xA001] = 0x42
            memory[0x52] = testOutput.value
            
            await cpu.runForTicks(4)
            #expect(cpu.Y == testOutput.value)
            
            let zFlag = await cpu.readFlag(.Z)
            let nFlag = await cpu.readFlag(.N)
            #expect(zFlag == testOutput.Z)
            #expect(nFlag == testOutput.N)
        }
    }
    
    @Test func testLDY_Absolute() async throws {
        let (cpu, memory) = initCPU()
        defer { memory.deallocate() }
        
        for testOutput in loadTestOutputs {
            await cpu.reset()
            memory[0xA000] = Opcodes6502.LDY_Absolute.rawValue
            memory[0xA001] = 0x73
            memory[0xA002] = 0x19
            memory[0x1973] = testOutput.value
            
            await cpu.runForTicks(4)
            #expect(cpu.Y == testOutput.value)
            
            let zFlag = await cpu.readFlag(.Z)
            let nFlag = await cpu.readFlag(.N)
            #expect(zFlag == testOutput.Z)
            #expect(nFlag == testOutput.N)
        }
    }
    
    @Test func testLDY_AbsoluteX() async throws {
        let (cpu, memory) = initCPU()
        defer { memory.deallocate() }
        
        for testOutput in loadTestOutputs {
            await cpu.reset()
            cpu.X = 0x20
            memory[0xA000] = Opcodes6502.LDY_AbsoluteX.rawValue
            memory[0xA001] = 0x73
            memory[0xA002] = 0x19
            memory[0x1993] = testOutput.value
            
            let oldTickcount = cpu.tickcount
            await cpu.runForTicks(4)
            #expect(cpu.tickcount - oldTickcount == 4)
            #expect(cpu.Y == testOutput.value)
            
            let zFlag = await cpu.readFlag(.Z)
            let nFlag = await cpu.readFlag(.N)
            #expect(zFlag == testOutput.Z)
            #expect(nFlag == testOutput.N)
        }
        
        // Bonus page boundary crossing test.
        await cpu.reset()
        cpu.X = 0x20
        memory[0xA000] = Opcodes6502.LDY_AbsoluteX.rawValue
        memory[0xA001] = 0xF0
        memory[0xA002] = 0x19
        memory[0x1A10] = 0x99
        
        let oldTickcount = cpu.tickcount
        await cpu.runForTicks(5)
        #expect(cpu.tickcount - oldTickcount == 5)
        #expect(cpu.Y == 0x99)
        
        let zFlag = await cpu.readFlag(.Z)
        let nFlag = await cpu.readFlag(.N)
        #expect(await zFlag == false)
        #expect(await nFlag == true)
    }
}
