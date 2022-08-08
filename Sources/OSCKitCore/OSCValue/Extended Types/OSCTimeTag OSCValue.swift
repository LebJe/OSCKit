//
//  OSCTimeTag OSCValue.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//

import Foundation
@_implementationOnly import OTCore

extension OSCTimeTag: OSCValue {
    public static let oscCoreType: OSCValueMask.Token = .timeTag
}

extension OSCTimeTag: OSCValueCodable { }

extension OSCTimeTag: OSCValueEncodable {
    static let oscTag: Character = "t"
    public static let oscTagIdentity: OSCValueTagIdentity = .atomic(oscTag)
    
    public typealias OSCValueEncodingBlock = OSCValueAtomicEncoder<OSCEncoded>
    public static let oscEncoding = OSCValueEncodingBlock { value in
        (
            tag: oscTag,
            data: value.rawValue.toData(.bigEndian)
        )
    }
}

extension OSCTimeTag: OSCValueDecodable {
    public typealias OSCValueDecodingBlock = OSCValueAtomicDecoder<OSCDecoded>
    public static let oscDecoding = OSCValueDecodingBlock { decoder in
        let rawValue = try decoder.readUInt64()
        return OSCTimeTag(rawValue)
    }
}
