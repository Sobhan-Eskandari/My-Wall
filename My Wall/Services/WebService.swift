//
//  WebService.swift
//  My Wall
//
//  Created by Sobhan Eskandari on 11/23/18.
//  Copyright © 2018 Sobhan Eskandari. All rights reserved.
//

import Foundation
import UIKit

class WebService {
    
    
    var baseURL = "https://pixabay.com/api/?key=7252395-21cd2dae7af1a432c39d2c60f"
    var params:[String:String] = [:]
    
    
    init(params:[String:String]) {
        self.params = params
        for param in params {
            let value = param.value.replacingOccurrences(of: " ", with: "+")
            baseURL += "&"
            baseURL += "\(param.key)=\(value)"
        }
    }
    
    func getWallpapers(completion:@escaping ([Wallpaper],Error?) -> ()) {
        
        let reqUrl = URL(string: baseURL)
        URLSession.shared.dataTask(with: reqUrl!) { (data, _, error) in
            do {
                if let data = data {
                    let jsonData = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
                    let json = jsonData as! [String:Any]
                    let wallsJson = json["hits"] as! [[String:Any]]
                    let wallsData = try JSONSerialization.data(withJSONObject: wallsJson, options: [])
                    let walls = try JSONDecoder().decode([Wallpaper].self, from: wallsData)
                    DispatchQueue.main.async {
                        completion(walls,error)
                    }
                }
            } catch {
                print(error)
            }
        }.resume()
        
    }
    
    static func downloadImage(url:String,completion:@escaping (UIImage)->()) {
        
        if let url = URL(string: url) {
            DispatchQueue.global().async {
                
                let data = NSData.init(contentsOf: url)
                DispatchQueue.main.async {
                    
                    let image = UIImage(data: data! as Data)
                    completion(image!)
                }
            }
        }
        
    }
    
}
