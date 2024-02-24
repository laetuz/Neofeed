//
//  PostRowViewModel.swift
//  Neofeed
//
//  Created by Ryo Martin on 24/02/24.
//

import Foundation

@MainActor
@dynamicMemberLookup
class PostRowViewModel: ObservableObject {
    subscript<T>(dynamicMember keyPath: KeyPath<Post, T>) -> T {
        post[keyPath: keyPath]
    }
    typealias Action = () async throws -> Void
  
    
    @Published var post: Post
    @Published var error: Error?
    
    private let deleteAction: Action
    private let favoriteAction: Action
    
    init(post: Post, error: Error? = nil, deleteAction: @escaping Action, favoriteAction: @escaping Action) {
        self.post = post
        self.error = error
        self.deleteAction = deleteAction
        self.favoriteAction = favoriteAction
    }
    
    private func withErrorHandlingTask(perform action: @escaping Action) {
        Task {
            do {
                try await action()
            } catch {
                print("[PostRow] Error: \(error)")
                self.error = error
            }
        }
    }
    
    func deletePost() {
        withErrorHandlingTask(perform: deleteAction)
    }
    
    func favPost() {
        withErrorHandlingTask(perform: favoriteAction)
    }
}
