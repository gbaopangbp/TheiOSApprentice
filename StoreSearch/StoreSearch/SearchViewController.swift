//
//  ViewController.swift
//  StoreSearch
//
//  Created by cm on 16/1/8.
//  Copyright © 2016年 cm. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    var searchResults = [SearchResult]()
    var hasSearched = false
    var isLoading = false
    var dataTask:NSURLSessionDataTask?
    
    struct TableViewCellIdentifiders {
        static let searchResultCell = "SearchResultCell"
        static let nothingFoundCell = "NothingFoundCell"
        static let loadingCell = "LoadingCell"
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tableView.contentInset = UIEdgeInsets(top: 108, left: 0, bottom: 0, right: 0)
        tableView.rowHeight = 80
        var cellNib = UINib(nibName: "SearchResultCell", bundle: nil)
        tableView.registerNib(cellNib, forCellReuseIdentifier: TableViewCellIdentifiders.searchResultCell)
        cellNib = UINib(nibName: "NothingFoundCell", bundle: nil)
        tableView.registerNib(cellNib, forCellReuseIdentifier: TableViewCellIdentifiders.nothingFoundCell)
        cellNib = UINib(nibName: "LoadingCell", bundle: nil)
        tableView.registerNib(cellNib, forCellReuseIdentifier: TableViewCellIdentifiders.loadingCell)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension SearchViewController:UITableViewDelegate{
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        if searchResults.count == 0 || isLoading{
            return nil
        } else {
            return indexPath
        }
    }

    
}

extension SearchViewController:UITableViewDataSource{
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isLoading {
            return 1
        } else if !hasSearched {
            return 0
        } else if searchResults.count == 0 {
            return 1;
        } else {
            return searchResults.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(TableViewCellIdentifiders.searchResultCell) as! SearchResultCell
        if isLoading {
            return tableView.dequeueReusableCellWithIdentifier(TableViewCellIdentifiders.loadingCell)!;
        } else if searchResults.count == 0 {
            return tableView.dequeueReusableCellWithIdentifier(TableViewCellIdentifiders.nothingFoundCell)!
        } else {
            let result = searchResults[indexPath.row]
            cell.nameLabel.text = result.name
            cell.artistNameLabel.text = result.artistName
        }
    
        
        return cell
    }
}

extension SearchViewController:UISearchBarDelegate{
    func performStoreRequestWithURL(url: NSURL) -> String? {
        
        do{
            let resultString = try String(contentsOfURL: url, encoding: NSUTF8StringEncoding)
            return resultString
        }catch{
            
        }
        return nil
    }
    
    func urlWithSearchText(searcheText: String, category:Int) -> NSURL {
        var entityName:String
        switch category{
        case 1:entityName = "nusicTrack"
        case 2: entityName = "software"
        case 3: entityName = "ebook"
        default: entityName = ""
        }
        
        let escapedSearchText = searcheText.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
        let urlString = String(format: "http://itunes.apple.com/search?term=%@@limit=200@entity=%@", escapedSearchText!,entityName)
        
        return NSURL(string: urlString)!
    }
    
    func parseJson (jsonString: String) -> [String:AnyObject]?{
        if let jsonData = jsonString.dataUsingEncoding(NSUTF8StringEncoding) {
            
            do{
                if let json = try NSJSONSerialization.JSONObjectWithData(jsonData, options: NSJSONReadingOptions.AllowFragments) as? [String:AnyObject] {
                    return json
                }
            }catch {
                
            }
        }
        return nil
    }
    
    func parseDirctionary(dictionary: [String:AnyObject]) -> [SearchResult] {
        var results = [SearchResult]()
        
        if let array:AnyObject = dictionary["results"] {
            
            for resultDic in array as! [AnyObject]{
                var searchResult :SearchResult?
                if let resultDic = resultDic as? [String:AnyObject] {
                    if let wrapperType = resultDic["wrapperType"] as? NSString {
                        switch wrapperType {
                            case "track":
                                searchResult = parseTrack(resultDic)
                            case "audiobook":
                                searchResult = parseAudioBook(resultDic)
                            case "software":
                                searchResult = parseSoftware(resultDic)
                        default:
                            break
                        }
                    } else if let kind = resultDic["kind"] as? String {
                        if kind == "ebook" {
                            searchResult = parseEBook(resultDic)
                        }
                    }
                }
                
                if let result = searchResult {
                    results.append(result)
                }
            }
        }
 
        return results
    }
    
    func parseTrack(dictionary:[String:AnyObject])->SearchResult {
        let searchResult = SearchResult()
        
        searchResult.name = dictionary["trackName"] as! String
        searchResult.artistName = dictionary["artistName"] as! String
        searchResult.artworkURL60 = dictionary["artworkUrl60"] as! String
        searchResult.artworkURL100 = dictionary["artworkUrl100"] as! String
        searchResult.storeURL = dictionary["trackViewUrl"] as! String
        searchResult.kind = dictionary["kind"] as! String
        searchResult.currency = dictionary["currency"] as! String
        if let price = dictionary["trackPrice"] as? NSNumber {
            searchResult.price = Double(price)
        }
        if let genre = dictionary["primaryGenreName"] as? String {
            searchResult.genre = genre
        }
        return searchResult
    }
    
    func parseAudioBook(dictionary: [String: AnyObject]) -> SearchResult { let searchResult = SearchResult()
            searchResult.name = dictionary["collectionName"] as! String
            searchResult.artistName = dictionary["artistName"] as! String
            searchResult.artworkURL60 = dictionary["artworkUrl60"] as! String
            searchResult.artworkURL100 = dictionary["artworkUrl100"] as! String
            searchResult.storeURL = dictionary["collectionViewUrl"] as! String
            searchResult.kind = "audiobook"
            searchResult.currency = dictionary["currency"] as! String
            if let price = dictionary["collectionPrice"] as? NSNumber { searchResult.price = Double(price)
            }
            if let genre = dictionary["primaryGenreName"] as? String {
            searchResult.genre = genre
            }
            return searchResult
    }
    
    func parseSoftware(dictionary: [String: AnyObject]) -> SearchResult { let searchResult = SearchResult()
                searchResult.name = dictionary["trackName"] as! String
                searchResult.artistName = dictionary["artistName"] as! String
                searchResult.artworkURL60 = dictionary["artworkUrl60"] as! String
                searchResult.artworkURL100 = dictionary["artworkUrl100"] as! String
                searchResult.storeURL = dictionary["trackViewUrl"] as! String
                searchResult.kind = dictionary["kind"] as! String
                searchResult.currency = dictionary["currency"] as! String
                if let price = dictionary["price"] as? NSNumber {
                searchResult.price = Double(price)
                }
                if let genre = dictionary["primaryGenreName"] as? String {
                searchResult.genre = genre
                }
                return searchResult
    }
    
    func parseEBook(dictionary: [String: AnyObject]) -> SearchResult {
                let searchResult = SearchResult()
                searchResult.name = dictionary["trackName"] as! String
                searchResult.artistName = dictionary["artistName"] as! String
                searchResult.artworkURL60 = dictionary["artworkUrl60"] as! String
                searchResult.artworkURL100 = dictionary["artworkUrl100"] as! String
                searchResult.storeURL = dictionary["trackViewUrl"] as! String
                searchResult.kind = dictionary["kind"] as! String
                searchResult.currency = dictionary["currency"] as! String
                if let price = dictionary["price"] as? NSNumber {
                    searchResult.price = Double(price)
                }
                if let genres: AnyObject = dictionary["genres"] {
                    searchResult.genre = ", "
                }
                return searchResult
    }
    
    func showNetError(){
        let alert = UIAlertController(title: "Alert", message: "Net Error", preferredStyle: .Alert)
        
        let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alert.addAction(action)
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func parseJSON(data:NSData) -> [String:AnyObject]?{
        do{
            if let json = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(rawValue: 0)) as? [String:AnyObject]{
            return json
            }
            }catch{
                
            }
        return nil
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar){
        performSearch()
    }
    
    
    func positionForBar(bar: UIBarPositioning) -> UIBarPosition {
        return .TopAttached
    }
    
    @IBAction func segmentChange(sender: AnyObject) {
        performSearch()
    }
    
    func performSearch(){
        if searchBar.text != "" {
            hasSearched = true
            searchBar.resignFirstResponder()
            
            isLoading = true
            tableView.reloadData()
            
            dataTask?.cancel()
            let url = self.urlWithSearchText(searchBar.text!,category: segmentControl.selectedSegmentIndex)
            let session = NSURLSession.sharedSession()
            dataTask = session.dataTaskWithURL(url, completionHandler: {
                data, reponse, error in
                
                if let _ = error {
                    if error?.code == 900 {
                        return;
                    }
                    print("error")
                    self.isLoading = false
                    self.hasSearched = false
                    self.showNetError()
                    self.tableView.reloadData()
                } else if let httpResponse = reponse as? NSHTTPURLResponse{
                    
                    
                } else {
                    let dic = self.parseJSON(data!)
                    self.searchResults =  self.parseDirctionary(dic!)
                    self.searchResults.sortInPlace({result1, result2 in
                        return result1.name.localizedStandardCompare(result2.name) == NSComparisonResult.OrderedAscending
                    })
                    dispatch_async(dispatch_get_main_queue()){
                        self.isLoading = false
                        self.tableView.reloadData()
                    }
                }
                
            })
            dataTask?.resume()
            
            let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
            dispatch_async(queue){
                let url = self.urlWithSearchText(self.searchBar.text!, category: self.segmentControl.selectedSegmentIndex)
                if let resut = self.performStoreRequestWithURL(url) {
                    if let dic = self.parseJson(resut) {
                        print("\(dic)")
                        self.searchResults =  self.parseDirctionary(dic)
                        self.searchResults.sortInPlace({result1, result2 in
                            return result1.name.localizedStandardCompare(result2.name) == NSComparisonResult.OrderedAscending
                        })
                        dispatch_async(dispatch_get_main_queue()){
                            self.isLoading = false
                            self.tableView.reloadData()
                        }
                        
                        return
                    }
                }
                dispatch_async(dispatch_get_main_queue()){
                    self.showNetError()
                }
            }
            
            
        }
    }
    
}

