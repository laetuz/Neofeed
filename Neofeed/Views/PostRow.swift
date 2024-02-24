//
//  PostRow.swift
//  Neofeed
//
//  Created by Ryo Martin on 16/02/24.
//

import SwiftUI

struct PostRow: View {
    typealias Action = () async throws -> Void
    
    @ObservedObject var viewModel: PostRowViewModel
       
    @State private var showConfirmationDialog = false
    @State private var error: Error?
    
    let post: Post
    let deleteAction: Action
    let favoriteAction: Action
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(viewModel.authorName)
                    .font(.subheadline)
                    .fontWeight(.medium)
                Spacer()
                Text(viewModel.timeStamp.formatted(date: .abbreviated, time: .omitted))
                    .font(.caption)
            }.foregroundColor(.gray)
            Text(viewModel.title)
                .font(.title3)
                .fontWeight(.semibold)
            Text(viewModel.content)
            HStack {
                FavoriteButton(isFavorite: viewModel.isFavorite, action:{ viewModel.favPost()})
                    .labelStyle(.iconOnly)
                    .buttonStyle(.borderless)
                Spacer()
                Button(role: .destructive, action: {showConfirmationDialog = true}) {
                    Label("Delete", systemImage: "trash")
                }
                .labelStyle(.iconOnly)
                .buttonStyle(.borderless)
                .confirmationDialog("Are you sure?", isPresented: $showConfirmationDialog, titleVisibility: .visible) {
                    Button("Delete", role: .destructive, action:{ viewModel.deletePost()})
                }
            }
        }
        .padding(.vertical)
        .alert("Error", error: $viewModel.error)
    }
    
    
}

private extension PostRow {
    struct FavoriteButton: View {
        let isFavorite: Bool
        let action: () -> Void
        
        var body: some View {
            Button(action: action) {
                if isFavorite {
                    Label("Remove from fav", systemImage: "heart.fill")
                } else {
                    Label("Add to fav", systemImage: "heart")
                }
            }
        }
    }
}

struct PostRow_Previews: PreviewProvider {
    static var previews: some View {
        List {
            PostRow(viewModel: PostRowViewModel(post: Post.testPost, deleteAction: {}, favoriteAction: {}), post: Post.testPost, deleteAction: {}, favoriteAction: {})
        }
    }
}
