
import Foundation

// Validation return types
enum StatusCode: Equatable {
    case passedValidation
    case failedValidation(String)
    
    func getFailedMessage() -> String {
        switch self {
        case .failedValidation(let message):
            return message
        default:
            return ""
        }
    }
}

func ==(lhs: StatusCode, rhs: StatusCode) -> Bool {
    switch (lhs, rhs) {
    case (.passedValidation, .passedValidation):
        return true
    case (.failedValidation, .failedValidation):
        return true
    default:
        return false
    }
}

func !=(lhs: StatusCode, rhs: StatusCode) -> Bool {
    return !(lhs == rhs)
}
