// Would like to replace testCPU() with a macro.
// It's written, but gives dubious errors about the _main symbol being missing when building.
//
// import CPUMacroDecls

import Testing
import Foundation
@testable import Swift6502

@inline(__always)
internal func initCPU(
    assertInitialState: Bool = true,
    ioAddresses: Set<UInt16> = []) async -> (CPU6502, UnsafeMutablePointer<UInt8>
    ) {
    let memory = UnsafeMutablePointer<UInt8>.allocate(capacity: 0x10000)
    
    // 0xFF is an invalid opcode, so this should help catch some unitialised memory and tickcount issues.
    memset(memory, 0xFF, 0x10000)
    
    // Start all tests from 0xA000
    memory[0xFFFC] = 0x00
    memory[0xFFFD] = 0xA0
    let cpu = CPU6502(memory: MemoryWrapper(memory), ioAddresses: ioAddresses)

    let a = await cpu.A
    let x = await cpu.X
    let y = await cpu.Y
    let sp = await cpu.SP
    let pc = await cpu.PC
    let f = await cpu.F
    let resetAddress = await cpu.readWord(addr: cpu.resetVector)
    
    if assertInitialState {
        #expect(a == 0)
        #expect(x == 0)
        #expect(y == 0)
        #expect(sp == 0xFF)
        #expect(pc == resetAddress)
        #expect(f == Flags.One.rawValue | Flags.I.rawValue)
    }

    return (cpu, memory)
}
