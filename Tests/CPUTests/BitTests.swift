//
//  BitTests.swift
//  Swift6502
//
//  Created by James Weatherley on 14/11/2025.
//

import Testing
@testable import Swift6502

struct BitTests {
    
    struct ExpectedFlags {
        let Z: Bool
        let N: Bool
        let V: Bool
    }
    
    func testBIT_ZeroPage(value: UInt8, expectedFlags: ExpectedFlags) async {
        
        let (cpu, memory) = await initCPU()
        defer { memory.deallocate() }
        
        // Z = 0, N == 0, V == 0
        memory[0xA000] = Opcodes6502.BIT_ZeroPage.rawValue
        memory[0xA001] = 0x55
        memory[0x55] = value
        await cpu.setA(0x06)
        
        await cpu.runForTicks(3)
        let zFlag = await cpu.readFlag(.Z)
        let nFlag = await cpu.readFlag(.N)
        let vFlag = await cpu.readFlag(.V)
        
        #expect(zFlag == expectedFlags.Z)
        #expect(nFlag == expectedFlags.N)
        #expect(vFlag == expectedFlags.V)
    }
    
    func testBIT_Absolute(value: UInt8, expectedFlags: ExpectedFlags) async {
        
        let (cpu, memory) = await initCPU()
        defer { memory.deallocate() }
        
        // Z = 0, N == 0, V == 0
        memory[0xA000] = Opcodes6502.BIT_Absolute.rawValue
        memory[0xA001] = 0x34
        memory[0xA002] = 0x12

        memory[0x1234] = value
        await cpu.setA(0x06)
        
        await cpu.runForTicks(4)
        let zFlag = await cpu.readFlag(.Z)
        let nFlag = await cpu.readFlag(.N)
        let vFlag = await cpu.readFlag(.V)
        
        #expect(zFlag == expectedFlags.Z)
        #expect(nFlag == expectedFlags.N)
        #expect(vFlag == expectedFlags.V)
    }
    
    @Test func testBIT_ZeroPage() async throws {
        await testBIT_ZeroPage(value: 0x06, expectedFlags: ExpectedFlags(Z: false, N: false, V: false))
        await testBIT_ZeroPage(value: 0x46, expectedFlags: ExpectedFlags(Z: false, N: false, V: true))
        await testBIT_ZeroPage(value: 0x86, expectedFlags: ExpectedFlags(Z: false, N: true, V: false))
        await testBIT_ZeroPage(value: 0xC6, expectedFlags: ExpectedFlags(Z: false, N: true, V: true))
        await testBIT_ZeroPage(value: 0x08, expectedFlags: ExpectedFlags(Z: true, N: false, V: false))
        await testBIT_ZeroPage(value: 0x48, expectedFlags: ExpectedFlags(Z: true, N: false, V: true))
        await testBIT_ZeroPage(value: 0x88, expectedFlags: ExpectedFlags(Z: true, N: true, V: false))
        await testBIT_ZeroPage(value: 0xC8, expectedFlags: ExpectedFlags(Z: true, N: true, V: true))
    }
    
    @Test func testBIT_Absolute() async throws {
        await testBIT_Absolute(value: 0x06, expectedFlags: ExpectedFlags(Z: false, N: false, V: false))
        await testBIT_Absolute(value: 0x46, expectedFlags: ExpectedFlags(Z: false, N: false, V: true))
        await testBIT_Absolute(value: 0x86, expectedFlags: ExpectedFlags(Z: false, N: true, V: false))
        await testBIT_Absolute(value: 0xC6, expectedFlags: ExpectedFlags(Z: false, N: true, V: true))
        await testBIT_Absolute(value: 0x08, expectedFlags: ExpectedFlags(Z: true, N: false, V: false))
        await testBIT_Absolute(value: 0x48, expectedFlags: ExpectedFlags(Z: true, N: false, V: true))
        await testBIT_Absolute(value: 0x88, expectedFlags: ExpectedFlags(Z: true, N: true, V: false))
        await testBIT_Absolute(value: 0xC8, expectedFlags: ExpectedFlags(Z: true, N: true, V: true))
    }
    
}
