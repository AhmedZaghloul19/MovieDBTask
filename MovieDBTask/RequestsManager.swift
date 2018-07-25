//
//  RequestsManager.swift
//  MovieDBTask
//
//  Created by Ahmed Zaghloul on 7/23/18.
//  Copyright © 2018 AhmedZaghloul. All rights reserved.
//

import Foundation
/**
 **Manager of all API Reqesuts**.
 ````
 static let defaultManager = RequestManager()
 private let requestTimourInterval = 20.0
 ````
 
 - defaultManager: Default manager to confirm singleton pattern.
 - requestTimourInterval: Maximum time taken for the request.
 
 ## Important Notes ##
 - This Class Confirms **Singleton Design Pattern**
 
 */
class RequestManager{
    static let defaultManager = RequestManager()
    private init (){}
    private let requestTimoutInterval = 20.0

    /**
     Requesting list of Movies from the API.
     Returns Closure With Parameters :
     - Parameter error: Boolean if the request has been done successfully.
     - Parameter movies: Array of the returned objects.
     - Parameter refreshInterval: To know when to refresh the data.
     
     ## Important Notes ##
     - The Service is a **GET** method.
     */
    func getMoviesWith(Keyword keyword:String,pageNo:Int,compilition : @escaping (_ error : Bool,_ movies:[Movie]?,_ totalPages:Int?)->Void){
        let url = URL(string:( SERVICE_URL_PREFIX + "search/movie?api_key=\(MOVIE_DB_API_KEY)&query=\(keyword)&page=\(pageNo)").addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)!
        let mutableURLRequest = NSMutableURLRequest(url: url,
                                                    cachePolicy: .useProtocolCachePolicy,
                                                    timeoutInterval: requestTimoutInterval)
        mutableURLRequest.setBodyConfigrationWithMethod(method: "GET")
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: mutableURLRequest as URLRequest, completionHandler: { (data, response, error) -> Void in
            if let res:HTTPURLResponse = response as? HTTPURLResponse {
                print(res.statusCode)
                if (error != nil || (res.statusCode != 200 && res.statusCode != 422)) {
                    compilition(true,nil,nil)
                    return
                }else if res.statusCode == 422 {
                    compilition(false,[],1)
                    return
                }else {
                    var json: NSDictionary!
                    
                    do {
                        json = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions()) as! NSDictionary

                        var totalPages:Int!
                        var movies:[Movie] = []
                        
                        if let response = json["results"] as? [NSDictionary] {
                            totalPages = json.getValueForKey(key: "total_pages", callback: 1)
                            
                            for object in response {
                                movies.append(Movie(data: object as AnyObject))
                            }
                            
                            compilition(false,movies,totalPages)
                            return
                        }else{
                            compilition(true,nil,nil)
                        }
                        
                    } catch {
                        compilition(true,nil,nil)
                    }
                }
            }else {
                compilition(true,nil,nil)
            }
            
        })
        dataTask.resume()
    }
}
