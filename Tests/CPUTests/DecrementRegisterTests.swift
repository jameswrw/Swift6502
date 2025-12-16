//
//  DecrementRegisterTests.swift
//  Swift6502
//
//  Created by James Weatherley on 13/11/2025.
//

import Testing
@testable import Swift6502

struct DecrementRegisterTests {
    @Test func testDEX() async throws {
        let (cpu, memory) = await initCPU()
        defer { memory.deallocate() }
        
        memory[0xA000] = Opcodes6502.DEX.rawValue
        await cpu.setX(0x64)

        await cpu.runForTicks(2)
        var x = await cpu.X
        var zFlag = await cpu.readFlag(.Z)
        var nFlag = await cpu.readFlag(.N)

        #expect(x == 0x63)
        #expect(zFlag == false)
        #expect(nFlag == false)
        
        await cpu.reset()
        memory[0xA000] = Opcodes6502.DEX.rawValue
        await cpu.setX(0x00)

        await cpu.runForTicks(2)
        x = await cpu.X
        zFlag = await cpu.readFlag(.Z)
        nFlag = await cpu.readFlag(.N)

        #expect(x == 0xFF)
        #expect(zFlag == false)
        #expect(nFlag == true)
        
        await cpu.reset()
        memory[0xA000] = Opcodes6502.DEX.rawValue
        await cpu.setX(0x01)

        await cpu.runForTicks(2)
        x = await cpu.X
        zFlag = await cpu.readFlag(.Z)
        nFlag = await cpu.readFlag(.N)

        #expect(x == 0x00)
        #expect(zFlag == true)
        #expect(nFlag == false)
    }
    
    @Test func testDEY() async throws {
        let (cpu, memory) = await initCPU()
        defer { memory.deallocate() }
        
        await cpu.setY(0x64)
        memory[0xA000] = Opcodes6502.DEY.rawValue

        await cpu.runForTicks(2)
        var y = await cpu.Y
        var zFlag = await cpu.readFlag(.Z)
        var nFlag = await cpu.readFlag(.N)

        #expect(y == 0x63)
        #expect(zFlag == false)
        #expect(nFlag == false)
        
        await cpu.reset()
        memory[0xA000] = Opcodes6502.DEY.rawValue
        await cpu.setY(0x00)

        await cpu.runForTicks(2)
        y = await cpu.Y
        zFlag = await cpu.readFlag(.Z)
        nFlag = await cpu.readFlag(.N)

        #expect(y == 0xFF)
        #expect(zFlag == false)
        #expect(nFlag == true)
        
        await cpu.reset()
        memory[0xA000] = Opcodes6502.DEY.rawValue
        await cpu.setY(0x01)

        await cpu.runForTicks(2)
        y = await cpu.Y
        zFlag = await cpu.readFlag(.Z)
        nFlag = await cpu.readFlag(.N)

        #expect(y == 0x00)
        #expect(zFlag == true)
        #expect(nFlag == false)
    }
}

