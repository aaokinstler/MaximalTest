//
//  UserReposView.swift
//  MaximalTest
//
//  Created by Anton Kinstler on 05.10.2022.
//

import SwiftUI

struct UserReposView: View {
    let user: User
    @StateObject var viewModel: UserReposViewModel = UserReposViewModel()
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 2) {
                ForEach(viewModel.repos) { repository in
                    RepositoryView(repository: repository)
                }
            }
        }
        .onAppear {
            viewModel.fetchReposInformation(user.login)
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                HStack {
                    AsyncImage(url: URL(string: user.avatar)) { image in
                        image
                            .resizable()
                            .aspectRatio(1, contentMode: .fit)
                    } placeholder: {
                        Color.gray
                            .aspectRatio(1, contentMode: .fit)
                    }
                    .frame(height: 30)
                    .cornerRadius(8)
                    .padding(.horizontal, 5)
                    
                    Text(user.login)
                }
            }
        }
    }
}

struct RepositoryView: View {
    
    let repository: Repository
    
    var body: some View {
        let lightGray = Color(red: 150/255, green: 150/255, blue: 150/255)
        
        VStack(alignment: .leading) {
            Text(repository.name)
                .font(.title2)
                .foregroundColor(Color(red: 47/255, green: 103/255, blue: 211/255))
                .padding(.bottom, 1)
            
            Text(repository.description ?? "")
                .font(.body)
                .lineLimit(/*@START_MENU_TOKEN@*/2/*@END_MENU_TOKEN@*/)
                .foregroundColor(lightGray)

            
            HStack{
                Text("Branch: \(repository.defaultBranch)")
                Spacer()
                Text("Updated at: \(repository.formattedDate)")
            }
            .font(.callout)
            .foregroundColor(lightGray)
            .padding(.bottom, 1)
 
            
            HStack {
                Label(String(repository.stars), systemImage: "star")
                Spacer()
                Label(String(repository.forks), systemImage: "tuningfork")
                Spacer()
                if let language = repository.language {
                    Label(language, systemImage: "circle.fill")
                }
            }
            .foregroundColor(lightGray)
            .font(.callout)
        }
        .padding()
    }
}

struct UserReposView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            RepositoryView(repository: Repository(id: 22458259, name: "Alamofire", description: "Elegant HTTP Networking in Swift", language: "Swift", defaultBranch: "master", stars: 38389, forks: 7256, lastCommitDate: Date() ))
        }

    }
}
