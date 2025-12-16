//
//  IncrementRegisterTests.swift
//  Swift6502
//
//  Created by James Weatherley on 13/11/2025.
//

import Testing
@testable import Swift6502

struct IncrementRegisterTests {
    @Test func testINX() async throws {
        let (cpu, memory) = await initCPU()
        defer { memory.deallocate() }
        
        memory[0xA000] = Opcodes6502.INX.rawValue
        await cpu.setX(0x64)

        await cpu.runForTicks(2)
        let x = await cpu.X
        let zFlag = await cpu.readFlag(.Z)
        let nFlag = await cpu.readFlag(.N)

        #expect(x == 0x65)
        #expect(zFlag == false)
        #expect(nFlag == false)
        
        await cpu.reset()
        memory[0xA000] = Opcodes6502.INX.rawValue
        await cpu.setX(0xFF)

        await cpu.runForTicks(2)
        let x2 = await cpu.X
        let zFlag2 = await cpu.readFlag(.Z)
        let nFlag2 = await cpu.readFlag(.N)

        #expect(x2 == 0x00)
        #expect(zFlag2 == true)
        #expect(nFlag2 == false)
        
        await cpu.reset()
        memory[0xA000] = Opcodes6502.INX.rawValue
        await cpu.setX(0x7F)

        await cpu.runForTicks(2)
        let x3 = await cpu.X
        let zFlag3 = await cpu.readFlag(.Z)
        let nFlag3 = await cpu.readFlag(.N)

        #expect(x3 == 0x80)
        #expect(zFlag3 == false)
        #expect(nFlag3 == true)
    }
    
    @Test func testINY() async throws {
        let (cpu, memory) = await initCPU()
        defer { memory.deallocate() }
        
        memory[0xA000] = Opcodes6502.INY.rawValue
        await cpu.setY(0x64)

        await cpu.runForTicks(2)
        let y = await cpu.Y
        let zFlag = await cpu.readFlag(.Z)
        let nFlag = await cpu.readFlag(.N)

        #expect(y == 0x65)
        #expect(zFlag == false)
        #expect(nFlag == false)
        
        await cpu.reset()
        memory[0xA000] = Opcodes6502.INY.rawValue
        await cpu.setY(0xFF)

        await cpu.runForTicks(2)
        let y2 = await cpu.Y
        let zFlag2 = await cpu.readFlag(.Z)
        let nFlag2 = await cpu.readFlag(.N)

        #expect(y2 == 0x00)
        #expect(zFlag2 == true)
        #expect(nFlag2 == false)
        
        await cpu.reset()
        memory[0xA000] = Opcodes6502.INY.rawValue
        await cpu.setY(0x7F)

        await cpu.runForTicks(2)
        let y3 = await cpu.Y
        let zFlag3 = await cpu.readFlag(.Z)
        let nFlag3 = await cpu.readFlag(.N)

        #expect(y3 == 0x80)
        #expect(zFlag3 == false)
        #expect(nFlag3 == true)
    }
}

