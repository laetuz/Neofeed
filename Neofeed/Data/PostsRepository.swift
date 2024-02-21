//
//  PostsRepository.swift
//  Neofeed
//
//  Created by Ryo Martin on 21/02/24.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct PostsRepository {
    var post = [Post]()
    private static let dbNew = Firestore.firestore()
    private var db = Firestore.firestore()
    static let postsReference = Firestore.firestore().collection("posts")
    
    static func create(_ post: Post) async throws {
        let document = postsReference.document(post.id.uuidString)
        try await document.setData(from: post)
    }
    
    static func fetchPosts() async throws -> [Post] {
            let querySnapshot = try await dbNew.collection("posts").getDocuments()
            
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
