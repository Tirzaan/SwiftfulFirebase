//
//  onFirstAppearViewModifier.swift
//  SwiftfulFirebase
//
//  Created by Tirzaan on 10/17/25.
//

import Foundation
import SwiftUI

struct OnFirstAppearViewModifier: ViewModifier {
    @State private var didAppear: Bool = false
    let perform: (() -> ())?

    func body(content: Content) -> some View {
        content
            .onAppear {
                if !didAppear {
                    perform?()
                    didAppear = true
                }
            }
    }
}

extension View {
    func onFirstAppear(perform: (() -> ())?) -> some View {
        modifier(OnFirstAppearViewModifier(perform: perform))
    }
}
