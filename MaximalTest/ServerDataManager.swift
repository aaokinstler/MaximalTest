//
//  ServerDataManager.swift
//  MaximalTest
//
//  Created by Anton Kinstler on 04.10.2022.
//

import Foundation
import Alamofire
import Combine

struct ServerDataManager {
    public static func fetchServerData<dataType: Decodable>(_ query: URLComponents, type: dataType) -> AnyPublisher<dataType, AFError> {
        return Session.default
            .request(query)
            .publishDecodable(type: dataType.self)
            .value()
            .eraseToAnyPublisher()
    }
    
    public static func fetchServerData<dataType: Decodable>(_ query: URLComponents) -> AnyPublisher<dataType, AFError> {
        return Session.default
            .request(query)
            .publishDecodable(type: dataType.self)
            .value()
            .eraseToAnyPublisher()
    }
    
    public static func fetchPostServerData<requestType: Encodable, responceType: Decodable>(_ query: URLComponents, request: requestType) -> AnyPublisher<responceType, AFError> {
        return Session.default
            .request(query, method: .post, parameters: request)
            .publishDecodable(type: responceType.self)
            .value()
            .eraseToAnyPublisher()
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
    
    public static func fetchSearchData(_ components: URLComponents) -> AnyPublisher<SearchResult, AFError> {
        return fetchServerData(components)
    }
    
    public static func fetchFollowersCount(_ components: URLComponents) -> AnyPublisher<[User], AFError> {
        return fetchServerData(components)
    }
    
    public static func fetchReposInformation(_ components: URLComponents) -> AnyPublisher<[Repository], AFError> {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        return Session.default.request(components)
            .publishDecodable(type: [Repository].self, decoder: decoder)
            .value()
            .eraseToAnyPublisher()
    }
}

struct ServerAPI {
    static let scheme = "https"
    static let host = "api.github.com"
}
