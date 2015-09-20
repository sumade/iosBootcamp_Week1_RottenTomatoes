//
//  MoviesViewController.swift
//  RottenTomatoes
//
//  Created by Sumeet Shendrikar on 9/19/15.
//  Copyright © 2015 Sumeet Shendrikar. All rights reserved.
//

import UIKit
import MBProgressHUD

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {

    @IBOutlet weak var movieTableView: UITableView!
    @IBOutlet weak var networkAlertView: UIView!
    @IBOutlet weak var movieSearchBar: UISearchBar!
    
    var movies: [NSDictionary]? {
        didSet {
            networkAlertView.hidden = true
            movieTableView.alpha = 1.0
            self.filteredMovies = movies
        }
    }
    
    var filteredMovies: [NSDictionary]?
    
    // pull to refresh
    var refreshControl:UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set the title
        self.title = "Moovies"
        
        movieTableView.delegate = self
        movieTableView.dataSource = self
        movieSearchBar.delegate = self
        
        // setup refresh control
        self.refreshControl = UIRefreshControl()
        let refreshTitleAttr = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh", attributes:refreshTitleAttr)
        self.refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        self.refreshControl.backgroundColor = UIColor.blackColor()
        self.refreshControl.tintColor = UIColor.whiteColor()
        self.movieTableView.addSubview(refreshControl)
        
        // hack to allow refresh without a table view controller (http://guides.codepath.com/ios/Table-View-Guide#without-a-uitableviewcontroller)
        let dummyTableVC = UITableViewController()
        dummyTableVC.tableView = self.movieTableView
        dummyTableVC.refreshControl = self.refreshControl

        networkAlertView.hidden = true
        self.view.bringSubviewToFront(self.networkAlertView)
        fetchMovieData()
    }

    var refreshCount: Int = 0
    
    func fetchMovieData() {
        
        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        hud.labelText = "Getting Movies"

        let goodURL = NSURL(string: "https://gist.githubusercontent.com/timothy1ee/d1778ca5b944ed974db0/raw/489d812c7ceeec0ac15ab77bf7c47849f2d1eb2b/gistfile1.json")
        let goodRequest = NSURLRequest(URL: goodURL!)
        let badURL = NSURL(string: "this.is.a.dummy.website")
        let badRequest = NSURLRequest(URL: badURL!)
        
        var request = goodRequest
        
        // trigger "network issue" after 5 refresh attempts
        if refreshCount%5==0 {
            request = badRequest
        }
        
        NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: {
            (data, response, error) -> Void in
                if let data = data {
                    let results = try! NSJSONSerialization.JSONObjectWithData(data, options:[]) as! NSDictionary
                    
                    // store the movies
                    if let movies = results["movies"] as? [NSDictionary] {
                        dispatch_async(dispatch_get_main_queue(), {
                            self.movies = movies
                            
                            self.movieTableView.reloadData()
                            
                            // hack for refresh controller
                            self.refreshControl.endRefreshing()
                            MBProgressHUD.hideHUDForView(self.view, animated: true)
                        })
                    }
                }else{
                    if let error = error {
                        dispatch_async(dispatch_get_main_queue(), {
                            self.refreshControl.endRefreshing()
                            MBProgressHUD.hideHUDForView(self.view, animated: true)
                            self.movieTableView.alpha = 0.5
                            self.networkAlertView.hidden = false
                        })
                    }
                }
        }).resume()
        
    }
    
    func refresh(sender:AnyObject)
    {
        refreshCount++
        fetchMovieData()
    }

    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let movies = filteredMovies {
            return movies.count
        }else{
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = movieTableView.dequeueReusableCellWithIdentifier("movieViewCell", forIndexPath: indexPath) as! MoviesTableViewCell

        if let movie = filteredMovies?[indexPath.row] as NSDictionary! {
            cell.titleLabel.text = movie["title"] as? String
            cell.descLabel.text = movie["synopsis"] as? String
            if let url = movie.valueForKeyPath("posters.thumbnail") as? String {
                cell.thumbImage?.setImageWithURL(NSURL(string: url)!)
            }
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        movieTableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if let movies = self.movies {
            filteredMovies = searchText.isEmpty ? movies : movies.filter({(dict: NSDictionary) -> Bool in
                if let title = dict["title"] as? String {
                    return title.rangeOfString(searchText, options: .CaseInsensitiveSearch) != nil
                }
                return false
            })
            movieTableView.reloadData()
        }
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let detailView = segue.destinationViewController as! MovieDetailViewController;
        let indexPath = movieTableView.indexPathForCell(sender as! UITableViewCell)!
        
        if let movieDict = filteredMovies?[indexPath.row] as NSDictionary! {
            if let movie = detailView.movie {
                // nothing to do
            }else{
                detailView.movie = Movie()
            }
            detailView.movie!.movieDictionary = movieDict
        }
    }
    
    
    @IBAction func tapNetworkAlertGesture(sender: UITapGestureRecognizer) {
        if sender.view == self.networkAlertView {
            // tap to refresh
            refresh(sender)
        }else{
            print("!tap gesture on some other element \(sender)")
        }
    }

}
