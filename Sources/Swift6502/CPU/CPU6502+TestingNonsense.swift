//
//  File.swift
//  Swift6502
//
//  Created by James Weatherley on 16/12/2025.
//

import Foundation

internal extension CPU6502 {
    func setA(_ a: UInt8) { A = a }
    func setX(_ x: UInt8) { X = x }
    func setY(_ y:UInt8) { Y = y}
    func setPC(_ pc: UInt16) { PC = pc }
}
