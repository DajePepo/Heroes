//
//  HeroesDataManager.swift
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

class HeroesDataManager {
    
    static func retrieveHeroes(offset: Int = 0, completion: @escaping ([SuperHero]) -> Void) {
        
        let action = "characters"
        let timestamp = "\(NSDate().timeIntervalSince1970)"
        let hash = "\(timestamp)\(privateKey)\(publicKey)".md5()
        let parameters: [String : Any] = ["offset": offset, "limit": limit, "ts" : timestamp, "apikey" : publicKey, "hash" : hash]
        
        Alamofire.request(baseURL + action, parameters: parameters).responseJSON { response in
//            print(response)
            
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
            
            let heroes = results.map { hero in
                SuperHero(JSON: hero)!
            }
            
            completion(heroes)
        }
    }
    
}
