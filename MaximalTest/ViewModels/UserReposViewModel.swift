//
//  UserReposViewModel.swift
//  MaximalTest
//
//  Created by Anton Kinstler on 05.10.2022.
//

import Foundation
import Combine

class UserReposViewModel: ObservableObject {
   
    @Published var repos: [Repository] = []
    @Published var fetching: Bool = false
    private var disposables = Set<AnyCancellable>()
        
    public func fetchReposInformation(_ login: String) {
        fetching = true
        
        let components = ServerDataManager.apiComponents(path: "/users/\(login)/repos")
        
        ServerDataManager.shared.fetchReposInformation(components)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] value in
                guard let self = self else { return }
                  switch value {
                  case .failure:
                      debugPrint(value)
                      self.fetching = false
                  case .finished:
                      self.fetching = false
                    break
                  }
            }, receiveValue: { [weak self] result in
                guard let self = self else { return }
                self.repos = result
            })
            .store(in: &disposables)
            
    }
}
