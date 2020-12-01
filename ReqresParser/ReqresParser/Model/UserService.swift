//
//  UserService.swift
//  ReqresParser
//
//  Created by Teacher on 30.11.2020.
//

import Foundation

enum UserServiceError: Error {
    case system(Error)
    case nonHttpResponse
    case statusCode(Int)
    case noData
    case parsing(Error)
    case urlCreation
}

class UserService {
    private let responseQueue: DispatchQueue
    private let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
    
    private let baseUrl: URL = {
        guard let url = URL(string: "https://reqres.in/api") else {
            fatalError("Could not create base url")
        }
        
        return url
    }()
    
    private var timeoutInterval: TimeInterval = 15
    
    init(responseQueue: DispatchQueue) {
        self.responseQueue = responseQueue
    }
    
    // MARK: - Actions
    
    func loadUsers(page: Int, _ completion: @escaping (Result<UsersResponse, UserServiceError>) -> Void) {
        guard var urlComponents = URLComponents(url: baseUrl.appendingPathComponent("users"), resolvingAgainstBaseURL: false) else {
            return completion(.failure(.urlCreation))
        }
        if page > 1 {
            urlComponents.queryItems = [
                URLQueryItem(name: "page", value: "\(page)")
            ]
        }
        guard let url = urlComponents.url else {
            return completion(.failure(.urlCreation))
        }
        
        let request = buildRequest(from: url)
        
        let dataTask = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard let self = self else { return }
            let result = self.getResult(with: UsersResponse.self, from: data, response: response, error: error)
            self.responseQueue.async { completion(result) }
        }
        dataTask.resume()
    }
    
    func loadUser(by id: Int, _ completion: @escaping (Result<UserResponse, UserServiceError>) -> Void) {
        guard let urlComponents = URLComponents(url: baseUrl
                                .appendingPathComponent("users/\(id)"), resolvingAgainstBaseURL: false) else {
            return completion(.failure(.urlCreation))
        }
      
        guard let url = urlComponents.url else {
            return completion(.failure(.urlCreation))
        }
        
        let request = buildRequest(from: url)
        let dataTask = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard let self = self else { return }
            let result = self.getResult(with: UserResponse.self, from: data, response: response, error: error)
            self.responseQueue.async { completion(result) }
        }
        dataTask.resume()
    }
    
    // MARK: - Helpers
    
    private func buildRequest(from url: URL) -> URLRequest {
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.setValue("text/json", forHTTPHeaderField: "Content-Type")
        urlRequest.timeoutInterval = timeoutInterval
        return urlRequest
    }
    
    private func getResult<Model: Decodable> (with model: Model.Type,
                                              from data: Data?,
                                              response: URLResponse?,
                                              error: Error?) -> Result<Model, UserServiceError> {
        if let error = error {
            return .failure(.system(error))
        }
        
        guard let httpResponse = response as? HTTPURLResponse else {
            return .failure(.nonHttpResponse)
        }
        
        guard (200..<300).contains(httpResponse.statusCode) else {
            return .failure(.statusCode(httpResponse.statusCode))
        }
        
        guard let data = data else {
            return .failure(.noData)
        }
        
        do {
            let response = try self.decoder.decode(model, from: data)
            return .success(response)
        } catch {
            print("\nResponse:\n\(String(data: data, encoding: .utf8) ?? "")\n")
            return .failure(.parsing(error))
        }
    }
}
