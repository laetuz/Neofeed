//
//  PossList.swift
//  Neofeed
//
//  Created by Ryo Martin on 16/02/24.
//

import SwiftUI

struct PostsList: View {
    private var posts = [Post.testPost]
    @State private var searchText = ""
    
    var body: some View {
        NavigationView {
            List(posts) { post in
                if searchText.isEmpty || post.contains(searchText) {
                    PostRow(post: post)
                }
            }
            .searchable(text: $searchText)
            .navigationTitle("Posts")
        }
       
    }
}

#Preview {
    PostsList()
}
