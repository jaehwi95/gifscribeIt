//
//  PayClient.swift
//  gifscribeIt
//
//  Created by Jaehwi Kim on 2024/08/08.
//

import Foundation
import ComposableArchitecture
import Moya

struct PayClient {
    var createQRCodeLink: (_ amount: Int) async -> Result<PayModel, PayError>
}

extension DependencyValues {
    var payClient: PayClient {
        get { self[PayClient.self] }
        set { self[PayClient.self] = newValue }
    }
}

extension PayClient: DependencyKey {
    static var liveValue = PayClient(
        createQRCodeLink: { amount in
            let target: PayAPI = PayAPI.createQRCodeLink(amount: amount)
            let response: Result<PayResponse, PayError> = await PayProvider.request(target: target)
            return response.map { success in
                return success.toModel()
            }
        }
    )
}
