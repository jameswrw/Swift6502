//
//  LSRests.swift
//  Swift6502
//
//  Created by James Weatherley on 13/11/2025.
//

import Testing
@testable import Swift6502

struct LSRTests {
    @Test func testLSR_Accumulator() async throws {
        let (cpu, memory) = await initCPU()
        defer { memory.deallocate() }
        
        // Simple right shift.
        memory[0xA000] = Opcodes6502.LSR_Accumulator.rawValue
        await cpu.setA(0x08)
        
        await cpu.runForTicks(2)
        let a1 = await cpu.A
        let z1 = await cpu.readFlag(.Z)
        let n1 = await cpu.readFlag(.N)
        let c1 = await cpu.readFlag(.C)

        #expect(a1 == 0x04)
        #expect(z1 == false)
        #expect(n1 == false)
        #expect(c1 == false)
        
        // Right shift that sets zero and carry flags.
        await cpu.reset()
        memory[0xA000] = Opcodes6502.LSR_Accumulator.rawValue
        await cpu.setA(0x01)
        
        await cpu.runForTicks(2)
        let a2 = await cpu.A
        let z2 = await cpu.readFlag(.Z)
        let n2 = await cpu.readFlag(.N)
        let c2 = await cpu.readFlag(.C)

        #expect(a2 == 0x00)
        #expect(z2 == true)
        #expect(n2 == false)
        #expect(c2 == true)
        
        // Right shift can't set the negative flag but it can clear it.
        await cpu.reset()
        memory[0xA000] = Opcodes6502.LSR_Accumulator.rawValue
        await cpu.setA(0xFF)
        await cpu.setFlag(.N)
        
        await cpu.runForTicks(2)
        let a3 = await cpu.A
        let pc3 = await cpu.PC
        let z3 = await cpu.readFlag(.Z)
        let n3 = await cpu.readFlag(.N)
        let c3 = await cpu.readFlag(.C)

        #expect(a3 == 0x7F)
        #expect(pc3 == 0xA001)
        #expect(z3 == false)
        #expect(n3 == false)
        #expect(c3 == true)
    }
    
    @Test func testLSR_ZeroPage() async throws {
        let (cpu, memory) = await initCPU()
        defer { memory.deallocate() }
        
        // Simple right shift.
        memory[0xA000] = Opcodes6502.LSR_ZeroPage.rawValue
        memory[0xA001] = 0xBB
        memory[0xBB] = 0x42
        
        await cpu.runForTicks(5)
        let mem1 = memory[0xBB]
        let pc1 = await cpu.PC
        let z1 = await cpu.readFlag(.Z)
        let n1 = await cpu.readFlag(.N)
        let c1 = await cpu.readFlag(.C)

        #expect(mem1 == 0x21)
        #expect(pc1 == 0xA002)
        #expect(z1 == false)
        #expect(n1 == false)
        #expect(c1 == false)
        
        // Right shift a value of zero. This broke when Carry was set.
        await cpu.reset()
        await cpu.setFlag(.C)
        memory[0xA000] = Opcodes6502.LSR_ZeroPage.rawValue
        memory[0xA001] = 0xBB
        memory[0xBB] = 0x00
        
        await cpu.runForTicks(5)
        let mem2 = memory[0xBB]
        let pc2 = await cpu.PC
        let z2 = await cpu.readFlag(.Z)
        let n2 = await cpu.readFlag(.N)
        let c2 = await cpu.readFlag(.C)

        #expect(mem2 == 0x00)
        #expect(pc2 == 0xA002)
        #expect(z2 == true)
        #expect(n2 == false)
        #expect(c2 == false)
        
        // Right shift that sets zero and carry flags.
        await cpu.reset()
        memory[0xA000] = Opcodes6502.LSR_ZeroPage.rawValue
        memory[0xA001] = 0xBB
        memory[0xBB] = 0x01
        await cpu.setFlag(.N)
        
        await cpu.runForTicks(5)
        let mem3 = memory[0xBB]
        let pc3 = await cpu.PC
        let z3 = await cpu.readFlag(.Z)
        let n3 = await cpu.readFlag(.N)
        let c3 = await cpu.readFlag(.C)

        #expect(mem3 == 0x00)
        #expect(pc3 == 0xA002)
        #expect(z3 == true)
        #expect(n3 == false)
        #expect(c3 == true)
        
        // Right shift can't set the negative flag but it can clear it.
        await cpu.reset()
        await cpu.setFlag(.N)
        memory[0xA000] = Opcodes6502.LSR_ZeroPage.rawValue
        memory[0xA001] = 0xBB
        memory[0xBB] = 0xFF
        
        await cpu.runForTicks(5)
        let mem4 = memory[0xBB]
        let pc4 = await cpu.PC
        let z4 = await cpu.readFlag(.Z)
        let n4 = await cpu.readFlag(.N)
        let c4 = await cpu.readFlag(.C)

        #expect(mem4 == 0x7F)
        #expect(pc4 == 0xA002)
        #expect(z4 == false)
        #expect(n4 == false)
        #expect(c4 == true)
    }
    
    @Test func testLSR_ZeroPageX() async throws {
        let (cpu, memory) = await initCPU()
        defer { memory.deallocate() }
        
        // Simple right shift
        await cpu.setX(0x0A)
        memory[0xA000] = Opcodes6502.LSR_ZeroPageX.rawValue
        memory[0xA001] = 0x50
        memory[0x5A] = 0x04
        
        await cpu.runForTicks(6)
        let mem1 = memory[0x5A]
        let pc1 = await cpu.PC
        let z1 = await cpu.readFlag(.Z)
        let n1 = await cpu.readFlag(.N)
        let c1 = await cpu.readFlag(.C)

        #expect(mem1 == 0x02)
        #expect(pc1 == 0xA002)
        #expect(z1 == false)
        #expect(n1 == false)
        #expect(c1 == false)
        
        // Right shift that sets zero and carry flags.
        await cpu.reset()
        await cpu.setX(0x0A)
        memory[0xA000] = Opcodes6502.LSR_ZeroPageX.rawValue
        memory[0xA001] = 0x50
        memory[0x5A] = 0x01
        
        await cpu.runForTicks(6)
        let mem2 = memory[0x5A]
        let pc2 = await cpu.PC
        let z2 = await cpu.readFlag(.Z)
        let n2 = await cpu.readFlag(.N)
        let c2 = await cpu.readFlag(.C)

        #expect(mem2 == 0x00)
        #expect(pc2 == 0xA002)
        #expect(z2 == true)
        #expect(n2 == false)
        #expect(c2 == true)
        
        // Right shift can't set the negative flag but it can clear it.
        await cpu.reset()
        await cpu.setX(0x0A)
        await cpu.setFlag(.N)
        memory[0xA000] = Opcodes6502.LSR_ZeroPageX.rawValue
        memory[0xA001] = 0x50
        memory[0x5A] = 0xFF
        
        await cpu.runForTicks(6)
        let mem3 = memory[0x5A]
        let pc3 = await cpu.PC
        let z3 = await cpu.readFlag(.Z)
        let n3 = await cpu.readFlag(.N)
        let c3 = await cpu.readFlag(.C)

        #expect(mem3 == 0x7F)
        #expect(pc3 == 0xA002)
        #expect(z3 == false)
        #expect(n3 == false)
        #expect(c3 == true)
    }
    
    @Test func testLSR_Absolute() async throws {
        let (cpu, memory) = await initCPU()
        defer { memory.deallocate() }
        
        // Simple right shift.
        memory[0xA000] = Opcodes6502.LSR_Absolute.rawValue
        memory[0xA001] = 0x11
        memory[0xA002] = 0x22
        memory[0x2211] = 0x08
        
        await cpu.runForTicks(6)
        let mem1 = memory[0x2211]
        let pc1 = await cpu.PC
        let z1 = await cpu.readFlag(.Z)
        let n1 = await cpu.readFlag(.N)
        let c1 = await cpu.readFlag(.C)

        #expect(mem1 == 0x04)
        #expect(pc1 == 0xA003)
        #expect(z1 == false)
        #expect(n1 == false)
        #expect(c1 == false)
        
        // Right shift that sets zero and carry flags.
        await cpu.reset()
        memory[0xA000] = Opcodes6502.LSR_Absolute.rawValue
        memory[0xA001] = 0x11
        memory[0xA002] = 0x22
        memory[0x2211] = 0x01
        
        await cpu.runForTicks(6)
        let mem2 = memory[0x2211]
        let pc2 = await cpu.PC
        let z2 = await cpu.readFlag(.Z)
        let n2 = await cpu.readFlag(.N)
        let c2 = await cpu.readFlag(.C)

        #expect(mem2 == 0x00)
        #expect(pc2 == 0xA003)
        #expect(z2 == true)
        #expect(n2 == false)
        #expect(c2 == true)
        
        // Right shift can't set the negative flag but it can clear it.
        await cpu.reset()
        await cpu.setFlag(.N)
        memory[0xA000] = Opcodes6502.LSR_Absolute.rawValue
        memory[0xA001] = 0x11
        memory[0xA002] = 0x22
        memory[0x2211] = 0xFF
        
        await cpu.runForTicks(6)
        let mem3 = memory[0x2211]
        let pc3 = await cpu.PC
        let z3 = await cpu.readFlag(.Z)
        let n3 = await cpu.readFlag(.N)
        let c3 = await cpu.readFlag(.C)

        #expect(mem3 == 0x7F)
        #expect(pc3 == 0xA003)
        #expect(z3 == false)
        #expect(n3 == false)
        #expect(c3 == true)
    }
    
    @Test func testLSR_AbsoluteX() async throws {
        let (cpu, memory) = await initCPU()
        defer { memory.deallocate() }
        
        // Simple left shift
        await cpu.setX(0xAA)
        memory[0xA000] = Opcodes6502.LSR_AbsoluteX.rawValue
        memory[0xA001] = 0x50
        memory[0xA002] = 0x50
        memory[0x50FA] = 0x04
        
        await cpu.runForTicks(7)
        let mem1 = memory[0x50FA]
        let pc1 = await cpu.PC
        let z1 = await cpu.readFlag(.Z)
        let n1 = await cpu.readFlag(.N)
        let c1 = await cpu.readFlag(.C)

        #expect(mem1 == 0x02)
        #expect(pc1 == 0xA003)
        #expect(z1 == false)
        #expect(n1 == false)
        #expect(c1 == false)
        
        // Right shift that sets zero and carry flags.
        await cpu.reset()
        await cpu.setX(0xAA)
        memory[0xA000] = Opcodes6502.LSR_AbsoluteX.rawValue
        memory[0xA001] = 0x50
        memory[0xA002] = 0x50
        memory[0x50FA] = 0x01
        
        await cpu.runForTicks(7)
        let mem2 = memory[0x50FA]
        let pc2 = await cpu.PC
        let z2 = await cpu.readFlag(.Z)
        let n2 = await cpu.readFlag(.N)
        let c2 = await cpu.readFlag(.C)

        #expect(mem2 == 0x00)
        #expect(pc2 == 0xA003)
        #expect(z2 == true)
        #expect(n2 == false)
        #expect(c2 == true)
        
        // Right shift can't set the negative flag but it can clear it.
        await cpu.reset()
        await cpu.setX(0xAA)
        await cpu.setFlag(.N)
        memory[0xA000] = Opcodes6502.LSR_AbsoluteX.rawValue
        memory[0xA001] = 0x50
        memory[0xA002] = 0x50
        memory[0x50FA] = 0xFF
        
        await cpu.runForTicks(7)
        let mem3 = memory[0x50FA]
        let pc3 = await cpu.PC
        let z3 = await cpu.readFlag(.Z)
        let n3 = await cpu.readFlag(.N)
        let c3 = await cpu.readFlag(.C)

        #expect(mem3 == 0x7F)
        #expect(pc3 == 0xA003)
        #expect(z3 == false)
        #expect(n3 == false)
        #expect(c3 == true)
    }
}

