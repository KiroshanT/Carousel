//
//  ApiClient.swift
//  Carousel
//
//  Created by Kiroshan Thayaparan on 7/17/22.
//

import Alamofire
import SwiftyJSON
import Reachability

class ApiClient {
    
    internal func sendRequest(request_url: String, success: @escaping (_ data: AnyObject?, _ code: Int) -> Void, failure: @escaping (_ error: NSError) -> Void) {
        
        let url = URL(string:"\(Constants.Security.base_url)\(request_url)")
        
        let parameters: Parameters = [:]
        let headers: HTTPHeaders = [:]
        
        request(url!, method: .get, parameter: parameters, headers: headers, success: { (data, code) -> Void in
            success(data, code)
        }) { (error) -> Void in
            failure(error)
        }
    }
    
    fileprivate func request(_ url: URL, method: HTTPMethod, parameter: Parameters, headers: HTTPHeaders, success: @escaping (_ data: AnyObject?, _ code: Int) -> Void, failure: @escaping (_ error: NSError) -> Void) {
        
        func callAPIrequest() {
            
            AF.request(url, method: method, headers: headers)
                .validate()
                .responseDecodable { (response: AFDataResponse<JSON>) in
                    if let response = response.response {
                        let validateResult = HttpValidator.validate(response.statusCode)
                        print("validateResult ---- : \(validateResult)\(url)\(parameter)")
                    }
                    switch response.result {
                    case .success( let data):
                        print("Data ---- : \(data)")
                        if let response = response.response {
                            let validateResult = HttpValidator.validate(response.statusCode)
                            success(data as AnyObject, validateResult.code)
                            
                        } else {
                            NSLog("No response for POST request: \(String(describing: response.request))")
                        }
                    case .failure(let error):
                        NSLog("API Failure: \(error)")
                    }
                }
        }
        
        if !isNetworkAvailable() {
            print("Internet Status : No Internet")
        } else{
            callAPIrequest()
        }
    }
}

func isNetworkAvailable() -> Bool {
    return Reachability.forInternetConnection().isReachable()
}
