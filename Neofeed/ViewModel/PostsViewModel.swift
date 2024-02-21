//
//  PostsViewModel.swift
//  Neofeed
//
//  Created by Ryo Martin on 21/02/24.
//

import Foundation

@MainActor
class PostsViewModel: ObservableObject {
    @Published var posts = [Post.testPost]
    
    func makeCreateAction() -> NewPostForm.CreateAction {
        return { [weak self] post in
            try await PostsRepository.create(post)
            self?.posts.insert(post, at: 0)
        }
    }
    
    //posts.insert(post, at: 0)
}
