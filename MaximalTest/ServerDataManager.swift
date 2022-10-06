//
//  ServerDataManager.swift
//  MaximalTest
//
//  Created by Anton Kinstler on 04.10.2022.
//

import Foundation
import Alamofire
import Combine

class ServerDataManager {
    static let shared = ServerDataManager()
    
    private var token: String?
    
    public static func apiComponents(path: String, parameters: [URLQueryItem]? = nil) -> URLComponents {
        var components = URLComponents()
        components.scheme = ServerAPI.scheme
        components.host = ServerAPI.apiHost
        components.path = path
        if let parameters = parameters {
            components.queryItems = parameters
        }
        
        return components
    }
    
    public static func components(path: String, parameters: [URLQueryItem]? = nil) -> URLComponents {
        var components = URLComponents()
        components.scheme = ServerAPI.scheme
        components.host = ServerAPI.host
        components.path = path
        if let parameters = parameters {
            components.queryItems = parameters
        }
        
        return components
    }
    
    func fetchServerData<dataType: Decodable>(_ query: URLComponents) -> AnyPublisher<dataType, AFError> {
        var headers: HTTPHeaders = [
            .accept("application/json")
        ]
        
        if let token = token {
            headers.add(.authorization(token))
        }

        return Session.default
            .request(query, headers: headers)
            .publishDecodable(type: dataType.self)
            .value()
            .eraseToAnyPublisher()
    }
    
    func fetchPostServerData<requestType: Encodable, dataType: Decodable>(_ query: URLComponents, request: requestType) -> AnyPublisher<dataType, AFError> {
        var headers: HTTPHeaders = [
            .accept("application/json")
        ]
        
        if let token = token {
            headers.add(.authorization(token))
        }
        
        return Session.default
            .request(query, method: .post, parameters: request, headers: headers)
            .publishDecodable(type: dataType.self)
            .value()
            .eraseToAnyPublisher()
    }
    
    func fetchSearchData(_ components: URLComponents) -> AnyPublisher<SearchResult, AFError> {
        return fetchServerData(components)
    }
    
    func fetchFollowersCount(_ components: URLComponents) -> AnyPublisher<[User], AFError> {
        return fetchServerData(components)
    }
    
    func fetchUserInfo() -> AnyPublisher<User, AFError> {
        let components = ServerDataManager.apiComponents(path: "/user")
        return fetchServerData(components)
    }
    
    func fetchReposInformation(_ components: URLComponents) -> AnyPublisher<[Repository], AFError> {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        return Session.default.request(components)
            .publishDecodable(type: [Repository].self, decoder: decoder)
            .value()
            .eraseToAnyPublisher()
    }
    
    func getAuthorizationToken(_ request: AuthRequest) -> AnyPublisher<AuthResponce, AFError> {
        let components = ServerDataManager.components(path: "/login/oauth/access_token")
        return fetchPostServerData(components, request: request)
    }
    
    func setToken(_ token: String) {
        self.token = "Bearer \(token)"
    }
}

struct ServerAPI {
    static let scheme = "https"
    static let apiHost = "api.github.com"
    static let host = "github.com"
    
}

