//
//  RepositoriyDataprovider.swift
//  SearchRepository
//
//  Created by seibin on 2020/08/28.
//  Copyright © 2020年 seibin. All rights reserved.
//

import UIKit

protocol  ThumbnailDataproviderDelegate: class {
    func successGetThumbnail(_ image: UIImage)
    func failureGetThumbnail(_ error: Error?)
}

class ThumbnailDataprovider: NSObject {
    weak var delegate: ThumbnailDataproviderDelegate?
    private var sessionTask: URLSessionTask?
    
    func cancelTask() {
        sessionTask?.cancel()
    }
    
    func getThumbnail(_ url: String) {
        guard let url = URL(string: url) else {
            delegate?.failureGetThumbnail(SearchRepositoryError.initError)
            return
        }
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        
        sessionTask = session.dataTask(with: url) { (data, response, error) in
            session.invalidateAndCancel()
            
            if let _ = error {
                self.delegate?.failureGetThumbnail(SearchRepositoryError.networkError)
                return
            }
            
            guard let data = data, let response = response as? HTTPURLResponse else {
                self.delegate?.failureGetThumbnail(SearchRepositoryError.networkError)
                return
            }
            
            if response.statusCode == 200, let image = UIImage(data: data) {
                self.delegate?.successGetThumbnail(image)
            } else {
                self.delegate?.failureGetThumbnail(SearchRepositoryError.networkError)
            }
        }
        // これ呼ばなきゃリストが更新されません
        sessionTask?.resume()
    }
}

