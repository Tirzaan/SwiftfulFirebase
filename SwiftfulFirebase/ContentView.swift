//
//  ContentView.swift
//  SwiftfulFirebase
//
//  Created by Tirzaan on 9/20/25.
//

import SwiftUI

struct ContentView: View {
    let url = URL(string: "https://firebasestorage.googleapis.com/v0/b/testproject-d8a9e.firebasestorage.app/o/ChatGPT%20Image%20Oct%2017%2C%202025%20at%2010_35_46%20PM.png?alt=media&token=e2f3785f-6f44-47ab-93b3-0bc689bc05e6")
    
    var body: some View {
        VStack {
            AsyncImage(url: url, scale: 4)

            Text("Hello, world!")
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
