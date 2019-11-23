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

class Item: NSObject, Codable, Identifiable, ObservableObject {
    private enum CodingKeys: String, CodingKey {
        case address
        case balance
        case cryptocurrency
        case name
        case value
    }
    
    let id = UUID()
    
    @Published private(set) var _cryptocurrency: Cryptourrency
    @Published private(set) var _name: String
    @Published private(set) var _address: String
    @Published private(set) var _balance: Double?
    @Published private(set) var _value: Double?
    
    var cryptocurrency: String {
        switch self._cryptocurrency {
        case .BTC:
            return "Bitcoin"
        case .ETH:
            return "Ethereum"
        case .LTC:
            return "Litecoin"
        }
    }
    
    var name: String {
        return self._name
    }
    
    var address: String {
        return self._address
    }
    
    var value: String {
        return Helper.formatCurrency(value: self._value ?? 0)
    }
    
    init(cryptocurrency: Cryptourrency, name: String, address: String) {
        self._cryptocurrency = cryptocurrency
        self._name = name
        self._address = address
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self._address = try container.decode(String.self, forKey: .address)
        self._balance = try container.decode(Double?.self, forKey: .balance)
        self._cryptocurrency = try container.decode(Cryptourrency.self, forKey: .cryptocurrency)
        self._name = try container.decode(String.self, forKey: .name)
        self._value = try container.decode(Double?.self, forKey: .value)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(self._address, forKey: .address)
        try container.encode(self._balance, forKey: .balance)
        try container.encode(self._cryptocurrency, forKey: .cryptocurrency)
        try container.encode(self._name, forKey: .name)
        try container.encode(self._value, forKey: .value)
    }
    
    func update(dispatchGroup: DispatchGroup) {
        dispatchGroup.enter()
        
        CoinMarketCapService().getBalance(cryptocurrency: self._cryptocurrency, address: self._address) { balance in
            DispatchQueue.main.async {
                self._balance = balance
            }
            
            CoinbaseService().getValue(balance: balance, from: self._cryptocurrency, to: Preferences.currency) { value in
                DispatchQueue.main.async {
                    self._value = value
                }
                
                dispatchGroup.leave()
            }
        }
    }
}
