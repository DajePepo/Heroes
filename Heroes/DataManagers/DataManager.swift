//
//  DataManager.swift
//  Heroes
//
//  Created by Pietro Santececca on 25.08.18.
//  Copyright © 2018 Tecnojam. All rights reserved.
//

import Alamofire
import ObjectMapper
import CryptoSwift
import SwiftyJSON

let baseURL = "https://gateway.marvel.com/v1/public/"
let publicKey = "ce95422c848c206246b96c0969701a5f"
let privateKey = "20177ea92d7284af7a2baad0040fb180d69a135b"
let limit = 20 // max number of items per request

class DataManager {
    
    static func retrieveData(offset: Int = 0, action: String, extraParameters: [String : Any]? = nil, completion: @escaping ([[String:Any]]) -> Void) {
        
        let timestamp = "\(NSDate().timeIntervalSince1970)"
        let hash = "\(timestamp)\(privateKey)\(publicKey)".md5()
        var parameters: [String : Any] = ["offset": offset, "limit": limit, "ts" : timestamp, "apikey" : publicKey, "hash" : hash]
        if let extraParameters = extraParameters {
            parameters.merge(extraParameters) { (_, new) in new }
        }
        
        Alamofire.request(baseURL + action, parameters: parameters).responseJSON { response in
            guard response.result.isSuccess,
                let value = response.result.value,
                let json = JSON(value).dictionaryObject,
                json["code"] as? Int == 200,
                let data = json["data"] as? [String:Any],
                let results = data["results"] as? [[String:Any]] else {
                    
                    print("Error while fetching data: \(String(describing: response.result.error))")
                    completion([])
                    return
            }
            
            completion(results)
        }
    }
    
    static func retrieveHeroes(offset: Int = 0, filter: String = "", completion: @escaping ([SuperHero]) -> Void) {
        self.retrieveData(offset: offset, action: "characters") { results in
            let heroes = results.map { hero in SuperHero(JSON: hero)! }
            completion(heroes)
        }
    }
    
    static func retrieveComics(heroId: Int, completion: @escaping ([Comic]) -> Void) {
        self.retrieveData(action: "characters/\(heroId)/comics") { results in
            let comics = results.map { comic in Comic(JSON: comic)! }
            completion(comics)
        }
    }
    
}
