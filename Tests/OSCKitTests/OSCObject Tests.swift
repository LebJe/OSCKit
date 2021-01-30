//
//  OSCObject Tests.swift
//  OSCKitTests
//
//  Created by Steffan Andrews on 2017-04-09.
//  Copyright © 2017 Steffan Andrews. All rights reserved.
//

#if !os(watchOS)

import XCTest
import OSCKit

final class OSCObjectTests: XCTestCase {
	
	override func setUp() { super.setUp() }
	override func tearDown() { super.tearDown() }
	
	
	// MARK: - OSCObject
	
	func testOSCObject() {
		
		let bundle = OSCBundle(elements: []).rawData
		let msg    = OSCMessage(address: "/").rawData
		
		// OSC bundle
		XCTAssert(     bundle.appearsToBeOSC == .bundle)
		XCTAssertFalse(bundle.appearsToBeOSC == .message)
		
		// OSC message
		XCTAssert(     msg   .appearsToBeOSC == .message)
		XCTAssertFalse(msg   .appearsToBeOSC == .bundle)
		
		// empty bytes
		XCTAssertNil(  Data().appearsToBeOSC)
		
		// garbage bytes
		XCTAssertNil(  Data([0x98, 0x42, 0x01, 0x7E]).appearsToBeOSC)
		
	}
	
}

#endif
