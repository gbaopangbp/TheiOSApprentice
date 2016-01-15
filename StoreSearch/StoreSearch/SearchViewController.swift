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
    
    var searchResults = [SearchResult]()
    var hasSearched = false
    
    struct TableViewCellIdentifiders {
        static let searchResultCell = "SearchResultCell"
        static let nothingFoundCell = "NothingFoundCell"
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tableView.contentInset = UIEdgeInsets(top: 64, left: 0, bottom: 0, right: 0)
        tableView.rowHeight = 80
        var cellNib = UINib(nibName: "SearchResultCell", bundle: nil)
        tableView.registerNib(cellNib, forCellReuseIdentifier: TableViewCellIdentifiders.searchResultCell)
        cellNib = UINib(nibName: "NothingFoundCell", bundle: nil)
        tableView.registerNib(cellNib, forCellReuseIdentifier: TableViewCellIdentifiders.nothingFoundCell)

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
        if searchResults.count == 0 {
            return nil
        } else {
            return indexPath
        }
    }
}

extension SearchViewController:UITableViewDataSource{
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !hasSearched {
            return 0
        } else if searchResults.count == 0 {
            return 1;
        } else {
            return searchResults.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(TableViewCellIdentifiders.searchResultCell) as! SearchResultCell
        
        if searchResults.count == 0 {
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
    
    func urlWithSearchText(searcheText: String) -> NSURL {
        let escapedSearchText = searcheText.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
        let urlString = String(format: "http://itunes.apple.com/search?term=%@", escapedSearchText!)
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
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar){
        
        if searchBar.text != "" {
            hasSearched = true
            searchBar.resignFirstResponder()
            
            let url = urlWithSearchText(searchBar.text!)
            if let resut = performStoreRequestWithURL(url) {
                if let dic = parseJson(resut) {
                    print("\(dic)")
                    searchResults =  parseDirctionary(dic)
                    searchResults.sort({result1, result2 in
                            return result1.name.localizedStandardCompare(result2.name) == NSComparisonResult.OrderedAscending
                    })
                    tableView.reloadData()
                    return
                }
            }
            showNetError()
        }
    }
    
    
    func positionForBar(bar: UIBarPositioning) -> UIBarPosition {
        return .TopAttached
    }
}

