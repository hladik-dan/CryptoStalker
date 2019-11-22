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

class CoinMarketCapService {
    private struct Response: Codable {
        let balance: String
    }
    
    func getBalance(cryptocurrency: Cryptourrency, address: String, completion: @escaping (Double?) -> ()) {
        let url = getUrl(cryptocurrency: cryptocurrency, address: address)
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completion(nil)
                return
            }
            
            guard let response = try? JSONDecoder().decode(Response.self, from: data) else {
                completion(nil)
                return
            }
            
            
            let balance = self.decodeBalance(cryptocurrency: cryptocurrency, balance: response.balance)
            
            completion(balance)
        }.resume()
    }
    
    private func decodeBalance(cryptocurrency: Cryptourrency, balance: String) -> Double? {
        switch cryptocurrency {
        case .BTC, .LTC:
            guard let balance = Double(balance) else {
                return nil
            }
            
            return balance / 100000000
        case .ETH:
            let startIndex = balance.index(balance.startIndex, offsetBy: 2)
            let endIndex = balance.endIndex
            let rangeIndex = startIndex..<endIndex
            
            guard let balance = Int(balance[rangeIndex], radix: 16) else {
                return nil
            }
            
            return Double(balance) / 1000000000000000000
        }
    }
    
    private func getUrl(cryptocurrency: Cryptourrency, address: String) -> URL {
        return URL(string: "https://blockchain.coinmarketcap.com/api/address?address=\(address)&symbol=\(cryptocurrency)")!
    }
}
