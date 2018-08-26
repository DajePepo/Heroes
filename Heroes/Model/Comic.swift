//
//  Comic.swift
//  Heroes
//
//  Created by Pietro Santececca on 26.08.18.
//  Copyright © 2018 Tecnojam. All rights reserved.
//

import ObjectMapper

class Comic: Mappable {
    
    var identifier: Int!
    var title: String!
    var imagePath: String!
    var imageExtension: String!
    var imageUrl: String {
        get {
            return "\(imagePath!).\(imageExtension!)"
        }
    }
    
    required init?(map: Map) {}
    
    public func mapping(map: Map) {
        identifier <- map["id"]
        title <- map["title"]
        imageExtension <- map["thumbnail.extension"]
        imagePath <- map["thumbnail.path"]
    }
}
