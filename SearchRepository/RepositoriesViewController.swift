//
//  RepositoriesViewController.swift
//  SearchRepository
//
//  Created by seibin on 2020/08/28.
//  Copyright © 2020年 seibin. All rights reserved.
//

import UIKit


class RepositoriesViewController: UIViewController {
    @IBOutlet weak var keywordSearchBar: UISearchBar!
    @IBOutlet weak var repositoriesTableview: UITableView!
    
    var repositorieDicInfos: [[String: Any]] = []
    
    private var didSelectIndex: Int?
    private let repositoriyDataProvider = RepositoriyDataProvider()
    private let indicatorView = IndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.barTintColor = .black
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.white
        ]
        
        repositoriyDataProvider.delegate = self
        
        keywordSearchBar.accessibilityIdentifier = Constans.AccessibilityIdentifier.keywordSearchBar
        repositoriesTableview.accessibilityIdentifier = Constans.AccessibilityIdentifier.repositoriesTableview
        
        repositoriesTableview.refreshControl = UIRefreshControl()
        repositoriesTableview.refreshControl?.addTarget(self, action: #selector(refreshTableView(_:)), for: .valueChanged)
        
        indicatorView.frame = view.frame
        // Do any additional setup after loading the view.
    }
    
    @objc private func refreshTableView(_ sender: AnyObject) {
        guard  let keyWord = keywordSearchBar.text, keyWord.trimmingCharacters(in:.whitespaces).count > 0  else {
            endendRefreshing()
            return
        }
        
        repositoriyDataProvider.cancelTask()
        getRepositoryInfos(keyWord)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constans.Identifier.repository, let repositoryViewController =  segue.destination as? RepositoryViewController, let selectIndex = didSelectIndex, selectIndex < repositorieDicInfos.count {
            repositoryViewController.repositorieInfoDic = repositorieDicInfos[selectIndex]
            didSelectIndex = nil
        }
    }
    
    func updateTableView() {
        DispatchQueue.main.async {
            self.repositoriesTableview.reloadData()
        }
    }
    
    func showIndicator() {
        DispatchQueue.main.async {
            self.indicatorView.showIndicator(self.view)
        }
    }
    
    func hiddenIndicator() {
        DispatchQueue.main.async {
            self.indicatorView.hiddenIndicator(self.view)
        }
    }
    
    func getRepositoryInfos(_ keyWord: String) {
        showIndicator()
        DispatchQueue.global().async {
            self.repositoriyDataProvider.getRepositoryInfos(keyWord)
        }
    }
    
    func endendRefreshing() {
        DispatchQueue.main.async {
            self.repositoriesTableview.refreshControl?.endRefreshing()
        }
    }
}

// MARK: - RepositoriyDataProviderDelegate
extension RepositoriesViewController: RepositoriyDataProviderDelegate {
    func successGetRepositoriyInfos(_ infos: [[String: Any]]) {
        hiddenIndicator()
        endendRefreshing()
        print(infos)
        repositorieDicInfos = infos
        updateTableView()
        
    }
    
    func failureGetRepositoriyInfos(_ error: Error?) {
        hiddenIndicator()
        endendRefreshing()
        print(error ?? "Error")
        let alert = UIAlertController(title: nil ,message: error.debugDescription, preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "OK", style: .default, handler: { (UIAlertAction) in
        })
        alert.addAction(yesAction)
        
        present(alert, animated: true, completion: nil)
    }
}

// MARK: - UISearchBarDelegate
extension RepositoriesViewController: UISearchBarDelegate {
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.text = ""
        return true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        repositoriyDataProvider.cancelTask()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        
        guard  let keyWord = searchBar.text, keyWord.trimmingCharacters(in:.whitespaces).count > 0  else {
            return
        }
        
        getRepositoryInfos(keyWord)
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension RepositoriesViewController: UITableViewDataSource, UITableViewDelegate {
    // UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repositorieDicInfos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let repositorieDicInfo = repositorieDicInfos[indexPath.row]
        cell.textLabel?.text = repositorieDicInfo[Constans.RepositoriyKeyName.fullName] as? String ?? ""
        cell.detailTextLabel?.text = repositorieDicInfo[Constans.RepositoriyKeyName.language] as? String ?? ""
        cell.tag = indexPath.row
        return cell
    }
    
    // UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didSelectIndex = indexPath.row
        performSegue(withIdentifier: Constans.Identifier.repository, sender: self)
    }
}
