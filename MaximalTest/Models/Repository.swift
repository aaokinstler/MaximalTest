//
//  Repository.swift
//  MaximalTest
//
//  Created by Anton Kinstler on 05.10.2022.
//

import Foundation

struct Repository: Decodable, Identifiable {
    let id: Int
    let name: String
    let description: String?
    let language: String?
    let defaultBranch: String
    let stars: Int
    let forks: Int
    let lastCommitDate: Date
    
    private static var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.locale = Locale(identifier: "ru_RU")
        return formatter
    }()
    
    var formattedDate: String {
        return Self.dateFormatter.string(from: lastCommitDate)
    }
    
    enum CodingKeys: String, CodingKey  {
        case id, name, description, language, forks
        case defaultBranch = "default_branch"
        case stars = "stargazers_count"
        case lastCommitDate = "pushed_at"
    }
    

}
