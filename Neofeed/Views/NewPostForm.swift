//
//  NewPostForm.swift
//  Neofeed
//
//  Created by Ryo Martin on 18/02/24.
//

import SwiftUI

struct NewPostForm: View {
    @State private var post = Post(title: "", content: "", authorName: "")
    typealias CreateAction = (Post) async throws -> Void
    let createAction: CreateAction
    @Environment(\.dismiss) private var dismiss
    @State private var state = FormState.idle
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Title", text: $post.title)
                    TextField("Author Name", text: $post.authorName)
                }
                Section ("Content") {
                    TextEditor(text: $post.content)
                        .multilineTextAlignment(.leading)
                }
                Button(action: createPost) {
                    if state == .working {
                        ProgressView()
                    } else {
                        Text("Create Post")
                    }
                }
                .font(.headline)
                .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                .foregroundColor(.white)
                .padding()
                .listRowBackground(Color.accentColor)
            }
            .navigationTitle("New Post")
            .onSubmit(createPost)
        }
        .disabled(state == .working)
        .alert("Cannot create post.", isPresented: $state.isError, actions: {}) {
            Text("Sorry, something went wrong.")
        }
    }
    
    private func createPost() {
        Task {
            state = .working
            do {
                try await createAction(post)
                print("[NewPostForm] Creating new post...")
                dismiss()
            } catch {
                print("[NewPostForm] Cant create a new post \(error)")
                state = .error
            }
        }
      
    }
}

//#Preview {
//    let samplePost = Post(title: "The Alchemist", content: "This is a story about a young boy trying ti find his inner voice.", authorName: "Paulo Coelho")
//    NewPostForm(createAction: { _ in })
//}

struct NewPostForm_Previews: PreviewProvider {
    static var previews: some View {
        NewPostForm(createAction: { _ in })
    }
}
