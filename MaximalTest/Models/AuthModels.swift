//
//  AuthModels.swift
//  MaximalTest
//
//  Created by Anton Kinstler on 06.10.2022.
//

import Foundation

struct AuthRequest: Encodable {
    
    let clientId: String
    let clientSecret: String
    let code: String
    
    enum CodingKeys: String, CodingKey  {
        case clientId = "client_id"
        case clientSecret = "client_secret"
        case code
    }
}

struct AuthResponce: Decodable {
    let accessToken: String
    let scope: String
    let tokenType: String
    
    enum CodingKeys: String, CodingKey  {
        case accessToken = "access_token"
        case scope
        case tokenType = "token_type"
    }
}
