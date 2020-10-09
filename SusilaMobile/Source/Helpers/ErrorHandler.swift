//
//  ErrorHandler.swift
//
//  Created by Isuru Jayathissa
//  Copyright © 2016 Isuru Jayathissa. All rights reserved.
//



let ErrorDomain = "com.KiKi"

enum ResponseCode: Int {
    case noNetwork = 0
    case importDatabaseError = 99
    case userCredentialsNotCorrect = 204
    case unknowError = 9119
    case dataNil = 101
    case dataEmpty = 102
    case connectionTimeout = 205
    case mobileInspestionStatusFaild = 207
    case userAlreadyRegistered = 1031
    case inValidCredentials = 1008
    case Verificationfailed = 1024

}


class ErrorHandler {
    
    class var NoNetwork: NSError {
        
        let userInfo = [
            
            NSLocalizedDescriptionKey: NSLocalizedString("Network Error", comment: ""),
            NSLocalizedFailureReasonErrorKey: NSLocalizedString("Network Unavailable", comment: "")
        ]
        return NSError(domain: ErrorDomain, code: ResponseCode.noNetwork.rawValue, userInfo: userInfo)
    }
    
    class var WrongUserCredentials: NSError {
        let userInfo = [
            NSLocalizedDescriptionKey: NSLocalizedString("Login Error", comment: ""),
            NSLocalizedFailureReasonErrorKey: NSLocalizedString("Incorrect Username or Password", comment: "")
        ]
        return NSError(domain: ErrorDomain, code: ResponseCode.userCredentialsNotCorrect.rawValue, userInfo: userInfo)
    }
    
    class var NoResponseForRequest: NSError {
        let userInfo = [
            NSLocalizedDescriptionKey: NSLocalizedString("Request Error", comment: ""),
            NSLocalizedFailureReasonErrorKey: NSLocalizedString("No Response For Request", comment: "")
        ]
        return NSError(domain: ErrorDomain, code: 565, userInfo: userInfo)
    }
    
    class var ConnectionTimeout: NSError {
        let userInfo = [
            NSLocalizedDescriptionKey: NSLocalizedString("Request Error", comment: ""),
            NSLocalizedFailureReasonErrorKey: NSLocalizedString("CONNECTION_TIME_OUT", comment: "")
        ]
        return NSError(domain: ErrorDomain, code: ResponseCode.connectionTimeout.rawValue, userInfo: userInfo)
    }
    
    class var ImportDatabaseError: NSError {
        let userInfo = [
            NSLocalizedDescriptionKey: NSLocalizedString("Database Error", comment: ""),
            NSLocalizedFailureReasonErrorKey: NSLocalizedString("Import Database Error", comment: "")
        ]
        return NSError(domain: ErrorDomain, code: ResponseCode.importDatabaseError.rawValue, userInfo: userInfo)
    }
    
    class var UnKnownForRequest: NSError {
        let userInfo = [
            NSLocalizedDescriptionKey: NSLocalizedString("Unknow error", comment: ""),
            NSLocalizedFailureReasonErrorKey: NSLocalizedString("Unknow error", comment: "")
        ]
        return NSError(domain: ErrorDomain, code: ResponseCode.unknowError.rawValue, userInfo: userInfo)
    }
    
    class var DataNil: NSError {
        let userInfo = [
            NSLocalizedDescriptionKey: NSLocalizedString("Data nil", comment: ""),
            NSLocalizedFailureReasonErrorKey: NSLocalizedString("Data nil", comment: "")
        ]
        return NSError(domain: ErrorDomain, code: ResponseCode.dataNil.rawValue, userInfo: userInfo)
    }
    
    class var DataEmpty: NSError {
        let userInfo = [
            NSLocalizedDescriptionKey: NSLocalizedString("Data empty", comment: ""),
            NSLocalizedFailureReasonErrorKey: NSLocalizedString("Data empty", comment: "")
        ]
        return NSError(domain: ErrorDomain, code: ResponseCode.dataEmpty.rawValue, userInfo: userInfo)
    }
    class var userAlreadyRegistered: NSError {
        let userInfo = [
            NSLocalizedDescriptionKey: NSLocalizedString("User already registered.", comment: ""),
            NSLocalizedFailureReasonErrorKey: NSLocalizedString("User already registered.", comment: "")
        ]
        return NSError(domain: ErrorDomain, code: ResponseCode.dataEmpty.rawValue, userInfo: userInfo)
    }
    class var inValidCredentials: NSError {
        let userInfo = [
            NSLocalizedDescriptionKey: NSLocalizedString("LOGIN_SEVERRETURN_FIELD_ERROR_ALERT_MESSAGE".localized(using: "Localizable"), comment: ""),
            NSLocalizedFailureReasonErrorKey: NSLocalizedString("LOGIN_SEVERRETURN_FIELD_ERROR_ALERT_MESSAGE".localized(using: "Localizable"), comment: "")
        ]
        return NSError(domain: ErrorDomain, code: ResponseCode.dataEmpty.rawValue, userInfo: userInfo)
    }
    class var Verificationfailed: NSError {
        let userInfo = [
            NSLocalizedDescriptionKey: NSLocalizedString("Verification failed.", comment: ""),
            NSLocalizedFailureReasonErrorKey: NSLocalizedString("Verification failed.", comment: "")
        ]
        return NSError(domain: ErrorDomain, code: ResponseCode.dataEmpty.rawValue, userInfo: userInfo)
    }
}


enum HttpStatus {
    case informational
    case success
    case redirection
    case clientError
    case serverError
}

class HttpValidator {
    
    class func validate(_ statusCode: Int) -> (status: HttpStatus, code: Int, description: String) {
        var status: HttpStatus!
        var httpCode: Int!
        var descripton: String!
        
        switch statusCode {
        case 100:
            status = .informational
            httpCode = 100
            descripton = "Client should continue with request"
        case 101:
            status = .informational
            httpCode = 101
            descripton = "Server is switching protocols"
        case 102:
            status = .informational
            httpCode = 102
            descripton = "Server has received and is processing the request"
        case 103:
            status = .informational
            httpCode = 103
            descripton = "Resume aborted PUT or POST requests"
        case 122:
            status = .informational
            httpCode = 122
            descripton = "URI is longer than a maximum of 2083 characters"
        case 200:
            status = .success
            httpCode = 200
            descripton = "Standard response for successful HTTP requests"
        case 201:
            status = .success
            httpCode = 201
            descripton = "Request has been fulfilled; new resource created"
        case 202:
            status = .success
            httpCode = 202
            descripton = "Request accepted, processing pending"
        case 203:
            status = .success
            httpCode = 203
            descripton = "Request processed, information may be from another source"
        case 204:
            status = .success
            httpCode = 204
            descripton = "Request processed, no content returned"
        case 205:
            status = .success
            httpCode = 205
            descripton = "Request processed, no content returned, reset document view"
        case 206:
            status = .success
            httpCode = 206
            descripton = "Partial resource return due to request header"
        case 207:
            status = .success
            httpCode = 207
            descripton = "XML, can contain multiple separate responses"
        case 208:
            status = .success
            httpCode = 208
            descripton = "Results previously returned "
        case 226:
            status = .success
            httpCode = 226
            descripton = "Request fulfilled, reponse is instance-manipulations"
        case 300:
            status = .redirection
            httpCode = 300
            descripton = "Multiple options for the resource delivered"
        case 301:
            status = .redirection
            httpCode = 301
            descripton = "This and all future requests directed to the given URI"
        case 302:
            status = .redirection
            httpCode = 302
            descripton = "Temporary response to request found via alternative URI"
        case 303:
            status = .redirection
            httpCode = 303
            descripton = "Permanent response to request found via alternative URI"
        case 304:
            status = .redirection
            httpCode = 304
            descripton = "Resource has not been modified since last requested"
        case 305:
            status = .redirection
            httpCode = 305
            descripton = "Content located elsewhere, retrieve from there"
        case 306:
            status = .redirection
            httpCode = 306
            descripton = "Subsequent requests should use the specified proxy"
        case 307:
            status = .redirection
            httpCode = 307
            descripton = "Connect again to different URI as provided"
        case 308:
            status = .redirection
            httpCode = 308
            descripton = "Connect again to a different URI using the same method"
        case 400:
            status = .redirection
            httpCode = 400
            descripton = "Request cannot be fulfilled due to bad syntax"
        case 401:
            status = .redirection
            httpCode = 401
            descripton = "Authentication is possible but has failed"
        case 402:
            status = .redirection
            httpCode = 402
            descripton = "Payment required, reserved for future use"
        case 403:
            status = .redirection
            httpCode = 403
            descripton = "Server refuses to respond to request"
        case 404:
            status = .redirection
            httpCode = 404
            descripton = "Requested resource could not be found"
        case 405:
            status = .redirection
            httpCode = 405
            descripton = "Request method not supported by that resource"
        case 406:
            status = .redirection
            httpCode = 406
            descripton = "Content not acceptable according to the Accept headers"
        case 407:
            status = .redirection
            httpCode = 407
            descripton = "Client must first authenticate itself with the proxy"
        case 408:
            status = .redirection
            httpCode = 408
            descripton = "Server timed out waiting for the request"
        case 409:
            status = .redirection
            httpCode = 409
            descripton = "Request could not be processed because of conflict"
        case 410:
            status = .redirection
            httpCode = 410
            descripton = "Resource is no longer available and will not be available again"
        case 411:
            status = .redirection
            httpCode = 411
            descripton = "Request did not specify the length of its content"
        case 412:
            status = .redirection
            httpCode = 412
            descripton = "Server does not meet request preconditions"
        case 413:
            status = .redirection
            httpCode = 413
            descripton = "Request is larger than the server is willing or able to process"
        case 414:
            status = .redirection
            httpCode = 414
            descripton = "URI provided was too long for the server to process"
        case 415:
            status = .redirection
            httpCode = 415
            descripton = "Server does not support media type"
        case 416:
            status = .redirection
            httpCode = 416
            descripton = "Client has asked for unprovidable portion of the file"
        case 417:
            status = .redirection
            httpCode = 417
            descripton = "Server cannot meet requirements of Expect request-header field"
        case 418:
            status = .redirection
            httpCode = 418
            descripton = "I'm a teapot"
        case 420:
            status = .redirection
            httpCode = 420
            descripton = "Twitter rate limiting"
        case 422:
            status = .redirection
            httpCode = 422
            descripton = "Request unable to be followed due to semantic errors"
        case 423:
            status = .redirection
            httpCode = 423
            descripton = "Resource that is being accessed is locked"
        case 424:
            status = .redirection
            httpCode = 424
            descripton = "Request failed due to failure of a previous request"
        case 426:
            status = .redirection
            httpCode = 426
            descripton = "Client should switch to a different protocol"
        case 428:
            status = .redirection
            httpCode = 428
            descripton = "Origin server requires the request to be conditional"
        case 429:
            status = .redirection
            httpCode = 429
            descripton = "User has sent too many requests in a given amount of time"
        case 431:
            status = .redirection
            httpCode = 431
            descripton = "Server is unwilling to process the request"
        case 444:
            status = .redirection
            httpCode = 444
            descripton = "Server returns no information and closes the connection"
        case 449:
            status = .redirection
            httpCode = 449
            descripton = "Request should be retried after performing action"
        case 450:
            status = .redirection
            httpCode = 450
            descripton = "Windows Parental Controls blocking access to webpage"
        case 451:
            status = .redirection
            httpCode = 451
            descripton = "The server cannot reach the client's mailbox."
        case 499:
            status = .redirection
            httpCode = 499
            descripton = "Connection closed by client while HTTP server is processing"
        case 500:
            status = .redirection
            httpCode = 500
            descripton = "Generic error message"
        case 501:
            status = .redirection
            httpCode = 501
            descripton = "Server does not recognise method or lacks ability to fulfill"
        case 502:
            status = .redirection
            httpCode = 502
            descripton = "Server received an invalid response from upstream server"
        case 503:
            status = .redirection
            httpCode = 503
            descripton = "Server is currently unavailable"
        case 504:
            status = .redirection
            httpCode = 504
            descripton = "Gateway did not receive response from upstream server"
        case 505:
            status = .redirection
            httpCode = 505
            descripton = "Server does not support the HTTP protocol version"
        case 506:
            status = .redirection
            httpCode = 506
            descripton = "Content negotiation for the request results in a circular reference"
        case 507:
            status = .redirection
            httpCode = 507
            descripton = "Server is unable to store the representation"
        case 508:
            status = .redirection
            httpCode = 508
            descripton = "Server detected an infinite loop while processing the request"
        case 509:
            status = .redirection
            httpCode = 509
            descripton = "Bandwidth limit exceeded"
        case 510:
            status = .redirection
            httpCode = 510
            descripton = "Further extensions to the request are required"
        case 511:
            status = .redirection
            httpCode = 511
            descripton = "Client needs to authenticate to gain network access"
        case 598:
            status = .redirection
            httpCode = 598
            descripton = "Network read timeout behind the proxy "
        case 599:
            status = .redirection
            httpCode = 599
            descripton = "Network connect timeout behind the proxy"
        default:
            ()
        }
        return (status, httpCode, descripton)
    }
}
