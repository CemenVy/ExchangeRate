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
    
    init(timeLastUpdateUtc: String, timeNextUpdateUtc: String, baseCode: String, rates: [String: Double]) {
        self.timeLastUpdateUtc = timeLastUpdateUtc
        self.timeNextUpdateUtc = timeNextUpdateUtc
        self.baseCode = baseCode
        self.rates = rates
    }
    
    init(rateData: [String: Any]) {
        timeLastUpdateUtc = rateData["time_last_update_utc"] as? String ?? ""
        timeNextUpdateUtc = rateData["time_next_update_utc"] as? String ?? ""
        baseCode = rateData["base_code"] as? String ?? ""
        rates = rateData["rates"] as? [String: Double] ?? [:]
    }
    
    static func getRate(from jsonValue: Any) -> Rate {
        guard let rateData = jsonValue as? [String: Any] else {
            return Rate(
                timeLastUpdateUtc: "",
                timeNextUpdateUtc: "",
                baseCode: "",
                rates: [:]
            )
        }
        return Rate(rateData: rateData)
    }
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

