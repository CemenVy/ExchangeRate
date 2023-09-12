//
//  ViewController.swift
//  ExchangeRate
//
//  Created by Семен Выдрин on 12.09.2023.
//

import UIKit

enum Link {
    case exchangeRatesUsdURL
    
    var url: URL {
        switch self {
        case .exchangeRatesUsdURL:
            return URL(string: "https://open.er-api.com/v6/latest/USD")!
        }
    }
}

final class MainViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchRate()
    }
    
    // MARK: - Private Methods
    private func showAlert(withTitle title: String, andMessage message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okAction)
        DispatchQueue.main.async { [unowned self] in
            present(alert, animated: true)
        }
    }
}

// MARK: - Networking
extension MainViewController {
    private func fetchRate() {
        URLSession.shared.dataTask(with: Link.exchangeRatesUsdURL.url) { [weak self] data, _, error in
            guard let data else {
                print(error?.localizedDescription ?? "No error description")
                return
            }
            
            let decoder = JSONDecoder()
            
            do {
                let rate = try decoder.decode(Rate.self, from: data)
                print(rate)
                DispatchQueue.main.async { [weak self] in
                    self?.showAlert(withTitle: "success", andMessage: "You can see the results in the Debug area")
                }
            } catch let error {
                self?.showAlert(withTitle: "failed", andMessage: "You can see error in the Debug area")
                print(error.localizedDescription)
            }
            
        } .resume()
    }
}


