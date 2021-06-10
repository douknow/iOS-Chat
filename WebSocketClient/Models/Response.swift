//
//  Response.swift
//  WebSocketClient
//
//  Created by Xianzhao Han on 2021/6/10.
//

import Foundation


struct Response {

    enum `Type` {
        case info(String), message(MessageData)
    }

    let json: String
    let status: Int
    let type: `Type`

    init(json: String) {
        guard let data = json.data(using: .utf8),
              let jsonObj = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
              let status = jsonObj["status"] as? Int else {
            fatalError("JSON Response is invalid")
        }

        self.json = json
        self.status = status

        switch status {
        case 0:
            guard let msg = jsonObj["msg"] as? String else {
                fatalError("Resposne status should be message")
            }

            type = .info(msg)
        case 2:
            guard let messageResponse = try? jsonDecoder.decode(Response.MessageDataResponse.self, from: data) else {
                fatalError("Response stauts")
            }
            type = .message(messageResponse.messageData)
        default:
            fatalError("Status invalid")
        }
    }

}


extension Response {

    struct MessageDataResponse: Decodable {
        let status: Int

        let messageData: MessageData
    }

}

