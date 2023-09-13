//
//  NetworkManager.swift
//  ExchangeRate
//
//  Created by Семен Выдрин on 12.09.2023.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case noData
    case decodingError
}

final class NetworkManager {
    static let shared = NetworkManager()
    
    private init() {}
    
    func fetch<T: Decodable>(_ type: T.Type, from url: URL, completion: @escaping (Result<T, NetworkError>) -> Void) {
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data else {
                completion(.failure(.noData))
                print(error?.localizedDescription ?? "No error description")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let rate = try decoder.decode(T.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(rate))
                }
            } catch {
                completion(.failure(.decodingError))
            }
            
        } .resume()
    }
}
