//
//  OSCObject.swift
//  OSCKit
//
//  Created by Steffan Andrews on 2019-10-27.
//  Copyright © 2019 Steffan Andrews. All rights reserved.
//

import Foundation


// MARK: - OSCObject

/// Protocl applied to OSC data objects
public protocol OSCObject {
	
	/// Get: constructs a raw UDP data packet from properties.
	/// Set: parses a raw UDP data packet and populate properties with the relevant OSC data.
	var rawData: Data? { get set }
	
}


// MARK: - Header

public extension Data {
	
	/// Test if Data appears to be an OSC bundle or OSC message. (Basic validation)
	///
	/// Returns a type if validation succeeds, otherwise:
	/// Returns nil if neither.
	var appearsToBeOSCObject: OSCObject.Type? {
		
		if appearsToBeOSCBundle {
			return OSCBundle.self
		} else if appearsToBeOSCMessage {
			return OSCMessage.self
		}
		
		return nil
		
	}
	
}
