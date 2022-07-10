//
//  ViewController.swift
//  iOSEngineerCodeCheck
//
//  Created by 史 翔新 on 2020/04/20.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import UIKit
import RealmSwift

class SearchRepositoryViewController: UITableViewController, UISearchBarDelegate {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var menuBarButtonItem: UIBarButtonItem!
    
    private var selectedMenu = Menu.normal
    
    // メニュー表示ボタンを押した際に表示される項目
    private enum Menu: CaseIterable {
        case normal // 検索結果が全て表示される通常モード
        case favoriteOnly   // お気に入りかつ検索結果に該当するリポジトリのみ表示するモード
        
        var title: String {
            switch self {
            case .normal:
                return "全て"
            case .favoriteOnly:
                return "お気に入りのみ"
            }
        }
    }
    
    private let searchRepositoryViewModel = SearchRepositoryViewModel()
    var repositories: [Repository] {
        return searchRepositoryViewModel.repositories
    }
    
    var searchingRepositoryTask: URLSessionTask?
    var searchWord: String = ""
    var searchUrlString: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        searchBar.placeholder = "GitHubのリポジトリを検索できるよー"
        searchBar.delegate = self
        initViewModel()
    }
    
    // リポジトリ詳細画面から戻った時にも行いたい処理を書く
    override func viewWillAppear(_ animated: Bool) {
        configureMenu()
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Detail", let repositoryDetailViewController = segue.destination as? RepositoryDetailViewController {
            repositoryDetailViewController.repository = sender as? Repository
        }
    }
    
    // 右上のメニュー表示ボタンの設定
    private func configureMenu() {
        let actions = Menu.allCases.compactMap { type in
            UIAction(
                title: type.title,
                state: type == selectedMenu ? .on : .off,
                handler: { _ in
                    self.selectedMenu = type
                    self.configureMenu()
                    self.tableView.reloadData()
                }
            )
        }
        menuBarButtonItem.menu = UIMenu(title: "", options: .displayInline, children: actions)
    }
    
    // MARK: Init
    // viewModelにtableViewのreloadDataをセットする
    private func initViewModel() {
        searchRepositoryViewModel.reloadHandler = { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    // MARK: Actions
    @objc func tapFavoriteButton(_ sender: UIButton) {
        let repository = repositories[sender.tag]
        if let favoriteRepository = FavoriteRepository.tryGetFavoriteRepository(repositoryId: repository.id) {
            FavoriteRepository.updateFavorite(id: favoriteRepository._id)
        } else {
            FavoriteRepository.upsert(id: nil, favorite: true, repository: repository)
        }
        tableView.reloadData()
    }
    
    // MARK: SearchBar Delegate
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
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
        // モードによって表示する数が変わる
        return selectedMenu == .normal
            ? repositories.count
            : FavoriteRepository.filterFavoriteRepositories(repositories: repositories).count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "SearchRepositoryTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? SearchRepositoryTableViewCell else {
            fatalError("ERROR The dequeued cell is not an instance of SearchRepositoryTableViewCell")
        }
        // モードによって表示するリポジトリが変わる
        let repository = selectedMenu == .normal
            ? repositories[indexPath.row]
            : FavoriteRepository.filterFavoriteRepositories(repositories: repositories)[indexPath.row]
        cell.repositoryTitleLabel.text = repository.fullName
        if let favoriteRepository = FavoriteRepository.tryGetFavoriteRepository(repositoryId: repository.id), favoriteRepository.favorite {
            cell.favoriteButton.setImage(UIImage(systemName: "star.fill"), for: UIControl.State())
        } else {
            cell.favoriteButton.setImage(UIImage(systemName: "star"), for: UIControl.State())
        }
        cell.favoriteButton.tag = indexPath.row
        cell.favoriteButton.addTarget(self, action: #selector(tapFavoriteButton(_:)), for: .touchUpInside)
        cell.tag = indexPath.row
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let repository = repositories[indexPath.row]
        performSegue(withIdentifier: "Detail", sender: repository)
    }
}
