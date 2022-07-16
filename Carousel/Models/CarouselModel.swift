//
//  CarouselModel.swift
//  Carousel
//
//  Created by Kiroshan Thayaparan on 7/17/22.
//

import SwiftyJSON

class CarouselModel {
    
    private let api = ApiClient()
    var dataArray: [Carousel] = []
    
    func getImageData(search_key: String, getImageDataCallFinished: @escaping (_ status: Bool) -> Void) {
        //get data from http request
        api.sendRequest(request_url: "photos/?client_id=\(Constants.Security.access_key)&query=\(search_key)", success: { (response, code) -> Void in

            if code == 200 {
                let currentData = JSON(response as Any)

                let res = currentData[].arrayObject

                let jsonArray = JSON(res as Any).array

                if let jsonList = jsonArray {
                    self.dataArray.removeAll()
                    for jsonObject in jsonList {
                        let carousel = Carousel(image_regular: jsonObject["urls"]["regular"].string ?? "",
                                                image_large: jsonObject["urls"]["full"].string ?? "",
                                                title: jsonObject["user"]["name"].string ?? "",
                                                description: jsonObject["user"]["bio"].string ?? "")
                        self.dataArray.append(carousel)
                    }
                }
                getImageDataCallFinished(true)
            } else {
                print("Api status not equal 200")
                getImageDataCallFinished(false)
            }
        }) { (error) -> Void in
            NSLog("Error (getImageDataCallFinished): \(error.localizedDescription)")
            getImageDataCallFinished(false)
        }
    }
}
