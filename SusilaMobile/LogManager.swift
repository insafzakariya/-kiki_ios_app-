//
//  LogManager.swift
//  SusilaMobile
//
//  Created by Sajith Konara on 10/11/20.
//

import Foundation

func Log(message:String, file:String = #file , calledBy:String = #function){
    let className = file.components(separatedBy: "/").last ?? ""
    print("LOG ==> \(className) ::: \(calledBy) ::: \(message)")
}
