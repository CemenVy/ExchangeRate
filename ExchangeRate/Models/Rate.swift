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

