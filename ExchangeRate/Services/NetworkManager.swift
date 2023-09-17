//
//  NetworkManager.swift
//  ExchangeRate
//
//  Created by Семен Выдрин on 12.09.2023.
//

import Foundation
import Alamofire

enum NetworkError: Error {
    case invalidURL
    case noData
    case decodingError
}

final class NetworkManager {
    static let shared = NetworkManager()
    
    private init() {}
    
    func fetchRate(from url: URL, completion: @escaping (Result<Rate, AFError>) -> Void) {
        AF.request(Link.exchangeRatesUsdURL.url)
            .validate()
            .responseJSON { dataResponse in
                switch dataResponse.result {
                case .success(let jsonValue):
                    let rateData = Rate.getRate(from: jsonValue)
                    completion(.success(rateData))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
}
