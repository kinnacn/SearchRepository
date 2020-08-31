//
//  ViewController.swift
//  SearchRepository
//
//  Created by seibin on 2020/08/28.
//  Copyright © 2020年 seibin. All rights reserved.
//

import UIKit

class RepositoryViewController: UIViewController {
    @IBOutlet weak var ImgView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var stargazersCountLabel: UILabel!
    @IBOutlet weak var wachersCountLabel: UILabel!
    @IBOutlet weak var forksCountLabel: UILabel!
    @IBOutlet weak var openIssuesCountLabel: UILabel!
    
    
    var repositorieInfoDic: [String: Any]?
    private let thumbnailDataprovider = ThumbnailDataprovider()
    private let indicatorView = IndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        thumbnailDataprovider.delegate = self
        getThumbnail()
        indicatorView.frame = view.frame
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getThumbnail() {
        showIndicator()
        DispatchQueue.global().async {
            if let repositorieInfo = self.repositorieInfoDic {
                if let owner = repositorieInfo[ Constans.RepositoriyKeyName.owner] as? [String: Any], let imgURL = owner[Constans.RepositoriyOwnerKeyName.avatarUrl] as? String  {
                    self.thumbnailDataprovider.getThumbnail(imgURL)
                }
            }
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
    
    func refresh(_ image: UIImage, _ repositorieInfoDic: [String: Any]?) {
        DispatchQueue.main.async {
            self.ImgView.image = image
            
            if let repositorieInfo = repositorieInfoDic {
                self.title = repositorieInfo[Constans.RepositoriyKeyName.fullName] as? String
                
                self.titleLabel.text = self.title
                self.languageLabel.text = "Written in \(repositorieInfo[Constans.RepositoriyKeyName.language] as? String ?? "")"
                self.stargazersCountLabel.text = "\(repositorieInfo[Constans.RepositoriyKeyName.stargazersCount] as? Int ?? 0) stars"
                self.wachersCountLabel.text = "\(repositorieInfo[Constans.RepositoriyKeyName.wachersCount] as? Int ?? 0) watchers"
                self.forksCountLabel.text = "\(repositorieInfo[Constans.RepositoriyKeyName.forksCount] as? Int ?? 0) forks"
                self.openIssuesCountLabel.text = "\(repositorieInfo[Constans.RepositoriyKeyName.openIssuesCount] as? Int ?? 0) open issues"
            }
        }
    }
}

extension RepositoryViewController: ThumbnailDataproviderDelegate {
    func successGetThumbnail(_ image: UIImage) {
        hiddenIndicator()
        refresh(image, repositorieInfoDic)
    }
    
    func failureGetThumbnail(_ error: Error?) {
        hiddenIndicator()
        DispatchQueue.main.async {
            self.ImgView.image = UIImage(named: Constans.Image.defaultImage)
        }
    }
}

