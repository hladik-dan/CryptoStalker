//
//  Copyright © 2019 Daniel Hladík. All rights reserved.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

import Foundation

class WalletInfoService {
    private struct CoinMarketCapResponse: Codable {
        let balance: String
    }

    private struct StellarResponse: Codable {
        let balances: [StellarBalancesResponse]
    }

    private struct StellarBalancesResponse: Codable {
        let balance: String
        let asset_type: String
    }

    private struct XrpScanResponse: Codable {
        let xrpBalance: String
    }

    func getBalance(cryptocurrency: Cryptourrency, address: String, completion: @escaping (Double?) -> ()) {
        let url = getUrl(cryptocurrency: cryptocurrency, address: address)

        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completion(nil)
                return
            }

            guard let responseBalance = self.getResponseBalance(cryptocurrency: cryptocurrency, data: data) else {
                completion(nil)
                return
            }


            let balance = self.decodeBalance(cryptocurrency: cryptocurrency, balance: responseBalance)

            completion(balance)
        }.resume()
    }

    private func getResponseBalance(cryptocurrency: Cryptourrency, data: Data) -> String? {
        switch cryptocurrency {
        case .BTC, .ETH, .LTC:
            guard let response = try? JSONDecoder().decode(CoinMarketCapResponse.self, from: data) else {
                return nil
            }

            return response.balance
        case .XLM:
            guard let response = try? JSONDecoder().decode(StellarResponse.self, from: data) else {
                return nil
            }

            return response.balances.first(where: { $0.asset_type == "native" })?.balance
        case .XRP:
            guard let response = try? JSONDecoder().decode(XrpScanResponse.self, from: data) else {
                return nil
            }

            return response.xrpBalance
        }
    }

    private func decodeBalance(cryptocurrency: Cryptourrency, balance: String) -> Double? {
        switch cryptocurrency {
        case .BTC, .LTC:
            guard let balance = Int(balance) else {
                return nil
            }

            return Double(balance) / 100000000
        case .ETH:
            let startIndex = balance.index(balance.startIndex, offsetBy: 2)
            let endIndex = balance.endIndex
            let rangeIndex = startIndex..<endIndex

            guard let balance = Int(balance[rangeIndex], radix: 16) else {
                return nil
            }

            return Double(balance) / 1000000000000000000
        case .XLM:
            guard let balance = Double(balance) else {
                return nil
            }

            return balance
        case .XRP:
            guard let balance = Double(balance) else {
                return nil
            }

            return balance
        }
    }

    private func getUrl(cryptocurrency: Cryptourrency, address: String) -> URL {
        switch cryptocurrency {
        case .BTC, .ETH, .LTC:
            return URL(string: "https://blockchain.coinmarketcap.com/api/address?address=\(address)&symbol=\(cryptocurrency)")!
        case .XLM:
            return URL(string: "https://horizon.stellar.org/accounts/\(address)")!
        case .XRP:
            return URL(string: "https://api.xrpscan.com/api/v1/account/\(address)")!
        }
    }
}
