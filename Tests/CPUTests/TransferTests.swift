//
//  TransferTests.swift
//  Swift6502
//
//  Created by James Weatherley on 13/11/2025.
//

import Testing
@testable import Swift6502

struct TransferTests {
    @Test func testTAX() async throws {
        let (cpu, memory) = await initCPU()
        defer { memory.deallocate() }
        
        await cpu.setA(0x64)
        memory[0xA000] = Opcodes6502.TAX.rawValue

        await cpu.runForTicks(2)
        
        var a = await cpu.A
        var x = await cpu.X
        var zFlag = await cpu.readFlag(.Z)
        var nFlag = await cpu.readFlag(.N)
        
        #expect(a == 0x64)
        #expect(x == 0x64)
        #expect(zFlag == false)
        #expect(nFlag == false)
        
        await cpu.reset()
        await cpu.setA(0x00)
        await cpu.setX(0x12)
        memory[0xA000] = Opcodes6502.TAX.rawValue

        await cpu.runForTicks(2)
        
        a = await cpu.A
        x = await cpu.X
        zFlag = await cpu.readFlag(.Z)
        nFlag = await cpu.readFlag(.N)
        
        #expect(a == 0)
        #expect(x == 0)
        #expect(zFlag == true)
        #expect(nFlag == false)
        
        await cpu.reset()
        await cpu.setA(0xFF)
        memory[0xA000] = Opcodes6502.TAX.rawValue

        await cpu.runForTicks(2)
        
        a = await cpu.A
        x = await cpu.X
        zFlag = await cpu.readFlag(.Z)
        nFlag = await cpu.readFlag(.N)
        
        #expect(a == 0xFF)
        #expect(x == 0xFF)
        #expect(zFlag == false)
        #expect(nFlag == true)
    }
    
    @Test func testTXA() async throws {
        let (cpu, memory) = await initCPU()
        defer { memory.deallocate() }
        
        await cpu.setX(0x64)
        memory[0xA000] = Opcodes6502.TXA.rawValue

        await cpu.runForTicks(2)
        
        var a = await cpu.A
        var x = await cpu.X
        var zFlag = await cpu.readFlag(.Z)
        var nFlag = await cpu.readFlag(.N)
        
        #expect(a == 0x64)
        #expect(x == 0x64)
        #expect(zFlag == false)
        #expect(nFlag == false)
        
        await cpu.reset()
        await cpu.setX(0x00)
        await cpu.setA(0x12)
        memory[0xA000] = Opcodes6502.TXA.rawValue

        await cpu.runForTicks(2)
        
        a = await cpu.A
        x = await cpu.X
        zFlag = await cpu.readFlag(.Z)
        nFlag = await cpu.readFlag(.N)
        
        #expect(a == 0)
        #expect(x == 0)
        #expect(zFlag == true)
        #expect(nFlag == false)
        
        await cpu.reset()
        await cpu.setA(0x12)
        await cpu.setX(0xFF)
        memory[0xA000] = Opcodes6502.TXA.rawValue

        await cpu.runForTicks(2)
        
        a = await cpu.A
        x = await cpu.X
        zFlag = await cpu.readFlag(.Z)
        nFlag = await cpu.readFlag(.N)
        
        #expect(a == 0xFF)
        #expect(x == 0xFF)
        #expect(zFlag == false)
        #expect(nFlag == true)
    }
    
    @Test func testTAY() async throws {
        let (cpu, memory) = await initCPU()
        defer { memory.deallocate() }
        
        await cpu.setA(0x64)
        memory[0xA000] = Opcodes6502.TAY.rawValue

        await cpu.runForTicks(2)
        
        var a = await cpu.A
        var y = await cpu.Y
        var zFlag = await cpu.readFlag(.Z)
        var nFlag = await cpu.readFlag(.N)
        
        #expect(a == 0x64)
        #expect(y == 0x64)
        #expect(zFlag == false)
        #expect(nFlag == false)
        
        await cpu.reset()
        await cpu.setA(0x00)
        await cpu.setY(0x12)
        memory[0xA000] = Opcodes6502.TAY.rawValue

        await cpu.runForTicks(2)
        
        a = await cpu.A
        y = await cpu.Y
        zFlag = await cpu.readFlag(.Z)
        nFlag = await cpu.readFlag(.N)

        #expect(a == 0)
        #expect(y == 0)
        #expect(zFlag == true)
        #expect(nFlag == false)
        
        await cpu.reset()
        await cpu.setA(0xFF)
        memory[0xA000] = Opcodes6502.TAY.rawValue

        await cpu.runForTicks(2)
        
        a = await cpu.A
        y = await cpu.Y
        zFlag = await cpu.readFlag(.Z)
        nFlag = await cpu.readFlag(.N)
        
        #expect(a == 0xFF)
        #expect(y == 0xFF)
        #expect(zFlag == false)
        #expect(nFlag == true)
    }
    
    @Test func testTYA() async throws {
        let (cpu, memory) = await initCPU()
        defer { memory.deallocate() }
        
        await cpu.setY(0x64)
        memory[0xA000] = Opcodes6502.TYA.rawValue

        await cpu.runForTicks(2)
        
        var a = await cpu.A
        var y = await cpu.Y
        var zFlag = await cpu.readFlag(.Z)
        var nFlag = await cpu.readFlag(.N)
        
        #expect(a == 0x64)
        #expect(y == 0x64)
        #expect(zFlag == false)
        #expect(nFlag == false)
        
        await cpu.reset()
        await cpu.setY(0x00)
        await cpu.setA(0x12)
        memory[0xA000] = Opcodes6502.TYA.rawValue

        await cpu.runForTicks(2)
        
        a = await cpu.A
        y = await cpu.Y
        zFlag = await cpu.readFlag(.Z)
        nFlag = await cpu.readFlag(.N)
        
        #expect(a == 0)
        #expect(y == 0)
        #expect(zFlag == true)
        #expect(nFlag == false)
        
        await cpu.reset()
        await cpu.setA(0x12)
        await cpu.setY(0xFF)
        memory[0xA000] = Opcodes6502.TYA.rawValue

        await cpu.runForTicks(2)
        
        a = await cpu.A
        y = await cpu.Y
        zFlag = await cpu.readFlag(.Z)
        nFlag = await cpu.readFlag(.N)
        
        #expect(a == 0xFF)
        #expect(y == 0xFF)
        #expect(zFlag == false)
        #expect(nFlag == true)
    }
}
