//
//  AuthClient.swift
//  gifscribeIt
//
//  Created by Jaehwi Kim on 2024/07/23.
//

import Foundation
import FirebaseAuth
import ComposableArchitecture

struct AuthClient {
    var signUp: (_ email: String, _ password: String) async -> Result<String, SignUpError>
    var signIn: (_ email: String, _ password: String) async -> Result<String, SignInError>
    var logout: () -> Result<Void, LogoutError>
    var resetPassword: (_ email: String) async -> Result<String, PasswordResetError>
    var deleteAccount: () async -> Result<Void, DeleteAccountError>
}

extension DependencyValues {
    var authClient: AuthClient {
        get { self[AuthClient.self] }
        set { self[AuthClient.self] = newValue }
    }
}

extension AuthClient: DependencyKey {
    static var liveValue = AuthClient(
        signUp: { email, password in
            do {
                let result: AuthDataResult = try await Auth.auth().createUser(withEmail: email, password: password)
                let currentUser = result.user
                guard let email = currentUser.email else {
                    return .failure(.emailDoesNotExist)
                }
                return .success(email)
            } catch {
                let errorCode = AuthErrorCode(_nsError: error as NSError)
                switch errorCode.code {
                case .operationNotAllowed:
                    return .failure(.disabledByAdmin)
                case .emailAlreadyInUse:
                    return .failure(.emailAlreadyInUse)
                case .invalidEmail:
                    return .failure(.invalidEmail)
                case .weakPassword:
                    return .failure(.weakPassword)
                default:
                    return .failure(.otherError(errorCode.localizedDescription))
                }
            }
        },
        signIn: { email, password in
            do {
                let result: AuthDataResult = try await Auth.auth().signIn(withEmail: email, password: password)
                let currentUser = result.user
                guard let email = result.user.email else {
                    return .failure(.emailDoesNotExist)
                }
                return .success(email)
            } catch {
                let errorCode = AuthErrorCode(_nsError: error as NSError)
                switch errorCode.code {
                case .invalidCredential:
                    return .failure(.invalidCredential)
                case .operationNotAllowed:
                    return .failure(.disabledByAdmin)
                case .userDisabled:
                    return .failure(.userDisabled)
                case .wrongPassword:
                    return .failure(.wrongPassword)
                case .invalidEmail:
                    return .failure(.invalidEmail)
                default:
                    return .failure(.otherError(errorCode.localizedDescription))
                }
            }
        },
        logout: {
            do {
                try Auth.auth().signOut()
                return .success(())
            } catch {
                let errorCode = AuthErrorCode(_nsError: error as NSError)
                switch errorCode.code {
                case .keychainError:
                    return .failure(.keychainError)
                default:
                    return .failure(.otherError(errorCode.localizedDescription))
                }
            }
        },
        resetPassword: { email in
            do {
                try await Auth.auth().sendPasswordReset(withEmail: email)
                return .success(email)
            } catch {
                let errorCode = AuthErrorCode(_nsError: error as NSError)
                switch errorCode.code {
                case .userNotFound:
                    return .failure(.userNotFound)
                case .invalidEmail:
                    return .failure(.invalidEmail)
                case .invalidRecipientEmail:
                    return .failure(.invalidRecipientEmail)
                case .invalidSender:
                    return .failure(.invalidSender)
                default:
                    return .failure(.otherError(errorCode.localizedDescription))
                }
            }
        },
        deleteAccount: {
            do {
                try await Auth.auth().currentUser?.delete()
                return .success(())
            } catch {
                let errorCode = AuthErrorCode(_nsError: error as NSError)
                switch errorCode.code {
                case .operationNotAllowed:
                    return .failure(.disabledAccount)
                case .requiresRecentLogin:
                    return .failure(.reauthenticateNeeded)
                default:
                    return .failure(.otherError(errorCode.localizedDescription))
                }
            }
        }
        
    )
}
