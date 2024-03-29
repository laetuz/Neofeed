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
    enum Filter {
        case all, favorites
    }
    
    private let filter: Filter
    @Published var postsOld = [Post]()
    @Published var posts: Loadable<[Post]> = .loading
    private var db = Firestore.firestore()
    
    private let postsRepository: PostsRepositoryProtocol
    
    init(filter: Filter = .all, postsRepository: PostsRepositoryProtocol = PostsRepository()) {
        self.filter = filter
        self.postsRepository = postsRepository
    }
    
    var title: String {
        switch filter {
        case .all:
            return "Posts"
        case .favorites:
            return "Favorites"
        }
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
                posts = .loaded(try await postsRepository.fetchPost(matching: filter))
            } catch {
                print("[PostViewModel] cannot fetch posts: \(error)")
            }
        }
    }
    
    func fetchTest() {
        Task {
            do {
                posts = .loaded(try await postsRepository.fetchFavPosts())
            } catch {
                print("[PostViewModel] cannot fetch posts: \(error)")
            }
        }
    }
    
    func makeDeleteCreate(for post: Post) -> PostRow.Action {
        return { [weak self] in
            try await self?.postsRepository.delete(post)
            self?.posts.value?.removeAll() { $0.id == post.id}
        }
    }
    
    func makeFavoriteAction(for post: Post) -> () async throws -> Void {
        return { [weak self] in
            let newValue = !post.isFavorite
            try await newValue ? self?.postsRepository.favorite(post) : self?.postsRepository.unfavorite(post)
            guard let i = self?.posts.value?.firstIndex(of: post) else { return }
            self?.posts.value?[i].isFavorite = newValue
        }
    }
    
    func makePostRowViewModel(for post: Post) -> PostRowViewModel {
        return PostRowViewModel(
            post: post,
            deleteAction: { [weak self] in
                try await self?.postsRepository.delete(post)
                self?.posts.value?.removeAll { $0 == post }
            },
            favoriteAction: { [weak self] in
                let newValue = !post.isFavorite
                try await newValue ? self?.postsRepository.favorite(post) : self?.postsRepository.unfavorite(post)
                guard let i = self?.posts.value?.firstIndex(of: post) else { return }
                self?.posts.value?[i].isFavorite = newValue
            }
        )
    }
    
//    func makeUnFavoriteAction(for post: Post) -> () async throws -> Void {
//        return { [weak self] in
//            let newValue = !post.isFavorite
//            try await newValue ? self?.postsRepository.unfavorite(post) : self?.postsRepository.unfavorite(post)
//            guard let i = self?.posts.value?.firstIndex(of: post) else { return }
//            self?.posts.value?[i].isFavorite = newValue
//        }
//    }
    
//    func fetchData() {
//          postRepository.fetchPostsAlternate { [weak self] posts in
//              self?.postsOld = posts
//            //  completion()
//          }
//      }
    
    //posts.insert(post, at: 0)
}

private extension PostsRepositoryProtocol {
    func fetchPost(matching filter: PostsViewModel.Filter) async throws -> [Post] {
        switch filter {
        case .all: return try await fetchAllPosts()
        case .favorites: return try await fetchFavPosts()
        }
    }
}
