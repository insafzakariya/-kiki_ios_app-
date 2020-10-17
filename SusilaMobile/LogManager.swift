//
//  LogManager.swift
//  SusilaMobile
//
//  Created by Sajith Konara on 10/11/20.
//

import Foundation

enum LogType{
    case CRITICAL
    case DEBUG
    case WARNING
}

func Log(_ message:String, file:String = #file , calledBy:String = #function, type:LogType = .DEBUG){
    let className = file.components(separatedBy: "/").last ?? ""
    switch type {
    case .DEBUG:
        print("LOG ==> \(className) ::: \(calledBy) ::: \(message)")
    case .WARNING:
        print("LOG ==> WARNING! ::: \(className) ::: \(calledBy) ::: \(message)")
    case .CRITICAL:
        print("LOG ==> CRITICAL!!! ::: \(className) ::: \(calledBy) ::: \(message)")
    }
    
}
