//
//  Carousel.swift
//  Carousel
//
//  Created by Kiroshan Thayaparan on 7/16/22.
//

class Carousel {
    
    var image_regular: String
    var image_large: String
    var title: String
    var description: String
    
    init(image_regular: String, image_large: String, title: String, description: String){
        self.image_regular = image_regular
        self.image_large = image_large
        self.title = title
        self.description = description
    }
}
