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
        let (cpu, memory) = initCPU()
        defer { memory.deallocate() }
        
        memory[0xA000] = Opcodes6502.CLC.rawValue
        await cpu.setFlag(.C)
        #expect(await cpu.readFlag(.C) == true)
        
        await cpu.runForTicks(2)
        #expect(cpu.PC == 0xA001)
        #expect(await cpu.readFlag(.C) == false)
    }
    
    @Test func testCLD() async throws {
        let (cpu, memory) = initCPU()
        defer { memory.deallocate() }
        
        memory[0xA000] = Opcodes6502.CLD.rawValue
        await cpu.setFlag(.D)
        #expect(await cpu.readFlag(.D) == true)
        
        await cpu.runForTicks(2)
        #expect(cpu.PC == 0xA001)
        #expect(await cpu.readFlag(.D) == false)
    }
    
    @Test func testCLI() async throws {
        let (cpu, memory) = initCPU()
        defer { memory.deallocate() }
    
        memory[0xA000] = Opcodes6502.CLI.rawValue
        #expect(await cpu.readFlag(.I) == true)
        await cpu.setFlag(.I)
        #expect(await cpu.readFlag(.I) == true)
        
        await cpu.runForTicks(2)
        #expect(cpu.PC == 0xA001)
        #expect(await cpu.readFlag(.I) == false)
    }
    
    @Test func testCLV() async throws {
        let (cpu, memory) = initCPU()
        defer { memory.deallocate() }
        
        memory[0xA000] = Opcodes6502.CLV.rawValue
        await cpu.setFlag(.V)
        #expect(await cpu.readFlag(.V) == true)
        
        await cpu.runForTicks(2)
        #expect(cpu.PC == 0xA001)
        #expect(await cpu.readFlag(.V) == false)
    }
    
    @Test func testSEC() async throws {
        let (cpu, memory) = initCPU()
        defer { memory.deallocate() }
        
        memory[0xA000] = Opcodes6502.SEC.rawValue
        #expect(await cpu.readFlag(.C) == false)
        
        await cpu.runForTicks(2)
        #expect(cpu.PC == 0xA001)
        #expect(await cpu.readFlag(.C) == true)
    }
    
    @Test func testSED() async throws {
        let (cpu, memory) = initCPU()
        defer { memory.deallocate() }
        
        memory[0xA000] = Opcodes6502.SED.rawValue
        #expect(await cpu.readFlag(.D) == false)

        await cpu.runForTicks(2)
        #expect(cpu.PC == 0xA001)
        #expect(await cpu.readFlag(.D) == true)
    }
    
    @Test func testSEI() async throws {
        let (cpu, memory) = initCPU()
        defer { memory.deallocate() }
        
        memory[0xA000] = Opcodes6502.SEI.rawValue
        #expect(await cpu.readFlag(.I) == true)
        
        await cpu.runForTicks(2)
        #expect(cpu.PC == 0xA001)
        #expect(await cpu.readFlag(.I) == true)

    }
}
