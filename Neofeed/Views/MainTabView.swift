//
//  MainTabView.swift
//  Neofeed
//
//  Created by Ryo Martin on 26/02/24.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            PostsList()
                .tabItem { Label("Posts", systemImage: "list.dash") }
            PostsList(viewModel: PostsViewModel(filter: .favorites))
                .tabItem { Label("Favorites", systemImage: "star.fill") }
        }
    }
}

#Preview {
    MainTabView()
}
