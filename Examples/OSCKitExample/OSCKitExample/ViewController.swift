//
//  ViewController.swift
//  OSCKitExample
//  OSCKit • https://github.com/orchetect/OSCKit
//

import Cocoa
import OSCKit

class ViewController: NSViewController {
    
    var oscClient: UDPClient?
    var oscServer: UDPServer?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // OSC client setup
        
        oscClient = UDPClient(
            host: "localhost",
            port: 8000,
            queue: DispatchQueue.global(qos: .userInteractive)
        )
        
        print("UDP client set up.")
        
        // OSC server setup
        
        do {
            oscServer = try UDPServer(
                host: "localhost",
                port: 8000,
                queue: DispatchQueue.global(qos: .userInteractive)
            )
        } catch {
            print("Error initializing UDP server:", error)
            return
        }
        
        oscServer?.setHandler { [weak self] data in
            
            // incoming data handler is fired on the UDPServer's queue
            // but we want to deal with it on the main thread
            // to update UI as a result, etc. here
            
            DispatchQueue.main.async {
                
                do {
                    guard let oscPayload = try data.parseOSC() else { return }
                    try self?.handleOSCPayload(oscPayload)
                    
                } catch let error as OSCBundle.DecodeError {
                    // handle bundle errors
                    switch error {
                    case .malformed(let verboseError):
                        print("Error:", verboseError)
                    }
                    
                } catch let error as OSCMessage.DecodeError {
                    // handle message errors
                    switch error {
                    case .malformed(let verboseError):
                        print("Error:", verboseError)
                        
                    case .unexpectedType(let oscType):
                        print("Error: unexpected OSC type tag:", oscType)
                        
                    }
                    
                } catch {
                    // handle other errors
                    print("Error:", error)
                }
                
            }
            
        }
        
        print("UDP server set up.")
        
    }
    
    /// Handle incoming OSC data recursively
    func handleOSCPayload(_ oscPayload: OSCPayload) throws {
        
        switch oscPayload {
        case .bundle(let bundle):
            // recursively handle nested bundles and messages
            try bundle.elements.forEach { try handleOSCPayload($0) }
            
        case .message(let message):
            // handle message
            try handleOSCMessage(message)
            
        }
        
    }
    
    func handleOSCMessage(_ oscMessage: OSCMessage) throws {
        
        switch oscMessage.address.pathComponents {
        case ["test", "method1"]:
            // validate value array with expected types: [Int32]
            let value = try oscMessage.values.masked(Int32.self)
            print("/test/method1 with int32:", value)
            
        case ["test", "method2"]:
            // validate value array with expected types: [Int32, String?]
            let values = try oscMessage.values.masked(Int32.self, ASCIIString?.self)
            if let values1 = values.1 {
                print("/test/method2 with int32: \(values.0), string: \(values1)")
            } else {
                print("/test/method2 with int32: \(values.0)")
            }
            
        default:
            print(oscMessage)
        }
        
    }
    
    @IBAction func buttonSendOSCMessage(_ sender: Any) {
        
        let oscMessage = OSCMessage(
            address: "/testaddress",
            values: [.int32(123)]
        )
            .rawData
        
        oscClient?.send(data: oscMessage)
        
    }
    
}
