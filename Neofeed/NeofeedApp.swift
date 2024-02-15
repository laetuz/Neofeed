//
//  NeofeedApp.swift
//  Neofeed
//
//  Created by Ryo Martin on 15/02/24.
//

import SwiftUI
import Firebase

@main
struct NeofeedApp: App {
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            PostsList()
        }
    }
}
