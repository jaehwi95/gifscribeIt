//
//  PayEntity.swift
//  gifscribeIt
//
//  Created by Jaehwi Kim on 2024/08/08.
//

import Foundation

struct PayRequest: Codable {
    let cid, partnerOrderID, partnerUserID, itemName: String?
    let quantity, totalAmount, vatAmount, taxFreeAmount: Int?
    let approvalURL, failURL, cancelURL: String?
    
    enum CodingKeys: String, CodingKey {
        case cid
        case partnerOrderID = "partner_order_id"
        case partnerUserID = "partner_user_id"
        case itemName = "item_name"
        case quantity
        case totalAmount = "total_amount"
        case vatAmount = "vat_amount"
        case taxFreeAmount = "tax_free_amount"
        case approvalURL = "approval_url"
        case failURL = "fail_url"
        case cancelURL = "cancel_url"
    }
}

struct PayResponse: Codable {
    let tid: String?
    let nextRedirectAppURL, nextRedirectMobileURL, nextRedirectPCURL: String?
    let androidAppScheme, iosAppScheme: String?
    let createdAt: String?
    
    enum CodingKeys: String, CodingKey {
        case tid
        case nextRedirectAppURL = "next_redirect_app_url"
        case nextRedirectMobileURL = "next_redirect_mobile_url"
        case nextRedirectPCURL = "next_redirect_pc_url"
        case androidAppScheme = "android_app_scheme"
        case iosAppScheme = "ios_app_scheme"
        case createdAt = "created_at"
    }
}

extension PayResponse {
    func toModel() -> PayModel {
        return PayModel.init(
            tid: self.tid ?? "",
            nextRedirectAppURL: self.nextRedirectAppURL ?? "",
            nextRedirectMobileURL: self.nextRedirectMobileURL ?? "",
            nextRedirectPCURL: self.nextRedirectPCURL ?? "",
            iosAppScheme: self.iosAppScheme ?? "",
            createdAt: self.createdAt ?? ""
        )
    }
}

struct PayErrorResponse: Codable {
    let errorCode: Int?
    let errorMessage: String?
    
    enum CodingKeys: String, CodingKey {
        case errorCode = "error_code"
        case errorMessage = "error_message"
    }
}
