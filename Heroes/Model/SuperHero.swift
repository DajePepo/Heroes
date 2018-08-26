//
//  SuperHero.swift
//  Heroes
//
//  Created by Pietro Santececca on 25.08.18.
//  Copyright © 2018 Tecnojam. All rights reserved.
//

import ObjectMapper

class SuperHero: Mappable {
    
    var identifier: Int!
    var name: String!
    var description: String!
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
        name <- map["name"]
        imageExtension <- map["thumbnail.extension"]
        imagePath <- map["thumbnail.path"]
        description <- map["description"]
    }
}
