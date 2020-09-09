//
//  RepositoriyDataprovider.swift
//  SearchRepository
//
//  Created by seibin on 2020/08/28.
//  Copyright © 2020年 seibin. All rights reserved.
//

import UIKit

protocol  RepositoriyDataProviderDelegate: class {
    func successGetRepositoriyInfos(_ infos: [[String: Any]])
    func failureGetRepositoriyInfos(_ error: Error?)
}

class RepositoriyDataProvider: NSObject {
    weak var delegate: RepositoriyDataProviderDelegate?
    private var sessionTask: URLSessionTask?
    
    func cancelTask() {
        sessionTask?.cancel()
    }
    
    func getRepositoryInfos(_ keyWord: String) {
        guard let url = URL(string: "\(Constans.ApiUrl.baseSearchRepositories)\(keyWord)") else {
            delegate?.failureGetRepositoriyInfos(SearchRepositoryError.initError)
            return
        }
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        let request = URLRequest(url: url)
        
        sessionTask = session.dataTask(with: request) { (data, response, error) in
            session.invalidateAndCancel()
            
            if let _ = error {
                self.delegate?.failureGetRepositoriyInfos(SearchRepositoryError.networkError)
                return
            }
            
            guard let data = data, let response = response as? HTTPURLResponse else {
                self.delegate?.failureGetRepositoriyInfos(SearchRepositoryError.networkError)
                return
            }
            
            if response.statusCode == 200 {
                guard  let responseJSON = try? JSONSerialization.jsonObject(with: data, options: []), let responseDic = responseJSON as? [String: Any] else {
                    self.delegate?.failureGetRepositoriyInfos(SearchRepositoryError.networkError)
                    return
                }
                
                guard let items = responseDic[Constans.RepositoriyKeyName.items] as? [[String: Any]] else {
                    self.delegate?.successGetRepositoriyInfos([])
                    return
                }
                
                self.delegate?.successGetRepositoriyInfos(items)
                
            } else {
                self.delegate?.failureGetRepositoriyInfos(SearchRepositoryError.networkError)
            }
        }
        
        sessionTask?.resume()
    }
}
