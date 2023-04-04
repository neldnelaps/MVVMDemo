//
//  UserApi.swift
//  MVVMDemo
//
//  Created by Natalia Pashkova on 04.04.2023.
//

import Foundation

protocol UserApiProtocol {
    func getUsers() async throws -> [User]
}

class UserApi : UserApiProtocol {
    
    private static let host = "jsonplaceholder.typicode.com"
    private let headers: [String: String] = [:]
    private let urlComponents: URLComponents = {
        var components = URLComponents()
        components.scheme = "https"
        components.host = host
        return components
    }()

    func getUsers() async throws -> [User] {
        var components = urlComponents
        components.path = "/posts"

        guard let componentsUrl = components.url
        else { throw ErrorApi(message: "Incorrect URL") }

        let response = try await baseRequest(from: componentsUrl) as [User]
        return response
    }
    
    private func baseRequest<T: Decodable>(from url: URL) async throws -> T {
        var request = URLRequest(url: url)
        print(url)
        request.allHTTPHeaderFields = headers
        let data = try await URLSession.shared.data(for: request).0
        return try JSONDecoder().decode(T.self, from: data)
    }
    
}
