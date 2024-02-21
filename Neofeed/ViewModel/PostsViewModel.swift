//
//  PostsViewModel.swift
//  Neofeed
//
//  Created by Ryo Martin on 21/02/24.
//

import Foundation
import FirebaseFirestore

@MainActor
class PostsViewModel: ObservableObject {
    @Published var postsOld = [Post]()
    @Published var posts: Loadable<[Post]> = .loading
    private var db = Firestore.firestore()
    
    private let postsRepository: PostsRepositoryProtocol
    
    init(postsRepository: PostsRepositoryProtocol = PostsRepository()) {
        self.postsRepository = postsRepository
    }
    
    func makeCreateAction() -> NewPostForm.CreateAction {
        return { [weak self] post in
            try await self?.postsRepository.create(post)
            self?.posts.value?.insert(post, at: 0)
        }
    }
    
    func fetchPosts() {
        Task {
            do {
                posts = .loaded(try await postsRepository.fetchPosts())
            } catch {
                print("[PostViewModel] cannot fetch posts: \(error)")
            }
        }
    }
    
//    func fetchData() {
//          postRepository.fetchPostsAlternate { [weak self] posts in
//              self?.postsOld = posts
//            //  completion()
//          }
//      }
    
    //posts.insert(post, at: 0)
}
