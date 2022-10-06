//
//  UserInfoView.swift
//  MaximalTest
//
//  Created by Anton Kinstler on 04.10.2022.
//

import SwiftUI

struct UserInfoView: View {
    @ObservedObject var viewModel: UserInfoViewModel
    
    var body: some View {
        switch viewModel.status {
        case .unautorized:
            Button {
                viewModel.authenticate()
            } label: {
                Text("Sign in")
            }
        case .loadingData:
            ProgressView()
        case.userInfoBeenSet:
            if let user = viewModel.userInfo {
                VStack(alignment: .leading) {
                    AsyncImage(url: URL(string: user.avatar)) { image in
                        image
                            .resizable()
                            .aspectRatio(1, contentMode: .fit)
                    } placeholder: {
                        Color.gray
                            .aspectRatio(1, contentMode: .fit)
                    }
                    .cornerRadius(8)
                    .padding(.horizontal, 5)
                    
                    Text(user.name ?? "")
                        .font(.title)
                        .padding(5)
                    
                    Spacer()
                }
            }
        }
    }
}
