//
//  PostsRepository.swift
//  Neofeed
//
//  Created by Ryo Martin on 21/02/24.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

protocol PostsRepositoryProtocol {
    func create(_ post: Post) async throws
    func fetchPosts() async throws -> [Post]
    func fetchAllPosts() async throws -> [Post]
    func delete(_ post: Post) async throws
    func favorite(_ post: Post) async throws
    func unfavorite(_ post: Post) async throws
    func fetchFavPosts() async throws -> [Post]
}

#if DEBUG
struct PostsRepositoryStub: PostsRepositoryProtocol {
    let state: Loadable<[Post]>
    
    func fetchAllPosts() async throws -> [Post] {
        return try await state.simulate()
    }
    
    
    func fetchFavPosts() async throws -> [Post] {
        return try await state.simulate()
    }
    
    func favorite(_ post: Post) async throws {}
    
    func unfavorite(_ post: Post) async throws {}
    
    func delete(_ post: Post) async throws {}
    
    func fetchPosts() async throws -> [Post] {
        return []
    }
    
    func create(_ post: Post) async throws {}
}
#endif

struct PostsRepository: PostsRepositoryProtocol {
    
    func fetchAllPosts() async throws -> [Post] {
        return try await fetchPost(from: postsReference)
    }

    
    func fetchFavPosts() async throws -> [Post] {
        return try await fetchPost(from: postsReference.whereField("isFavorite", isEqualTo: true))
    }
    
    private func fetchPost(from query: Query) async throws -> [Post] {
        let snapshot = try await query
            .order(by: "timeStamp", descending: true)
            .getDocuments()
        return snapshot.documents.compactMap { document in
            try! document.data(as: Post.self)
        }
    }
    
    var post = [Post]()
    private let dbNew = Firestore.firestore()
    private var db = Firestore.firestore()
    let postsReference = Firestore.firestore().collection("posts_v1")
    
    func create(_ post: Post) async throws {
        let document = postsReference.document(post.id.uuidString)
        try await document.setData(from: post)
    }
    
    func delete(_ post: Post) async throws {
        let document = postsReference.document(post.id.uuidString)
        try await document.delete()
    }
    
    func fetchPosts() async throws -> [Post] {
            let querySnapshot = try await dbNew.collection("posts_v1")
            .order(by: "timeStamp", descending: true)
            .getDocuments()
            let posts = querySnapshot.documents.compactMap { document -> Post? in
                do {
                    return try document.data(as: Post.self)
                } catch {
                    print("Error decoding Post: \(error)")
                    return nil
                }
            }
            
            return posts
        }
    
    func fetchPostsAlternate(completion: @escaping ([Post]) -> Void) {
            db.collection("posts").addSnapshotListener { (querySnapshot, error) in
                guard let documents = querySnapshot?.documents else {
                    print("No documents")
                    completion([])
                    return
                }

                let posts = documents.map { (queryDocumentSnapshot) -> Post in
                    let data = queryDocumentSnapshot.data()
                    let authorName = data["authorName"] as? String ?? ""
                    let content = data["content"] as? String ?? ""
                    let id = data["id"]
                    let timeStamp = data["timeStamp"]
                    let title = data["title"] as? String ?? ""
                    let post = Post(title: title, content: content, authorName: authorName)
                    return post
                }

                completion(posts)
            }
        }
    
    func favorite(_ post: Post) async throws {
        let document = postsReference.document(post.id.uuidString)
       // var post = post
        //post.isFavorite = true
       // try await document.setData(from: post)
        try await document.setData(["isFavorite": true], merge: true)
    }
    
    func unfavorite(_ post: Post) async throws {
        let document = postsReference.document(post.id.uuidString)
        try await document.setData(["isFavorite": false], merge: true)
    }
    
//    func fetchData() {
//        db.collection("posts").addSnapshotListener { (querySnapshot, error) in
//            guard let documents = querySnapshot?.documents else {
//                print("No documents")
//                return
//            }
//            
//            self.post = documents.map { (queryDocumentSnapshot) -> Post in
//                let data = queryDocumentSnapshot.data()
//                let authorName = data["authorName"] as? String ?? ""
//                let content = data["content"] as? String ?? ""
//                let id = data["id"]
//                let timeStamp = data["timeStamp"]
//                let title = data["title"] as? String ?? ""
//                let post = Post(title: title, content: content, authorName: authorName)
//                return post
//            }
//        }
//    }
}


private extension DocumentReference {
    func setData<T: Encodable>(from value: T) async throws {
        return try await withCheckedThrowingContinuation { continuation in
            try! setData(from: value) { error in
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }
                continuation.resume()
            }
        }
    }
}
