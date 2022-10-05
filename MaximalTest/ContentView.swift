//
//  ContentView.swift
//  MaximalTest
//
//  Created by Anton Kinstler on 04.10.2022.
//

import SwiftUI

struct ContentView: View {
    
    @State var selectedScene: Int = 0
    
    var body: some View {
        TabView(selection: $selectedScene) {
            SearchView(viewModel: SearchViewModel())
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }.tag(0)
            
            UserInfoView()
                .tabItem{
                    Label("User info", systemImage: "mustache")
                }.tag(1)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
