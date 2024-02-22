//
//  ErrorAlertModifier.swift
//  Neofeed
//
//  Created by Ryo Martin on 23/02/24.
//

import SwiftUI

private struct ErrorAlertModifier: ViewModifier {
    let title: String
    @Binding var error: Error?
    
    func body(content: Content) -> some View {
        content
            .alert(title, isPresented: $error.hasValue, presenting: error, actions: { _ in }) { error in
                Text(error.localizedDescription)
            }
    }
}

private extension Optional {
    var hasValue: Bool {
        get { self != nil }
        set { self = newValue ? self : nil }
    }
}

extension View {
    func alert(_ title: String, error: Binding<Error?>) -> some View {
        modifier(ErrorAlertModifier(title: title, error: error))
    }
}

//#Preview {
//    ErrorAlertModifier(title: "fd", error: Error.Type)
//}
