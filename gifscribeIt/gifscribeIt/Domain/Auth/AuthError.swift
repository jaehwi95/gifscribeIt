//
//  AuthError.swift
//  gifscribeIt
//
//  Created by Jaehwi Kim on 2024/07/24.
//

import Foundation

protocol AuthError: Error {
    var errorMessage: String { get }
}

enum SignUpError: AuthError {
    case emailDoesNotExist
    case disabledByAdmin
    case emailAlreadyInUse
    case invalidEmail
    case weakPassword
    case otherError(String)
    
    var errorMessage: String {
        switch self {
        case .emailDoesNotExist:
            return "Email does not exist"
        case .disabledByAdmin:
            return "Email/Password Provider is disabled. Please contact admin"
        case .emailAlreadyInUse:
            return "Email is already in use"
        case .invalidEmail:
            return "Email Address is badly formatted"
        case .weakPassword:
            return "Password must be 6 characters long or more"
        case .otherError(let errorDescription):
            return "Error: \(errorDescription)"
        }
    }
}

enum SignInError: AuthError {
    case emailDoesNotExist
    case invalidCredential
    case disabledByAdmin
    case userDisabled
    case wrongPassword
    case invalidEmail
    case otherError(String)
    
    var errorMessage: String {
        switch self {
        case .emailDoesNotExist:
            return "Email does not exist"
        case .invalidCredential:
            return "Please check your email / password again"
        case .disabledByAdmin:
            return "Email/Password Provider is disabled. Please contact the administrator"
        case .userDisabled:
            return "The account has been disabled by an administrator"
        case .wrongPassword:
            return "Please check your password again"
        case .invalidEmail:
            return "Email Address is badly formatted"
        case .otherError(let errorDescription):
            return "Error: \(errorDescription)"
        }
    }
}

enum LogoutError: AuthError {
    case keychainError
    case otherError(String)
    
    var errorMessage: String {
        switch self {
        case .keychainError:
            return "Error occurred when accessing the keychain"
        case .otherError(let errorDescription):
            return "Error: \(errorDescription)"
        }
    }
}

enum PasswordResetError: AuthError {
    case userNotFound
    case invalidEmail
    case invalidRecipientEmail
    case invalidSender
    case otherError(String)
    
    var errorMessage: String {
        switch self {
        case .userNotFound:
            return "User not found"
        case .invalidEmail:
            return "Email Address is badly formatted"
        case .invalidRecipientEmail:
            return "Invalid recipient email was sent"
        case .invalidSender:
            return "Invalid sender email is set"
        case .otherError(let errorDescription):
            return "Error: \(errorDescription)"
        }
    }
}
