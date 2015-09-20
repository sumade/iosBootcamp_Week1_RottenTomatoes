//
//  Movie.swift
//  RottenTomatoes
//
//  Created by Sumeet Shendrikar on 9/20/15.
//  Copyright © 2015 Sumeet Shendrikar. All rights reserved.
//

import Foundation

class Movie {
    
    // json dictionary
    var movieDictionary : NSDictionary!
        
    // movie title
    var title : String? {
        return movieDictionary["title"] as? String
    }
    
    // movie rating
    var mpaaRating : String? {
        return movieDictionary["mpaa_rating"] as? String
    }
    
    // year
    var year : Int? {
        return movieDictionary["year"] as? Int
    }
    
    // release date
    var releaseDate : NSDate? {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.dateFromString(movieDictionary.valueForKeyPath("release_dates.theater") as! String)
    }
    
    // runtime
    var runtime : Int? {
        return movieDictionary["runtime"] as? Int
    }
    
    // ratings
    var ratings : NSDictionary? {
        return movieDictionary["ratings"] as? NSDictionary
    }
    
    // synopsis
    var synopsis : String? {
        return movieDictionary["synopsis"] as? String
    }
    
    // cast
    var cast : [NSDictionary]? {
        return movieDictionary["abridged_cast"] as? [NSDictionary]
    }
    
    // urls
    var thumbUrlAsString : String? {
        return movieDictionary.valueForKeyPath("posters.thumbnail") as? String
    }
    
    var thumbUrlAsNSURL : NSURL? {
        return NSURL(string: self.thumbUrlAsString!)
    }
    
    var posterUrlAsString : String? {
        if let url = self.thumbUrlAsString {
            let range = url.rangeOfString(".*cloudfront.net/", options: .RegularExpressionSearch)
            if let range = range {
                return url.stringByReplacingCharactersInRange(range, withString: "https://content6.flixster.com/")
            }
        }
        return nil
    }
    
    var posterUrlAsNSURL : NSURL? {
        return NSURL(string: self.posterUrlAsString!)
    }
}