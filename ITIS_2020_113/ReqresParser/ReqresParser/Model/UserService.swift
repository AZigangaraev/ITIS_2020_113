//
//  UserService.swift
//  ReqresParser
//
//  Created by Teacher on 30.11.2020.
//

import Foundation
import UIKit

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

    init(responseQueue: DispatchQueue) {
        self.responseQueue = responseQueue
    }

    let baseUrl: URL = {
        guard let url = URL(string: "https://reqres.in/api") else {
            fatalError("Could not create base url")
        }

        return url
    }()
    
    func loadImage(url: URL, _ completion: @escaping (Result<UIImage,UserServiceError>) -> Void) {
        let dataTask = URLSession.shared.dataTask(with: url) { data, response, error in
            
            let result: Result<UIImage, UserServiceError>
            
            defer {
                self.responseQueue.async {
                    completion(result)
                }
            }
            
            guard let data = data,
                  let image = UIImage(data: data) else {
                
                return result = .failure(.noData)
            }
            result = .success(image)
        }
        dataTask.resume()
    }
    var timeoutInterval: TimeInterval = 15

    func loadUser(id: Int, _ completion: @escaping (Result<SingleUserResponse, UserServiceError>) -> Void)  {
         let url = baseUrl.appendingPathComponent("users/\(id)")
         var urlRequest = URLRequest(url: url)
         urlRequest.httpMethod = "GET"
         urlRequest.setValue("text/json", forHTTPHeaderField: "Content-Type")
         urlRequest.timeoutInterval = timeoutInterval
        let dataTask = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
                 let result: Result<SingleUserResponse, UserServiceError>
                 defer {
                     self.responseQueue.async {
                         completion(result)
                     }
                 }

                 if let error = error {
                     return result = .failure(.system(error))
                 }

                 guard let httpResponse = response as? HTTPURLResponse else {
                     return result = .failure(.nonHttpResponse)
                 }
                 guard (200..<300).contains(httpResponse.statusCode) else {
                     return result = .failure(.statusCode(httpResponse.statusCode))
                 }
                 guard let data = data else {
                     return result = .failure(.noData)
                 }
                 do {
                     let response = try self.decoder.decode(SingleUserResponse.self, from: data)
                     result = .success(response)
                 } catch {
                     print("\nResponse:\n\(String(data: data, encoding: .utf8) ?? "")\n")
                     return result = .failure(.parsing(error))
                 }

             }
             dataTask.resume()
    }

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
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.setValue("text/json", forHTTPHeaderField: "Content-Type")
        urlRequest.timeoutInterval = timeoutInterval
        let dataTask = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            let result: Result<UsersResponse, UserServiceError>
            defer {
                self.responseQueue.async {
                    completion(result)
                }
            }

            if let error = error {
                return result = .failure(.system(error))
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                return result = .failure(.nonHttpResponse)
            }
            guard (200..<300).contains(httpResponse.statusCode) else {
                return result = .failure(.statusCode(httpResponse.statusCode))
            }
            guard let data = data else {
                return result = .failure(.noData)
            }
            do {
                let response = try self.decoder.decode(UsersResponse.self, from: data)
                result = .success(response)
            } catch {
                print("\nResponse:\n\(String(data: data, encoding: .utf8) ?? "")\n")
                return result = .failure(.parsing(error))
            }

        }
        dataTask.resume()
    }
}
