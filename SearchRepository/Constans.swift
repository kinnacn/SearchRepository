//
//  Constans.swift
//  SearchRepository
//
//  Created by seibin on 2020/08/28.
//  Copyright © 2020年 seibin. All rights reserved.
//

import Foundation


struct Constans {
    struct AccessibilityIdentifier {
        static let keywordSearchBar = "keywordSearchBar"
        static let repositoriesTableview = "repositoriesTableview"
    }
    
    struct Image {
        static let defaultImage = "default"
    }
    struct Identifier {
        static let repository = "Repository"
    }
    
    struct ApiUrl {
        static let baseSearchRepositories = "https://api.github.com/search/repositories?q="
    }
    
    struct RepositoriyKeyName {
        static let items = "items"
        static let language = "language"
        static let stargazersCount = "stargazers_count"
        static let wachersCount = "wachers_count"
        static let forksCount = "forks_count"
        static let openIssuesCount = "open_issues_count"
        static let fullName = "full_name"
        static let owner = "owner"
        
        
    }
    
    struct RepositoriyOwnerKeyName {
        static let avatarUrl = "avatar_url"
    }
}
