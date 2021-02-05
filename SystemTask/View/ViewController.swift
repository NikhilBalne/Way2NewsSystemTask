//
//  ViewController.swift
//  SystemTask
//
//  Created by Nikhil Balne on 29/10/20.
//

import UIKit

class ViewController: UIViewController {

    var newsTableDataArray = [NewsPostModel]()
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var newsTableView: UITableView!
    
    var filteredData = [NewsPostModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        newsTableView.rowHeight = UITableView.automaticDimension
        newsTableView.estimatedRowHeight = 600
        
        makeGetServiceCall()
    }

    func makeGetServiceCall(){
        
        let dictionary: [String : Any] = [
            "MID": "01C6495D-0733-4885-A6B1-250D6ED06EBA",
            "PAGENO": "0",
            "STATUS":  "district",
            "TOKEN":"4tYdii5Mf68sjfmiNcFVWHgVFVsla19vdgFkI2XeH0qFanRH4bU2/pE9Yvs/NwK4GUFBhLGcBuHt\nuPrQ8O/KLduQHvxdMpc5l4qnSvZ1+vO3ENUZ5d9lqmdnSKvFDoEOOKK7pB2JCh3JU8bFTh2gX+lu\nVZG+NbZeEKzff9iC/h8F/8zgcgly2c1GvjiACRlVKbsvzaA6CLN4Za2B7nnS+6yWLrQnAjWa1QMg\nGeq8M6b2gSLAhm1SMssO7uYAfttDOsj8Q48GX220vnhfqU9bt/0iYEx8ydJ3zvbafg8qkRNWyNiB\ngTus8M+VOfWFmAH3rxeOQvx+3QYkKE1L3TJU34Z7zLMJSIy2LFBW4eCXhc/iSKsl9z4sJo497F0q\nGg8QB80dHkiZNeeYBDaQYlHTwFgvJN48yabxk5d92RQ1hq0VYxqfRH+07TZN0ndR0LvM",
            "os": "ios",
            "version":"5.3"
        ]

        let data = try! JSONSerialization.data(withJSONObject: dictionary)
        let base64Representation = data.base64EncodedString()

        let url = "http://labugcv1.way2news.co/ugc/getPosts/" + base64Representation

        URLSession.shared.dataTask(with: URL(string: url)!) { (serviceData, serviceResponse, error) in
            
            if error == nil {
                
                let httpStatusCode = serviceResponse as! HTTPURLResponse
                
                if httpStatusCode.statusCode == 200 {
                    let decoder = JSONDecoder()
                    do {
                        let result = try decoder.decode(MandelNewsPosts.self, from: serviceData!)
                        
                        let dataString : String = result.data
                        
                        let jsonData: AnyObject? = dataString.convertToJSON() as AnyObject
                        
                        let resultsArray = jsonData as! NSArray

                        for singleObj in 1..<resultsArray.count {
                           let resultsDictonary = resultsArray[singleObj] as! NSDictionary

                            let objMandelPost = NewsPostModel(title: resultsDictonary["title"] as? String ?? "", content: resultsDictonary["content"] as? String ?? "", imageUrl: resultsDictonary["imageUrl"] as? String ?? "", postStatus: (resultsDictonary["postStatus"] as? String ?? "")!)
                            
                            self.newsTableDataArray.append(objMandelPost)
                            self.filteredData = self.newsTableDataArray
                        }
                        
//                        print("Length:\(self.tableDataArray.count)")
                        
                        DispatchQueue.main.async {
                            self.newsTableView.reloadData()
                        }
                        
                        
                    } catch let serilizationError {
                        print("SerilizationError:\(serilizationError)")
                    }
                    
                } else {
                    print("StatusCode:\(httpStatusCode.statusCode)")
                }
                
            } else {
                print("Error:\(error)")
            }
            
        }.resume()
        
    }
    
}

extension ViewController : UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let newsCell = tableView.dequeueReusableCell(withIdentifier: "PostsTableViewCell") as! NewsTableViewCell
        
        let newsObj = filteredData[indexPath.row]
        newsCell.setNewsDetails(newsItem: newsObj)
        return newsCell
    }
    

}

extension ViewController : UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        //This is For Case Insensitive i.e Searches When Nikhil or nikhil is Typed Searched Correctly
        self.newsTableDataArray = newsTableDataArray.filter{
            $0.postStatus.range(of: searchText, options: .caseInsensitive) != nil
        }
        if searchText.count == 0 {
            searchBar.text = ""
            self.filteredData = newsTableDataArray.sorted { ($0.postStatus ) < ($1.postStatus ) }
        }
        newsTableView.reloadData()
    }
}

