//
//  StackTests.swift
//  Swift6502
//
//  Created by James Weatherley on 13/11/2025.
//

import Testing
@testable import Swift6502

struct StackTests {
    @Test func testTSX() async throws {
        let (cpu, memory) = await initCPU()
        defer { memory.deallocate() }
        
        await cpu.setX(0x42)
        memory[0xA000] = Opcodes6502.TSX.rawValue
        
        await cpu.runForTicks(2)
        let x = await cpu.X
        let sp = await cpu.SP
        let f = await cpu.F

        #expect(x == 0xFF)
        #expect(sp == 0xFF)
        #expect(f == Flags.One.rawValue | Flags.I.rawValue)
    }
    
    @Test func testTXS() async throws {
        let (cpu, memory) = await initCPU()
        defer { memory.deallocate() }
        
        await cpu.setX(0x42)
        memory[0xA000] = Opcodes6502.TXS.rawValue

        await cpu.runForTicks(2)
        let x = await cpu.X
        let sp = await cpu.SP
        let f = await cpu.F

        #expect(x == 0x42)
        #expect(sp == 0x42)
        #expect(f == Flags.One.rawValue | Flags.I.rawValue)
    }
    
    @Test func testPHA() async throws {
        let (cpu, memory) = await initCPU()
        defer { memory.deallocate() }
        
        await cpu.setA(0x73)
        memory[0xA000] = Opcodes6502.PHA.rawValue
        memory[0x1FF] = 0x00
        
        await cpu.runForTicks(3)
        let a = await cpu.A
        let sp = await cpu.SP

        #expect(a == 0x73)
        #expect(sp == 0xFE)
        #expect(memory[0x1FF] == 0x73)
    }
    
    @Test func testPLA() async throws {
        let (cpu, memory) = await initCPU()
        defer { memory.deallocate() }
        
        await cpu.setSP(0xFE)
        memory[0xA000] = Opcodes6502.PLA.rawValue
        memory[0x1FF] = 0xFF
        
        await cpu.runForTicks(4)
        let a = await cpu.A
        let sp = await cpu.SP

        #expect(a == 0xFF)
        #expect(sp == 0xFF)
    }
    
    @Test func testPHP() async throws {
        let (cpu, memory) = await initCPU()
        defer { memory.deallocate() }
        
        memory[0xA000] = Opcodes6502.PHP.rawValue
        memory[0x1FF] = 0x00
        let oldFlags = await cpu.F
        await cpu.runForTicks(3)
        let sp = await cpu.SP

        #expect(sp == 0xFE)
        #expect(memory[0x1FF] == oldFlags | Flags.One.rawValue | Flags.B.rawValue)
    }
    
    @Test func testPLP() async throws {
        let (cpu, memory) = await initCPU()
        defer { memory.deallocate() }
        
        await cpu.setSP(0xFE)
        memory[0xA000] = Opcodes6502.PLP.rawValue
        memory[0x1FF] = 0xAA
        
        await cpu.runForTicks(4)
        let sp = await cpu.SP
        let f = await cpu.F

        #expect(sp == 0xFF)
        #expect(f == 0xAA)
    }
}

