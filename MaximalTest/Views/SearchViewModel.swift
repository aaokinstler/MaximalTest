//
//  SearchViewDataMidel.swift
//  MaximalTest
//
//  Created by Anton Kinstler on 04.10.2022.
//

import Foundation
import Combine

class SearchViewModel: ObservableObject {
    @Published var searchString: String = ""
    @Published var searchResult: [User] = []
    @Published var fetching: Bool = false
    
    private var disposables = Set<AnyCancellable>()
    
    public func sendRequest() {
        let components = ServerDataManager.components(path: "/search/users", paremeters: [URLQueryItem(name: "q", value: searchString)])
        fetching = true
        ServerDataManager.fetchSearchData(components)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] value in
                guard let self = self else { return }
                  switch value {
                  case .failure:
                      self.fetching = false
                  case .finished:
                      self.fetching = false
                    break
                  }
            }, receiveValue: { [weak self] result in
                guard let self = self else { return }
                self.searchResult = result.items
            })
            .store(in: &disposables)
    }
    
    public func getFollowersCount(_ id: Int) {
        guard let index = self.searchResult.firstIndex(where: {$0.id == id}) else { return }
        let user = self.searchResult[index]
        if let _ = user.followersCount { return }
        
        let components = ServerDataManager.components(path: "/users/\(user.login)/followers", paremeters: [])
        print(components)
        ServerDataManager.fetchFollowersCount(components)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] value in
                guard let self = self else { return }
                  switch value {
                  case .failure:
                      self.fetching = false
                  case .finished:
                      self.fetching = false
                    break
                  }
            }, receiveValue: { [weak self] result in
                guard let self = self else { return }
                self.searchResult[index].setFollowersCount(result.count)
            })
            .store(in: &disposables)
    }
}
