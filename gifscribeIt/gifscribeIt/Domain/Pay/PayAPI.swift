//
//  PayAPI.swift
//  gifscribeIt
//
//  Created by Jaehwi Kim on 2024/08/08.
//

import Foundation
import Moya

enum PayAPI {
    case createQRCodeLink(amount: Int)
}

extension PayAPI: TargetType {
    var baseURL: URL {
        URL(string: "https://open-api.kakaopay.com")!
    }
    
    var path: String {
        switch self {
        case .createQRCodeLink:
            return "/online/v1/payment/ready"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .createQRCodeLink:
            return .post
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Moya.Task {
        switch self {
        case .createQRCodeLink(let amount):
            let request: PayRequest = PayRequest(
                cid: "TC0ONETIME",
                partnerOrderID: "123123123",
                partnerUserID: "321321321",
                itemName: "초코파이",
                quantity: 1,
                totalAmount: amount,
                vatAmount: 200,
                taxFreeAmount: 0,
                approvalURL: "http://localhost:8080",
                failURL: "http://localhost:8080",
                cancelURL: "http://localhost:8080"
            )
            return .requestJSONEncodable(request)
        }
    }
    
    var headers: [String : String]? {
        return [
            "Authorization": "",
            "Content-type": "application/json"
        ]
    }
    
    var validationType: ValidationType {
        switch self {
        case .createQRCodeLink:
            return .successCodes
        }
    }
}
