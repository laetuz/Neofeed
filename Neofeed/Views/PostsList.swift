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
                case let .error(error):
                    EmptyListView(
                        title: "Cannot Load Posts",
                        message: error.localizedDescription,
                        retryAction: {viewModel.fetchPosts()}
                    )
                    .font(.subheadline)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.secondary)
                    .padding()
                case .empty: 
                        EmptyListView(
                            title: "No Posts",
                            message: "There aren’t any posts yet."
                        )
                case let .loaded(posts):
                    List(posts) { post in
                        if searchText.isEmpty || post.contains(searchText) {
                            PostRow(post: post, deleteAction: viewModel.makeDeleteCreate(for: post))
                        }
                    }
                    .searchable(text: $searchText)
                    .animation(.default, value: posts)
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
