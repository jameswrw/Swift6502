//
//  MemoryControllerTests.swift
//  Swift6502
//
//  Created by James Weatherley on 22/11/2025.
//

import Testing
@testable import Swift6502

struct MemoryControllerTests {
    
    @Test func testIORead() async throws {
        let (cpu, memory) = await initCPU(ioAddresses: [0x2000, 0x2001])
        defer { memory.deallocate() }
        
        let baseAddr = UInt(bitPattern: memory)
        await cpu.setIOReadCallback { @Sendable address in
            let ptr = UnsafeMutablePointer<UInt8>(bitPattern: baseAddr)!
            if address == 0x2000 {
                ptr.advanced(by: 0x3000).pointee = 0x22
            } else if address == 0x2001 {
                ptr.advanced(by: 0x3001).pointee = 0x33
            }
            return 0x42
        }

        // • JMP to 0x1000.
        // • Read (LDA) from 0x2000 and 0x2001.
        // • Reading from 0x2000 causes cpu.memory.ioReadCallback to set 0x3000 to 0x22.
        // • Reading from 0x2001 causes cpu.memory.ioReadCallback to set 0x3001 to 0x33.
        //
        // Note: Memory accesses are via cpu.memoryController sees them.
        //       Directly reading from memory is, well, a DMA and the ioCallbacks will not be called.
        
        await cpu.writeMemory(address: 0xA000, value: Opcodes6502.JMP_Absolute.rawValue)
        await cpu.writeMemory(address: 0xA001, value: 0x00)
        await cpu.writeMemory(address: 0xA002, value: 0x10)
        await cpu.writeMemory(address: 0x1000, value: Opcodes6502.LDA_Absolute.rawValue)
        await cpu.writeMemory(address: 0x1001, value: 0x00)
        await cpu.writeMemory(address: 0x1002, value: 0x20)
        await cpu.writeMemory(address: 0x1003, value: Opcodes6502.LDA_Absolute.rawValue)
        await cpu.writeMemory(address: 0x1004, value: 0x01)
        await cpu.writeMemory(address: 0x1005, value: 0x20)
        
        var memory3000 = await cpu.readMemory(address: 0x3000)
        var memory3001 = await cpu.readMemory(address: 0x3001)
        #expect(memory3000 == 0xFF)
        #expect(memory3001 == 0xFF)
        
        // JMP
        await cpu.runForTicks(3)
        let pc = await cpu.PC
        #expect(pc == 0x1000)
        
        // LDA
        await cpu.runForTicks(4)
        
        memory3000 = await cpu.readMemory(address: 0x3000)
        memory3001 = await cpu.readMemory(address: 0x3001)
        #expect(memory3000 == 0x22)
        #expect(memory3001 == 0xFF)
        
        // LDA
        await cpu.runForTicks(4)
        
        memory3000 = await cpu.readMemory(address: 0x3000)
        memory3001 = await cpu.readMemory(address: 0x3001)
        #expect(memory3000 == 0x22)
        #expect(memory3001 == 0x33)
    }
    
    @Test func testIOWrite() async throws {
        let (cpu, memory) = await initCPU(ioAddresses: [0x2000, 0x2001])
        defer { memory.deallocate() }
        
        let baseAddr = UInt(bitPattern: memory)
        await cpu.setIOWriteCallback { @Sendable address, value in
            let ptr = UnsafeMutablePointer<UInt8>(bitPattern: baseAddr)!
            if address == 0x2000 {
                ptr.advanced(by: 0x3002).pointee = 0xAB
            } else if address == 0x2001 {
                ptr.advanced(by: 0x3003).pointee = 0xCD
            }
            return value
        }
        
        // • JMP to 0x1000.
        // • Write to 0x2000 and 0x2001.
        // • Writing to 0x2000 causes cpu.memory.ioReadCallback to set 0x3002 to 0xAB.
        // • Writing to 0x2001 causes cpu.memory.ioReadCallback to set 0x3003 to 0xCD.
        //
        // Note: Memory accesses via cpu.memoryController trigget the callbacks.
        //       Directly reading from memory is, well, a DMA and the ioCallbacks will not be called.
        
        await cpu.writeMemory(address: 0xA000, value: Opcodes6502.JMP_Absolute.rawValue)
        await cpu.writeMemory(address: 0xA001, value: 0x00)
        await cpu.writeMemory(address: 0xA002, value: 0x10)
        await cpu.writeMemory(address: 0x1000, value: Opcodes6502.STA_Absolute.rawValue)
        await cpu.writeMemory(address: 0x1001, value: 0x00)
        await cpu.writeMemory(address: 0x1002, value: 0x20)
        await cpu.writeMemory(address: 0x1003, value: Opcodes6502.STA_Absolute.rawValue)
        await cpu.writeMemory(address: 0x1004, value: 0x01)
        await cpu.writeMemory(address: 0x1005, value: 0x20)
        
        var memory3002 = await cpu.readMemory(address: 0x3002)
        var memory3003 = await cpu.readMemory(address: 0x3003)
        #expect(memory3002 == 0xFF)
        #expect(memory3003 == 0xFF)
        
        await cpu.runForTicks(3)
        let pc = await cpu.PC
        #expect(pc == 0x1000)
        
        await cpu.runForTicks(4)
        memory3002 = await cpu.readMemory(address: 0x3002)
        memory3003 = await cpu.readMemory(address: 0x3003)
        #expect(memory3002 == 0xAB)
        #expect(memory3003 == 0xFF)
        
        await cpu.runForTicks(4)
        memory3002 = await cpu.readMemory(address: 0x3002)
        memory3003 = await cpu.readMemory(address: 0x3003)
        #expect(memory3002 == 0xAB)
        #expect(memory3003 == 0xCD)
    }
}

