//
//  Rate.swift
//  ExchangeRate
//
//  Created by Семен Выдрин on 12.09.2023.
//

import Foundation

struct Rate: Decodable {
    let timeLastUpdateUtc: String
    let timeNextUpdateUtc: String
    let baseCode: String
    let rates: [String: Double]
}

enum Link {
    case exchangeRatesUsdURL
    
    var url: URL {
        switch self {
        case .exchangeRatesUsdURL:
            return URL(string: "https://open.er-api.com/v6/latest/USD")!
        }
    }
}
