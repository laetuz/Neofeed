//
//  Post.swift
//  Neofeed
//
//  Created by Ryo Martin on 16/02/24.
//

import Foundation

struct Post: Identifiable, Equatable, Codable {
    var title: String
    var content: String
    var authorName: String
    var isFavorite = false
    var timeStamp = Date()
    var id = UUID()
    
    func contains(_ string: String) -> Bool {
        let properties = [title, content, authorName].map { $0.lowercased() }
        let query = string.lowercased()
        let matches = properties.filter { $0.contains(query) }
        return !matches.isEmpty
    }
}

extension Post {
    static let testPost = Post(title: "Steve Jobs", content: "biography", authorName: "Walter Isaacson", timeStamp: Date())
}

