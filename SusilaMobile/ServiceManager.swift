//
//  ServiceManager.swift
//  SusilaMobile
//
//  Created by Sajith Konara on 11/4/20.
//

import Foundation
import Alamofire

typealias onAPIResponse = (_ response:Any?, _ statusCode:Int)->()

class ServiceManager{
    
    static func APIRequest(url:URL,method:HTTPMethod,params:Parameters? = nil,headers:HTTPHeaders? = nil,encoding:ParameterEncoding? = JSONEncoding.default,onResponse:onAPIResponse?){
        if ReachabilityManager.isConnectedToNetwork(){
            Alamofire.request(url, method: method, parameters: params, encoding: encoding!, headers: headers).responseJSON { response in
                if let statusCode = response.response?.statusCode{
                    onResponse?(response,statusCode)
                }else{
                    Log("Error")
                }
            }
        }else{
            UIHelper.makeSnackBar(message: "No Internet Connectivity")
        }
    }
}
