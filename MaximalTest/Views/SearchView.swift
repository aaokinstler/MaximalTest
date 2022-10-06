//
//  SearchView.swift
//  MaximalTest
//
//  Created by Anton Kinstler on 04.10.2022.
//

import SwiftUI

struct SearchView: View {
    
    @ObservedObject var viewModel: SearchViewModel
    @FocusState private var searchIsFocused: Bool
    
    var body: some View {
        NavigationView {
            VStack {
                ScrollView {
                    if viewModel.fetching  {
                        ProgressView()
                    }  else {
                        usersList
                    }
                }
                searchBar
            }
        }
    }
    
    var usersList: some View {
        LazyVStack {
            ForEach(viewModel.searchResult) { user in
                NavigationLink(destination: UserReposView(user: user)) {
                    UserResult(user: user)
                        .onAppear {
                            viewModel.getFollowersCount(user.id)
                        }
                }.buttonStyle(.plain)
            }
        }
    }
    
    var searchBar: some View {
        HStack {
            TextField("Enter user name", text: $viewModel.searchString)
                .focused($searchIsFocused)
                .textFieldStyle(.roundedBorder)
                .onSubmit {
                    searchIsFocused = false
                    viewModel.sendRequest()
                }
            Button {
                searchIsFocused = false
                viewModel.sendRequest()
            } label: {
                Text("Search")
            }
            .buttonStyle(.bordered)
            .disabled(viewModel.fetching)
        }.padding()
    }
}

struct UserResult: View {
    let user: User
    var body: some View {
        HStack {
            AsyncImage(url: URL(string: user.avatar)) { image in
                image
                    .resizable()
                    .aspectRatio(1, contentMode: .fit)
            } placeholder: {
                Color.gray
                    .aspectRatio(1, contentMode: .fit)
            }
            .frame(height: 50)
            .cornerRadius(8)
            .padding(.horizontal, 5)
            .disableAutocorrection(/*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
            
            VStack(alignment: .leading) {
                Text(user.login)
                    .font(.title2)
                HStack {
                    Text("Followers: ")
                    if let count = user.followersCount {
                        Text(String(count))
                            .padding(0)
                    }
                }
            }
            Spacer()
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView(viewModel: SearchViewModel())
    }
}
