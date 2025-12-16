//
//  RORTests.swift
//  Swift6502
//
//  Created by James Weatherley on 13/11/2025.
//

import Testing
@testable import Swift6502

struct RORTests {
    @Test func testROR_Accumulator() async throws {
        let (cpu, memory) = await initCPU()
        defer { memory.deallocate() }
        
        // Simple right rotate.
        memory[0xA000] = Opcodes6502.ROR_Accumulator.rawValue
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
        
        // Right rotate zero with carry flag initially unset.
        await cpu.reset()
        memory[0xA000] = Opcodes6502.ROR_Accumulator.rawValue
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
        
        // Right rotate zero with carry flag initially set.
        await cpu.reset()
        memory[0xA000] = Opcodes6502.ROR_Accumulator.rawValue
        await cpu.setA(0x01)
        await cpu.setFlag(.C)
        
        await cpu.runForTicks(2)
        let a3 = await cpu.A
        let z3 = await cpu.readFlag(.Z)
        let n3 = await cpu.readFlag(.N)
        let c3 = await cpu.readFlag(.C)

        #expect(a3 == 0x80)
        #expect(z3 == false)
        #expect(n3 == true)
        #expect(c3 == true)
        
        // Right rotate that sets the zero flag.
        await cpu.reset()
        memory[0xA000] = Opcodes6502.ROR_Accumulator.rawValue
        await cpu.setA(0x00)
        
        await cpu.runForTicks(2)
        let a4 = await cpu.A
        let pc4 = await cpu.PC
        let z4 = await cpu.readFlag(.Z)
        let n4 = await cpu.readFlag(.N)
        let c4 = await cpu.readFlag(.C)

        #expect(a4 == 0x00)
        #expect(pc4 == 0xA001)
        #expect(z4 == true)
        #expect(n4 == false)
        #expect(c4 == false)
    }
    
    @Test func testROR_ZeroPage() async throws {
        let (cpu, memory) = await initCPU()
        defer { memory.deallocate() }
        
        // Simple right rotate.
        memory[0xA000] = Opcodes6502.ROR_ZeroPage.rawValue
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
        
        // Right rotate that sets negative and carry flag.
        await cpu.reset()
        memory[0xA000] = Opcodes6502.ROR_ZeroPage.rawValue
        memory[0xA001] = 0xBB
        memory[0xBB] = 0x01
        
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
        #expect(c2 == true)
        
        // Right rotate that clears the negative flag.
        await cpu.reset()
        await cpu.setFlag(.N)
        memory[0xA000] = Opcodes6502.ROR_ZeroPage.rawValue
        memory[0xA001] = 0xBB
        memory[0xBB] = 0xFE
        
        await cpu.runForTicks(5)
        let mem3 = memory[0xBB]
        let pc3 = await cpu.PC
        let z3 = await cpu.readFlag(.Z)
        let n3 = await cpu.readFlag(.N)
        let c3 = await cpu.readFlag(.C)

        #expect(mem3 == 0x7F)
        #expect(pc3 == 0xA002)
        #expect(z3 == false)
        #expect(n3 == false)
        #expect(c3 == false)
    }
    
    @Test func testROR_ZeroPageX() async throws {
        let (cpu, memory) = await initCPU()
        defer { memory.deallocate() }
        
        // Simple right shift
        await cpu.setX(0x0A)
        memory[0xA000] = Opcodes6502.ROR_ZeroPageX.rawValue
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
        
        // Right rotate that sets negative and carry flags.
        await cpu.reset()
        await cpu.setX(0x0A)
        memory[0xA000] = Opcodes6502.ROR_ZeroPageX.rawValue
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
        
        // Right rotate that clears the negative flag.
        await cpu.reset()
        await cpu.setX(0x0A)
        await cpu.setFlag(.N)
        memory[0xA000] = Opcodes6502.ROR_ZeroPageX.rawValue
        memory[0xA001] = 0x50
        memory[0x5A] = 0xFE
        
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
        #expect(c3 == false)
    }
    
    @Test func testROR_Absolute() async throws {
        let (cpu, memory) = await initCPU()
        defer { memory.deallocate() }
        
        // Simple right rotate.
        memory[0xA000] = Opcodes6502.ROR_Absolute.rawValue
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
        
        // Right rotate that sets negative and carry flags.
        await cpu.reset()
        memory[0xA000] = Opcodes6502.ROR_Absolute.rawValue
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
        
        // Right rotate that clears the negative flag.
        await cpu.reset()
        await cpu.setFlag(.N)
        memory[0xA000] = Opcodes6502.ROR_Absolute.rawValue
        memory[0xA001] = 0x11
        memory[0xA002] = 0x22
        memory[0x2211] = 0xFE
        
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
        #expect(c3 == false)
    }
    
    @Test func testROR_AbsoluteX() async throws {
        let (cpu, memory) = await initCPU()
        defer { memory.deallocate() }
        
        // Simple left rotate
        await cpu.setX(0xAA)
        memory[0xA000] = Opcodes6502.ROR_AbsoluteX.rawValue
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
        
        // Right rotate that sets negative and carry flags.
        await cpu.reset()
        await cpu.setX(0xAA)
        memory[0xA000] = Opcodes6502.ROR_AbsoluteX.rawValue
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
        
        // Right rotate that clears the negative flag.
        await cpu.reset()
        await cpu.setX(0xAA)
        await cpu.setFlag(.N)
        memory[0xA000] = Opcodes6502.LSR_AbsoluteX.rawValue
        memory[0xA001] = 0x50
        memory[0xA002] = 0x50
        memory[0x50FA] = 0xFE
        
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
        #expect(c3 == false)
    }
}

