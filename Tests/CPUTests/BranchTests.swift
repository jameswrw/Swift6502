//
//  BranchTests.swift
//  Swift6502
//
//  Created by James Weatherley on 14/11/2025.
//

import Testing
@testable import Swift6502

// With all the branch tests give ourselves some space by first doing a JMP away from the rest vector.
//
// From: http://www.6502.org/tutorials/6502opcodes.html#PC
// When calculating branches a forward branch of 6 skips the following 6 bytes so, effectively the program counter points to the address that is 8 bytes beyond the address of the branch opcode; and a backward branch of $FA (256-6) goes to an address 4 bytes before the branch instruction.
//
// For example in the first test the branch instruction is at 0x1234 and the delta is 0x10, but we end up at 0x1246 as we jump from where the PC is once it has read the opcode and operand, and not from the addresss of the opcode.
//
// Also, these tests explicity check the tickcount as it varied depending on whether the branch was taken or not, and if so did it cross a page boundary.

struct BranchTests {
    
    // All the flag tests are very similar, so consolidate them into a shared utility function.
    func testBranch(flag: Flags, branchIfFlagSet: Bool, opcode: Opcodes6502) async throws {
        let (cpu, memory) = await initCPU()
        defer { memory.deallocate() }
        
        // Simple branch forwards.
        memory[0xA000] = Opcodes6502.JMP_Absolute.rawValue
        memory[0xA001] = 0x34
        memory[0xA002] = 0x12
        memory[0x1234] = opcode.rawValue
        memory[0x1235] = 0x10
        branchIfFlagSet ? await cpu.setFlag(flag) : await cpu.clearFlag(flag)

        // JMP to 0x1234
        await cpu.runForTicks(3)
        let pcAfterJmp1 = await cpu.PC

        #expect(pcAfterJmp1 == 0x1234)
        
        var oldTickcount = await cpu.tickcount
        await cpu.runForTicks(3)
        let pcAfterBranchFwd = await cpu.PC
        let tickDelta1 = await cpu.tickcount - oldTickcount

        #expect(pcAfterBranchFwd == 0x1246)
        #expect(tickDelta1 == 3)

        // Simple branch backwards.
        await cpu.reset()
        memory[0xA000] = Opcodes6502.JMP_Absolute.rawValue
        memory[0xA001] = 0x34
        memory[0xA002] = 0x12
        memory[0x1234] = opcode.rawValue
        memory[0x1235] = 0xF0   // -0x10
        branchIfFlagSet ? await cpu.setFlag(flag) : await cpu.clearFlag(flag)
        
        // JMP to 0x1234
        await cpu.runForTicks(3)
        let pcAfterJmp2 = await cpu.PC

        #expect(pcAfterJmp2 == 0x1234)
        
        oldTickcount = await cpu.tickcount
        await cpu.runForTicks(3)
        let pcAfterBranchBack = await cpu.PC
        let tickDelta2 = await cpu.tickcount - oldTickcount

        #expect(pcAfterBranchBack == 0x1226)
        #expect(tickDelta2 == 3)
        
        // Branch forwards with a page change.
        await cpu.reset()
        memory[0xA000] = Opcodes6502.JMP_Absolute.rawValue
        memory[0xA001] = 0xF0
        memory[0xA002] = 0x10
        memory[0x10F0] = opcode.rawValue
        memory[0x10F1] = 0x10
        branchIfFlagSet ? await cpu.setFlag(flag) : await cpu.clearFlag(flag)

        // JMP to 0x10F0
        await cpu.runForTicks(3)
        let pcAfterJmp3 = await cpu.PC

        #expect(pcAfterJmp3 == 0x10F0)
        
        let ticks = (opcode == .BVC ? 3 : 4)
        oldTickcount = await cpu.tickcount
        await cpu.runForTicks(ticks)
        let pcAfterBranchFwdPg = await cpu.PC
        let tickDelta3 = await cpu.tickcount - oldTickcount

        #expect(pcAfterBranchFwdPg == 0x1102)
        #expect(tickDelta3 == ticks)
        
        // Branch backwards with a page change.
        await cpu.reset()
        memory[0xA000] = Opcodes6502.JMP_Absolute.rawValue
        memory[0xA001] = 0x10
        memory[0xA002] = 0x10
        memory[0x1010] = opcode.rawValue
        memory[0x1011] = 0xE0   // -0x20
        branchIfFlagSet ? await cpu.setFlag(flag) : await cpu.clearFlag(flag)

        // JMP to 0x1010
        await cpu.runForTicks(3)
        let pcAfterJmp4 = await cpu.PC

        #expect(pcAfterJmp4 == 0x1010)
        
        oldTickcount = await cpu.tickcount
        await cpu.runForTicks(ticks)
        let pcAfterBranchBackPg = await cpu.PC
        let tickDelta4 = await cpu.tickcount - oldTickcount

        #expect(pcAfterBranchBackPg == 0xFF2)
        #expect(tickDelta4 == ticks)
        
        // Test no branch if flag state is different from branchIfFlagSet.
        await cpu.reset()
        memory[0xA000] = Opcodes6502.JMP_Absolute.rawValue
        memory[0xA001] = 0x34
        memory[0xA002] = 0x12
        memory[0x1234] = opcode.rawValue
        memory[0x1235] = 0x10
        branchIfFlagSet ? await cpu.clearFlag(flag) : await cpu.setFlag(flag)

        // JMP to 0x1234
        await cpu.runForTicks(3)
        let pcAfterJmp5 = await cpu.PC

        #expect(pcAfterJmp5 == 0x1234)
        
        oldTickcount = await cpu.tickcount
        await cpu.runForTicks(2)
        let pcAfterNoBranch = await cpu.PC
        let tickDelta5 = await cpu.tickcount - oldTickcount

        #expect(pcAfterNoBranch == 0x1236)
        #expect(tickDelta5 == 2)
    }
    
    @Test func testBCC() async throws {
        try await testBranch(flag: .C, branchIfFlagSet: false, opcode: .BCC)
    }
    
    @Test func testBCS() async throws {
        try await testBranch(flag: .C, branchIfFlagSet: true, opcode: .BCS)
    }
    
    @Test func testBEQ() async throws {
        try await testBranch(flag: .Z, branchIfFlagSet: true, opcode: .BEQ)
    }
    
    @Test func testBNE() async throws {
        try await testBranch(flag: .Z, branchIfFlagSet: false, opcode: .BNE)
    }
    
    @Test func testBMI() async throws {
        try await testBranch(flag: .N, branchIfFlagSet: true, opcode: .BMI)
    }
    
    @Test func testBPL() async throws {
        try await testBranch(flag: .N, branchIfFlagSet: false, opcode: .BPL)
    }
    
    @Test func testBVC() async throws {
        try await testBranch(flag: .V, branchIfFlagSet: false, opcode: .BVC)
    }
    
    @Test func testBVS() async throws {
        try await testBranch(flag: .V, branchIfFlagSet: true, opcode: .BVS)
    }
}

