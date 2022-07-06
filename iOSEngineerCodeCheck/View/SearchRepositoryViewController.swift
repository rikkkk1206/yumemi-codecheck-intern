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
    
    private let searchRepositoryViewModel = SearchRepositoryViewModel()
    var repositories: [Repository] {
        return searchRepositoryViewModel.repositories
    }
    
    var searchingRepositoryTask: URLSessionTask?
    var searchWord: String = ""
    var searchUrlString: String = ""
    var currentIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        searchBar.text = "GitHubのリポジトリを検索できるよー"
        searchBar.delegate = self
        initViewModel()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Detail", let repositoryDetailViewController = segue.destination as? RepositoryDetailViewController {
            repositoryDetailViewController.searchRepositoryViewController = self
        }
    }
    
    // MARK: Init
    // viewModelにtableViewのreloadDataをセットする
    private func initViewModel() {
        searchRepositoryViewModel.reloadHandler = { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    // MARK: SearchBar Delegate
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        // ↓こうすれば初期のテキストを消せる
        searchBar.text = ""
        return true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchingRepositoryTask?.cancel()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchWord = searchBar.text ?? ""
        // 検索ワードが0の場合は何もしない
        if searchWord.count == 0 {
            return
        }
        
        searchUrlString = "https://api.github.com/search/repositories?q=\(searchWord)"
        if let url = URL(string: searchUrlString) {
            // GitHubにアクセスするタスクを生成
            searchingRepositoryTask = searchRepositoryViewModel.fetchRepositories(url: url)
        }
    }
    
    // MARK: TableView Delegate
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repositories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let repository = repositories[indexPath.row]
        cell.textLabel?.text = repository.fullName
        cell.detailTextLabel?.text = repository.language
        cell.tag = indexPath.row
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        currentIndex = indexPath.row
        performSegue(withIdentifier: "Detail", sender: self)
    }
}
