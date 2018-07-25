//
//  Movie.swift
//  MovieDBTask
//
//  Created by Ahmed Zaghloul on 7/23/18.
//  Copyright © 2018 AhmedZaghloul. All rights reserved.
//

import Foundation
/**
 Movie Model.
 ````
 public var vote_count : Int?
 public var id : Int?
 public var video : Bool?
 public var vote_average : Double?
 public var title : String?
 public var popularity : Double?
 public var poster_path : String?
 public var original_language : String?
 public var original_title : String?
 public var genre_ids : Array<Int>?
 public var backdrop_path : String?
 public var adult : Bool?
 public var overview : String?
 public var release_date : String?
 ````
 
 - vote_count : Counter for the reviews
 - id : ID of the object
 - video : if the movie having a video
 - vote_average : average vote from the reviewwers
 - title : Movie Title
 - popularity : No of views
 - poster_path : Image url for the poster image
 - original_language : Movie Language
 - original_title : Movie Title
 - genre_ids : IDs for the genre worked on the film
 - backdrop_path : ...
 - adult : ...
 - overview : ...
 - release_date : ...
 
 ## Important Notes ##
 - poster_path Attribute is of type **String**
 */
public class Movie {
    public var vote_count : Int?
    public var id : Int?
    public var video : Bool?
    public var vote_average : Double?
    public var title : String?
    public var popularity : Double?
    public var poster_path : String?
    public var original_language : String?
    public var original_title : String?
    public var genre_ids : Array<Int>?
    public var backdrop_path : String?
    public var adult : Bool?
    public var overview : String?
    public var release_date : String?
    
    /**
     Constructs the object based on the given dictionary.
     
     Sample usage:
     let movie = movie(someDictionaryFromJSON)
     
     - parameter dictionary:  AnyObject from JSON.
     
     - returns: Movie Instance.
    */
    
    init(data:AnyObject){
        if let data = data as? NSDictionary {
            id = data.getValueForKey(key:"id", callback: 0)
            backdrop_path = data.getValueForKey(key:"backdrop_path", callback: "")
            vote_count = data.getValueForKey(key:"vote_count", callback: 0)
            title = data.getValueForKey(key:"title", callback: "")
            poster_path = data.getValueForKey(key:"poster_path", callback: "")
            original_language = data.getValueForKey(key:"original_language", callback: "")
            original_title = data.getValueForKey(key:"original_title", callback: "")
            video = data.getValueForKey(key:"video", callback: false)
            vote_average = data.getValueForKey(key:"vote_average", callback: 0.0)
            popularity = data.getValueForKey(key:"popularity", callback: 0.0)
            adult = data.getValueForKey(key:"adult", callback: false)
            overview = data.getValueForKey(key:"overview", callback: "")
            release_date = data.getValueForKey(key:"release_date", callback: "")
            let genIDs = data.getValueForKey(key: "genre_ids", callback: [Int]())
            for id in genIDs {
                genre_ids?.append(id)
            }
        }
    }
}
