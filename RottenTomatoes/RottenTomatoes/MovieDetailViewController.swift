//
//  MovieDetailViewController.swift
//  RottenTomatoes
//
//  Created by Sumeet Shendrikar on 9/19/15.
//  Copyright © 2015 Sumeet Shendrikar. All rights reserved.
//

import UIKit

class MovieDetailViewController: UIViewController {

    @IBOutlet weak var detailScrollView: UIScrollView!
    @IBOutlet weak var posterImage: UIImageView!

    @IBOutlet weak var synopsisLabel: UILabel!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var yearLabel: UILabel!
    
    @IBOutlet weak var mpaaRatingLabel: UILabel!
    
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var criticsRatingLabel: UILabel!
    
    @IBOutlet weak var audienceRatingsLabel: UILabel!
    
    @IBOutlet weak var releaseDateLabel: UILabel!
    
    @IBOutlet weak var runtimeLabel: UILabel!
    
    @IBOutlet weak var castLabel: UILabel!
    
    var movie : Movie?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        if let movie = movie {
            // set the menu title to the movie's title
            self.title = movie.title
            
            // check if poster is cached already
            if let posterURL = movie.posterUrlAsNSURL {
                let posterURLRequest = NSURLRequest(URL: posterURL)
                let poster = UIImageView.sharedImageCache().cachedImageForRequest(posterURLRequest)
                
                if poster != nil {
                    // poster image cached...
                    posterImage.image = poster
                }else{
                    // poster image not cached...
                    
                    // set initial background to thumnbail if cached
                    if let nsURL = movie.thumbUrlAsNSURL {
                        let thumbImgURLRequest = NSURLRequest(URL: nsURL)
                        let thumbnailImage = UIImageView.sharedImageCache().cachedImageForRequest(thumbImgURLRequest)
                        
                        if thumbnailImage != nil {
                            posterImage.image = thumbnailImage
                        }
                    }
                    
                    posterImage.setImageWithURLRequest(NSURLRequest(URL: posterURL), placeholderImage: nil,
                        success: { (request, response, image) -> Void in
                            dispatch_async(dispatch_get_main_queue(), {
                                UIView.transitionWithView(self.posterImage,
                                    duration:2,
                                    options: .TransitionCrossDissolve,
                                    animations: {
                                        self.posterImage.image = image
                                    },
                                    completion: nil)
                            })
                        },
                        failure: { (request, response, error) -> Void in
                            // show network alert
                    })

                }
            }else{
                posterImage.image = nil
            }

            
            titleLabel.text = movie.title
            if let rating = movie.mpaaRating {
                mpaaRatingLabel.text = "Rating: \(rating)"
            }else{
                mpaaRatingLabel.text = "Rating: ???"
            }
            
            if let year = movie.year {
                yearLabel.text = String(year)
            }else{
                yearLabel.text = ""
            }
            
            if let date = movie.releaseDate {
                
                let dayTimePeriodFormatter = NSDateFormatter()
                dayTimePeriodFormatter.dateFormat = "MMMM dd, yyyy"
                
                releaseDateLabel.text = dayTimePeriodFormatter.stringFromDate(date)
            }else{
                releaseDateLabel.text = ""
            }
                
            if let runtime = movie.runtime {
                runtimeLabel.text = "Runtime \(runtime) min"
            }else{
                runtimeLabel.text = "Runtime ??? min"
            }
            
            audienceRatingsLabel.text = ""
            if let audienceRating = movie.ratings?["audience_rating"] as? String {
                if let audienceRatingNum = movie.ratings?["audience_score"] as? Int {
                    audienceRatingsLabel.text = "\(audienceRating) (\(audienceRatingNum)%)"
                }
            }else{
                audienceRatingsLabel.text = ""
            }

            criticsRatingLabel.text = ""
            if let criticsRatings = movie.ratings?["critics_rating"] as? String {
                if let criticsRatingNum = movie.ratings?["critics_score"] as? Int {
                    criticsRatingLabel.text =   "\(criticsRatings) (\(criticsRatingNum)%)"
                }
            }else{
                criticsRatingLabel.text = ""
            }

            if let text = movie.synopsis {
                synopsisLabel.numberOfLines = 0
                synopsisLabel.text = text
                synopsisLabel.layoutIfNeeded()
            }else{
                synopsisLabel.text = ""
            }
            
            // comma separated list of cast
            if let cast = movie.cast?.map({$0["name"] as! String}) {
                let castStr = cast.joinWithSeparator(", ")
                castLabel.text = "Cast: \(castStr)"
            }else{
                castLabel.text = ""
            }
            
            
            let newCastSize = castLabel.sizeThatFits(CGSizeMake(castLabel.frame.size.width, CGFloat.max))
            var newCastFrame = castLabel.frame
            newCastFrame.size.height = newCastSize.height

            let newSynSize  = synopsisLabel.sizeThatFits(CGSizeMake(synopsisLabel.frame.size.width, CGFloat.max))
            var newSynFrame = synopsisLabel.frame
            newSynFrame.size.height = newSynSize.height
            

            // adjust the container view
            let newContainerHeight = min(containerView.frame.height, newSynFrame.origin.y + newSynFrame.size.height)
            containerView.frame.size = CGSizeMake(containerView.frame.width, newContainerHeight+50)
            
            // adjust the labels
            castLabel.frame = newCastFrame
            synopsisLabel.frame = newSynFrame

            // set the scroll height
            let contentWidth = detailScrollView.bounds.width
            let contentHeight = containerView.frame.origin.y + containerView.frame.height // some fudge factor
            self.detailScrollView.contentSize = CGSizeMake(contentWidth, contentHeight)
            
            self.detailScrollView.layoutIfNeeded()
            
        }
    }

    func printDimensions(label:String){
        print(label)
        print("container frame: \(containerView.frame)")
        print("container bounds: \(containerView.bounds)")
        print("label frame: \(synopsisLabel.frame)")
        print("label bounds: \(synopsisLabel.bounds)")
        print("cast frame: \(castLabel.frame)")
        print("cast bounds: \(castLabel.bounds)")
        print("scroll frame: \(detailScrollView.frame)")
        print("scroll bounds: \(detailScrollView.bounds)")
        print("scroll content size: \(detailScrollView.contentSize)")

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
