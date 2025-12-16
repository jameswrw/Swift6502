//
//  Swift6502.swift
//  Swift6502
//
//  Created by James Weatherley on 28/10/2025.
//

public typealias OpCodeHook = @Sendable (_: UInt16, _: Opcodes6502) -> Void

public actor CPU6502 {
    
    public init(memory: MemoryWrapper, ioAddresses: Set<UInt16> = []) {
        self.memory = MemoryController(memory: memory.rawMemory, ioAddresses: ioAddresses)
            
        // Can't call readWord() here.
        let rawMemory = memory.rawMemory
        let startAddressLo = UInt16(rawMemory[resetVector])
        let startAddressHi = UInt16(rawMemory[resetVector + 1]) << 8
        PC = startAddressHi | startAddressLo
    }
    
    internal let endianness = Endianness.little
    internal var tickcount: Int = 0
    internal var isHalted = false
    
    // MARK: Memory
    public var memory: MemoryController
    
    public func setIOReadCallback(_ ioReadCallback: @escaping IOReadCallback) {
        memory.ioReadCallBack = ioReadCallback
    }
    
    public func setIOWriteCallback(_ ioWriteCallback: @escaping IOWriteCallback) {
        memory.ioWriteCallBack = ioWriteCallback
    }
    public func setOpCodeHook(_ opCodeHook: @escaping @Sendable OpCodeHook) {
        self.opCodeHook = opCodeHook
    }
    
    // MARK: Interrupts
    internal var waitingForNMIHandler: Bool = false
    internal var waitingForIRQHandler: Bool = false
    
    // MARK: Registers
    internal var SP: UInt8 = 0xFF   // Top of stack. Base address is 0x100, so 0x1FF -> 0x100 is your stack.
    internal var PC: UInt16         // Gets initialised to resetVector - execution starts here.
    internal var A: UInt8 = 0
    internal var X: UInt8 = 0
    internal var Y: UInt8 = 0
    internal var F: UInt8 = Flags.One.rawValue | Flags.I.rawValue
    
    // MARK: Vectors
    internal let resetVector = 0xFFFC
    internal let irqVector = 0xFFFE
    internal let nmiVector = 0xFFFA
    
    // MARK: Hooks
    var opCodeHook: OpCodeHook? = nil
}

