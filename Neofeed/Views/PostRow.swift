//
//  PostRow.swift
//  Neofeed
//
//  Created by Ryo Martin on 16/02/24.
//

import SwiftUI

struct PostRow: View {
    typealias DeleteAction = () async throws -> Void
       
    @State private var showConfirmationDialog = false
    @State private var error: Error?
    
    let post: Post
    let deleteAction: DeleteAction
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(post.authorName)
                    .font(.subheadline)
                    .fontWeight(.medium)
                Spacer()
                Text(post.timeStamp.formatted())
                    .font(.caption)
            }.foregroundColor(.gray)
            Text(post.title)
                .font(.title3)
                .fontWeight(.semibold)
            Text(post.content)
            HStack {
                Spacer()
                Button(role: .destructive, action: {showConfirmationDialog = true}) {
                    Label("Delete", systemImage: "trash")
                }
                .labelStyle(.iconOnly)
                .buttonStyle(.borderless)
                .confirmationDialog("Are you sure?", isPresented: $showConfirmationDialog, titleVisibility: .visible) {
                    Button("Delete", role: .destructive, action: deletePost)
                }
            }
        }
        .padding(.vertical)
        .alert("Cannot delete post", error: $error)
    }
    
    private func deletePost() {
        Task {
            do {try await deleteAction()}
            catch {
                print("[PostRow] Cannot delete post: \(error)")
                self.error = error
            }
        }
    }
}

#Preview {
    PostRow(post: Post.testPost, deleteAction: {})
}
