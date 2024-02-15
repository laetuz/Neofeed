//
//  PostRow.swift
//  Neofeed
//
//  Created by Ryo Martin on 16/02/24.
//

import SwiftUI

struct PostRow: View {
    let post: Post
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
        }
        .padding(.vertical)
    }
}

#Preview {
    PostRow(post: Post.testPost)
}
