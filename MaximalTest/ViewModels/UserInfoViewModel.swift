//
//  UserInfoViewModel.swift
//  MaximalTest
//
//  Created by Anton Kinstler on 06.10.2022.
//

import Foundation
import AuthenticationServices
import Combine


class UserInfoViewModel: NSObject, ObservableObject, ASWebAuthenticationPresentationContextProviding {
    @Published var status: PageStatus = .unautorized
    @Published var unauthorized: Bool = true
    @Published var authoruzation: Bool = false
    @Published var fetchingUserInfo: Bool = false
    @Published var userInfo: User? = nil
    
   
    private var webAuthSession: ASWebAuthenticationSession?
    private let clientId = "f2ca8fd2cf7ad40f3a9f"
    private let clientSecret = "060d4d90fa6f2a2fc261a7694fcc4cc397943005"
    
    private var disposables = Set<AnyCancellable>()
    
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        return ASPresentationAnchor()
    }
    
    public func authenticate() {
        
        authoruzation = true
        status = .loadingData
        let queryParams = [URLQueryItem(name: "client_id", value: clientId)]
        let components = ServerDataManager.components(path: "/login/oauth/authorize", parameters: queryParams)
        
        if let url = try? components.asURL() {
            webAuthSession = ASWebAuthenticationSession.init(
                url: url,
                callbackURLScheme: "maximaltest",
                completionHandler: { [weak self] (callback:URL?, error:Error?) in
                    guard let self = self else { return }
                    guard error == nil,
                        let callbackURL = callback,
                        let queryItems = URLComponents(string: callbackURL.absoluteString)?.queryItems,
                        let code = queryItems.first(where: { $0.name == "code" })?.value
                    else {
                        self.status = .unautorized
                        print("An error occurred when attempting to sign in.")
                        return
                    }
                    self.getAuthToken(code)
                })

            webAuthSession?.presentationContextProvider = self
            webAuthSession?.prefersEphemeralWebBrowserSession = true
            webAuthSession?.start()
        }
    }
    
    private func getAuthToken(_ code: String) {
        
        let authRequest = AuthRequest(clientId: clientId, clientSecret: clientSecret, code: code)
        ServerDataManager.shared.getAuthorizationToken(authRequest)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] value in
                guard let self = self else { return }
                switch value {
                case .failure:
                    self.status = .unautorized
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] result in
                guard let self = self else { return }
                ServerDataManager.shared.setToken(result.accessToken)
                self.getUserInfo()
            })
            .store(in: &disposables)
    }
    
    public func getUserInfo() {
        fetchingUserInfo = true
        ServerDataManager.shared.fetchUserInfo()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] value in
                guard let self = self else { return }
                switch value {
                case .failure:
                    self.status = .unautorized
                    debugPrint(value)
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] result in
                guard let self = self else { return }
                self.userInfo = result
                self.status = .userInfoBeenSet
            })
            .store(in: &disposables)
        
    }
    
    enum PageStatus {
        case unautorized
        case loadingData
        case userInfoBeenSet
    }
}
