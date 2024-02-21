//
//  PossList.swift
//  Neofeed
//
//  Created by Ryo Martin on 16/02/24.
//

import SwiftUI

struct PostsList: View {
   // private var posts = [Post.testPost]
    @StateObject var viewModel = PostsViewModel()
    @State private var searchText = ""
    @Environment(\.dismiss) private var dismiss
    @State private var showNewForm = false
    
    var body: some View {
        NavigationView {
            Group {
                switch viewModel.posts {
                case .loading: 
                    ProgressView()
                case .error(_): Text("Cant see")
                case .empty: Text("No posts")
                case let .loaded(posts):
                    List(posts) { post in
                        if searchText.isEmpty || post.contains(searchText) {
                            PostRow(post: post)
                        }
                    }
                    .searchable(text: $searchText)
                }
            }
            .navigationTitle("Posts")
            .toolbar {
                Button {
                    showNewForm = true
                } label: {
                    Label("New Post", systemImage: "square.and.pencil")
                }
            }
            .sheet(isPresented: $showNewForm, content: {
                NewPostForm(createAction: viewModel.makeCreateAction())
            })
        }
        .onAppear {
           // viewModel.fetchPosts()
            viewModel.fetchPosts()
        }
        
    }
}

#Preview {
    PostsList()
}
