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
            AF.request(url, method: method, parameters: params, encoding: encoding!, headers: headers).responseJSON { response in
                if let statusCode = response.response?.statusCode{
                    switch response.result{
                    case .success(let data):
                        onResponse?(data,statusCode)
                    case .failure(let e):
                        Log(e.localizedDescription)
                        onResponse?(nil,statusCode)
                    }
                }else{
                    Log("Error")
                }
            }
        }else{
            UIHelper.makeSnackBar(message: "No Internet Connectivity")
        }
    }
}
