//
//  OSCValueEncoderBlock.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import Foundation

/// Protocol that ``OSCValue`` encoder block encapsulation objects adopt.
public protocol OSCValueEncoderBlock {
    associatedtype OSCEncoded: OSCValueEncodable
}

// MARK: - Encoder Blocks

/// ``OSCValue`` atomic value encoder block encapsulation.
public struct OSCValueAtomicEncoder<OSCEncoded: OSCValueEncodable>: OSCValueEncoderBlock {
    public typealias Block = (
        _ value: OSCEncoded
    ) throws -> (
        tag: Character,
        data: Data?
    )
    
    public let block: Block
    
    public init(_ block: @escaping Block) {
        self.block = block
    }
}

/// ``OSCValue`` variable value encoder block encapsulation.
public struct OSCValueVariableEncoder<OSCEncoded: OSCValueEncodable>: OSCValueEncoderBlock {
    public typealias Block = (
        _ value: OSCEncoded
    ) throws -> (
        tag: Character,
        data: Data?
    )
    
    public let block: Block
    
    public init(_ block: @escaping Block) {
        self.block = block
    }
}

/// ``OSCValue`` variadic value encoder block encapsulation.
public struct OSCValueVariadicEncoder<OSCEncoded: OSCValueEncodable>: OSCValueEncoderBlock {
    public typealias Block = (
        _ value: OSCEncoded
    ) throws -> (
        tags: [Character],
        data: Data?
    )
    
    public let block: Block
    
    public init(_ block: @escaping Block) {
        self.block = block
    }
}
