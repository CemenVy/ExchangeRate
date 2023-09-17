//
//  ViewController.swift
//  ExchangeRate
//
//  Created by Семен Выдрин on 12.09.2023.
//

import UIKit
import Alamofire

enum Section: Int, CaseIterable {
    case info
    case currencies
}

final class MainViewController: UITableViewController {
    
    // MARK: - Private Properties
    private var rate: Rate?
    private var rates: [String: Double] = [:]
    
    // MARK: - View Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchRate()
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        section == Section.info.rawValue ? 3 : rates.count
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        Section.allCases.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell
        
        switch indexPath.section {
        case Section.info.rawValue:
            cell = tableView.dequeueReusableCell(withIdentifier: "detailCell", for: indexPath)
        default:
            cell = tableView.dequeueReusableCell(withIdentifier: "rateCell", for: indexPath)
        }
        
        var content = cell.defaultContentConfiguration()
        
        if indexPath.section == Section.info.rawValue {
            switch indexPath.row {
            case 0:
                content.text = "Последнее обновление курса"
                content.secondaryText = rate?.timeLastUpdateUtc
            case 1:
                content.text = "Следующее обновление курса"
                content.secondaryText = rate?.timeNextUpdateUtc
            default:
                content.text = "Базовая валюта:"
                content.secondaryText = rate?.baseCode
            }
        }
        
        if indexPath.section == Section.currencies.rawValue {
            let currencies = Array(rates.keys).sorted()
            if indexPath.row < currencies.count {
                let currency = currencies[indexPath.row]
                if let exchangeRate = rates[currency] {
                    content.text = currency
                    content.secondaryText = String(format: "%.3f", exchangeRate)
                }
            }
        }
        cell.contentConfiguration = content
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        section == Section.info.rawValue ? "Основная информация" : "Курс валют"
    }
    
    // MARK: - Private Methods
    private func showAlert(with title: String, andMessage message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okAction)
        present(alert,animated: true)
    }
    
    // MARK: - Networking
    private func fetchRate() {
        NetworkManager.shared.fetchRate(from: Link.exchangeRatesUsdURL.url) { [unowned self] result in
                switch result {
                case .success(let jsonValue):
                    self.rate = jsonValue
                    self.rates = jsonValue.rates
                    self.tableView.reloadData()
                case .failure(let error):
                    showAlert(with: "Oops!", andMessage: error.localizedDescription)
                }
            }
    }
}
