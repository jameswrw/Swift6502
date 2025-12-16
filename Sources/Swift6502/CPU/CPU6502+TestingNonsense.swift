//
//  File.swift
//  Swift6502
//
//  Created by James Weatherley on 16/12/2025.
//

// This extension is to keep the tests happy.
// Stuff inside CPU6502 should continue using direct access.
// Stuff outside CPU6502 can't see this - keep it that way.
// ONLY USE THESE METHODS IN TESTS
internal extension CPU6502 {
    func setA(_ a: UInt8) { A = a }
    func setX(_ x: UInt8) { X = x }
    func setY(_ y:UInt8) { Y = y }
    func setF(_ f:UInt8) { Y = f }
    func setPC(_ pc: UInt16) { PC = pc }
    func setSP(_ sp: UInt8) { SP = sp }

    func writeMemory(address: Int, value: UInt8) { memory[address] = value }
    func readMemory(address: Int) -> UInt8 { memory[address] }
}
