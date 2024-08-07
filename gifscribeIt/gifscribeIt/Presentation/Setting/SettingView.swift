//
//  SettingView.swift
//  gifscribeIt
//
//  Created by Jaehwi Kim on 2024/07/24.
//

import Foundation
import SwiftUI
import ComposableArchitecture

@ViewAction(for: SettingFeature.self)
struct SettingView: View {
    @Perception.Bindable var store: StoreOf<SettingFeature>
    
    var body: some View {
        WithPerceptionTracking {
            VStack {
                List {
                    Section(header: Text("User Information").foregroundStyle(Color.black)) {
                        HStack {
                            Text("User Email")
                            Spacer()
                            Text("\(store.user)")
                        }
                    }
                    Section {
                        Button("Log Out") {
                            send(.logoutButtonTapped)
                        }
                    }
                    Section {
                        Button("Delete Account") {
                            send(.showDeleteAccountTapped)
                        }
                    }
                }
                Text("Questions or Inquiries? Please contact: jaehwi95@gmail.com")
                    .font(.system(size: 12))
            }
            .sheet(isPresented: $store.isSheetPresented.sending(\.setSheet)) {
                VStack {
                    DeleteAccountView
                }
                .presentationDragIndicator(.visible)
            }
        }
    }
}

extension SettingView {
    private var DeleteAccountView: some View {
        VStack(spacing: 20) {
            Text("Delete Account")
                .font(.system(size: 40))
            Text("Are your sure you want to delete your account?")
                .font(.system(size: 20))
            Spacer()
            Button(
                action: {
                    send(.deleteAccountButtonTapped)
                }, label: {
                    Text("Delete Account")
                        .font(.system(size: 20))
                        .padding(.vertical, 16)
                        .padding(.horizontal, 40)
                        .background(.blue)
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 4))
                }
            )
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 40)
        .alert($store.scope(state: \.alert, action: \.alert))
    }
}
