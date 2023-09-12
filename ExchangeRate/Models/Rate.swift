//
//  Rate.swift
//  ExchangeRate
//
//  Created by Семен Выдрин on 12.09.2023.
//

import Foundation

struct Rate: Decodable {
    let time_last_update_utc: String
    let time_next_update_utc: String
    let base_code: String
    let rates: [String: Double]
}
