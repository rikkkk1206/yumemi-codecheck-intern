//
//  ViewController.swift
//  iOSEngineerCodeCheck
//
//  Created by 史 翔新 on 2020/04/20.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import UIKit

class SearchRepositoryViewController: UITableViewController, UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    
    var repositories: [[String: Any]]=[]
    
    var searchingRepositoryTask: URLSessionTask?
    var searchWord: String!
    var searchUrlString: String!
    var currentIndex: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        searchBar.text = "GitHubのリポジトリを検索できるよー"
        searchBar.delegate = self
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        // ↓こうすれば初期のテキストを消せる
        searchBar.text = ""
        return true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchingRepositoryTask?.cancel()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        searchWord = searchBar.text!
        // 検索ワードが0の場合は何もしない
        if searchWord.count == 0 {
            return
        }
        
        searchUrlString = "https://api.github.com/search/repositories?q=\(searchWord!)"
        // GitHubにアクセスするタスクを生成
        searchingRepositoryTask = URLSession.shared.dataTask(with: URL(string: searchUrlString)!) { (data, res, err) in
            if let object = try! JSONSerialization.jsonObject(with: data!) as? [String: Any],
               let items = object["items"] as? [[String: Any]] {
                // 検索結果から該当するリポジトリを取得
                self.repositories = items
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
        // これ呼ばなきゃリストが更新されません
        searchingRepositoryTask?.resume()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "Detail"{
            let repositoryDetailViewController = segue.destination as! RepositoryDetailViewController
            repositoryDetailViewController.searchRepositoryViewController = self
        }
        
    }
    
    // MARK: TableView Delegate
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repositories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        let repository = repositories[indexPath.row]
        cell.textLabel?.text = repository["full_name"] as? String ?? ""
        cell.detailTextLabel?.text = repository["language"] as? String ?? ""
        cell.tag = indexPath.row
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        currentIndex = indexPath.row
        performSegue(withIdentifier: "Detail", sender: self)
        
    }
    
}
