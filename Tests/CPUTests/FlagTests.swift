//
//  FlagTests.swift
//  Swift6502
//
//  Created by James Weatherley on 13/11/2025.
//

import Testing
@testable import Swift6502

struct FlagTests {
    @Test func testCLC() async throws {
        let (cpu, memory) = await initCPU()
        defer { memory.deallocate() }
        
        memory[0xA000] = Opcodes6502.CLC.rawValue
        await cpu.setFlag(.C)
        let cBefore = await cpu.readFlag(.C)
        
        #expect(cBefore == true)
        
        await cpu.runForTicks(2)
        let pc = await cpu.PC
        let cAfter = await cpu.readFlag(.C)
        
        #expect(pc == 0xA001)
        #expect(cAfter == false)
    }
    
    @Test func testCLD() async throws {
        let (cpu, memory) = await initCPU()
        defer { memory.deallocate() }
        
        memory[0xA000] = Opcodes6502.CLD.rawValue
        await cpu.setFlag(.D)
        let dBefore = await cpu.readFlag(.D)
        
        #expect(dBefore == true)
        
        await cpu.runForTicks(2)
        let pc = await cpu.PC
        let dAfter = await cpu.readFlag(.D)
        
        #expect(pc == 0xA001)
        #expect(dAfter == false)
    }
    
    @Test func testCLI() async throws {
        let (cpu, memory) = await initCPU()
        defer { memory.deallocate() }
    
        memory[0xA000] = Opcodes6502.CLI.rawValue
        let iBefore1 = await cpu.readFlag(.I)
        #expect(iBefore1 == true)
        await cpu.setFlag(.I)
        let iBefore2 = await cpu.readFlag(.I)
        #expect(iBefore2 == true)
        
        await cpu.runForTicks(2)
        let pc = await cpu.PC
        let iAfter = await cpu.readFlag(.I)
        
        #expect(pc == 0xA001)
        #expect(iAfter == false)
    }
    
    @Test func testCLV() async throws {
        let (cpu, memory) = await initCPU()
        defer { memory.deallocate() }
        
        memory[0xA000] = Opcodes6502.CLV.rawValue
        await cpu.setFlag(.V)
        let vBefore = await cpu.readFlag(.V)
        
        #expect(vBefore == true)
        
        await cpu.runForTicks(2)
        let pc = await cpu.PC
        let vAfter = await cpu.readFlag(.V)
        
        #expect(pc == 0xA001)
        #expect(vAfter == false)
    }
    
    @Test func testSEC() async throws {
        let (cpu, memory) = await initCPU()
        defer { memory.deallocate() }
        
        memory[0xA000] = Opcodes6502.SEC.rawValue
        let cBefore = await cpu.readFlag(.C)
        
        #expect(cBefore == false)
        
        await cpu.runForTicks(2)
        let pc = await cpu.PC
        let cAfter = await cpu.readFlag(.C)
        
        #expect(pc == 0xA001)
        #expect(cAfter == true)
    }
    
    @Test func testSED() async throws {
        let (cpu, memory) = await initCPU()
        defer { memory.deallocate() }
        
        memory[0xA000] = Opcodes6502.SED.rawValue
        let dBefore = await cpu.readFlag(.D)
        
        #expect(dBefore == false)

        await cpu.runForTicks(2)
        let pc = await cpu.PC
        let dAfter = await cpu.readFlag(.D)
        
        #expect(pc == 0xA001)
        #expect(dAfter == true)
    }
    
    @Test func testSEI() async throws {
        let (cpu, memory) = await initCPU()
        defer { memory.deallocate() }
        
        memory[0xA000] = Opcodes6502.SEI.rawValue
        let iBefore = await cpu.readFlag(.I)
        
        #expect(iBefore == true)
        
        await cpu.runForTicks(2)
        let pc = await cpu.PC
        let iAfter = await cpu.readFlag(.I)
        
        #expect(pc == 0xA001)
        #expect(iAfter == true)

    }
}

