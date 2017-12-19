//Copyright 2017 Idealnaya rabota LLC
//Licensed under Multy.io license.
//See LICENSE for details

import UIKit
import SocketIO

class Socket: NSObject {
    static let shared = Socket()
    var manager : SocketManager
    var socket : SocketIOClient

    
    override init() {
        //dev:  6680
        //prod: 7780
        manager = SocketManager(socketURL: URL(string: "http://88.198.47.112:6680/socket.io/")!, config: [.log(true), .compress, .forceWebsockets(true), .reconnectAttempts(3), .forcePolling(false)])
        socket = manager.defaultSocket
    }
    
    func start() {
//        let header = ["userID": "\(acc.userID)",
//                      "deviceType": "\(acc.deviceType)",
//                      "jwtToken": "\(acc.token)"]
//
//        manager = SocketManager(socketURL: URL(string: "http://192.168.0.111:7780/socket.io/")!, config: [.log(true), .compress, .forceWebsockets(true), .reconnectAttempts(3), .forcePolling(false), .extraHeaders(header)])
//        socket = manager.defaultSocket

        
//        let socket = manager.defaultSocket
        
        socket.on(clientEvent: .connect) {data, ack in
            print("socket connected")
            self.getExchangeReq()
        }
        
        socket.on("exchangeAll") {data, ack in
            print("-----exchangeAll")
        }
        
        socket.on("exchangeUpdate") {data, ack in
            print("-----exchangeUpdate")
        }
        

        
        socket.on("currentAmount") {data, ack in
            guard let cur = data[0] as? Double else { return }

            self.socket.emitWithAck("canUpdate", cur).timingOut(after: 0) {data in
                self.socket.emit("update", ["amount": cur + 2.50])
            }

            ack.with("Got your currentAmount", "dude")
        }
        
        socket.connect()
        
    }
    
    func getExchangeReq() {
        let abc = NSDictionary(dictionary: ["From": "USD",
                                            "To": "BTC"]).socketRepresentation()
        
        socket.emitWithAck("getExchangeReq", abc).timingOut(after: 0) { (data) in
            print("\n\n\n\n\n\n\n")
            print(data)
            print("\n\n\n\n\n\n\n")
        }
    }
}



