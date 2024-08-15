//
//  PayFeature.swift
//  gifscribeIt
//
//  Created by Jaehwi Kim on 2024/08/08.
//

import Foundation
import ComposableArchitecture

@Reducer
struct PayFeature {
    @Dependency(\.payClient) var payClient
    
    @ObservableState
    struct State: Equatable {
        
    }
    
    enum Action: Equatable, ViewAction {
        case getQRSuccess
        case getQRFailure
        case view(View)
        
        @CasePathable
        enum View: Equatable {
            case testPay(Int)
        }
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .getQRSuccess:
                return .none
            case .getQRFailure:
                return .none
            case .view(.testPay(let amount)):
                return .run { send in
                    await send(self.getQRCode(amount: amount))
                }
            }
        }
    }
}

extension PayFeature {
    private func getQRCode(amount: Int) async -> Action {
        let result = await payClient.createQRCodeLink(amount)
        switch result {
        case .success(let result):
            print("jaebi: \(result)")
            return .getQRSuccess
        case .failure(let error):
            return .getQRFailure
        }
    }
}
