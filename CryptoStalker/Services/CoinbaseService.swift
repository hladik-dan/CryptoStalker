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

class CoinbaseService {
    private struct Response: Codable {
        let data: ResponseData
    }

    private struct ResponseData: Codable {
        let currency: String
        let rates: [String:String]
    }

    func getValue(balance: Double?, from: Cryptourrency, to: Currency, completion: @escaping (Double?) -> ()) {
        guard let balance = balance else {
            completion(nil)
            return
        }

        let url = getUrl(cryptocurrency: from)

        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completion(nil)
                return
            }

            guard let response = try? JSONDecoder().decode(Response.self, from: data) else {
                completion(nil)
                return
            }

            guard let rateString = response.data.rates.first(where: { $0.key == to.rawValue })?.value else {
                completion(nil)
                return
            }

            guard let rate = Double(rateString) else {
                completion(nil)
                return
            }

            let value = balance * rate

            completion(value)
        }.resume()
    }

    private func getUrl(cryptocurrency: Cryptourrency) -> URL {
        return URL(string: "https://api.coinbase.com/v2/exchange-rates?currency=\(cryptocurrency)")!
    }
}
