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

struct Preferences {
    enum Key: String {
        case currency
        case items
        case updateFrequency
    }

    static var currency: Currency {
        get {
            let defaultValue: Currency = Currency.USD

            guard let encodedData = UserDefaults.standard.data(forKey: Key.currency.rawValue) else {
                return defaultValue
            }

            guard let currency = try? JSONDecoder().decode(Currency.self, from: encodedData) else {
                return defaultValue
            }

            return currency
        }

        set {
            guard let encodedData = try? JSONEncoder().encode(newValue) else {
                return
            }

            UserDefaults.standard.set(encodedData, forKey: Key.currency.rawValue)
        }
    }

    static var items: [Item] {
        get {
            let defaultValue: [Item] = []

            guard let encodedData = UserDefaults.standard.data(forKey: Key.items.rawValue) else {
                return defaultValue
            }

            guard let items = try? PropertyListDecoder().decode([Item].self, from: encodedData) else {
                return defaultValue
            }

            return items
        }

        set {
            guard let encodedData = try? PropertyListEncoder().encode(newValue) else {
                return
            }

            UserDefaults.standard.set(encodedData, forKey: Key.items.rawValue)
        }
    }

    static var updateFrequency: Double {
        get {
            let defaultValue: Double = 15

            guard let updateFrequency = UserDefaults.standard.object(forKey: Key.updateFrequency.rawValue) as? Double else {
                return defaultValue
            }

            return updateFrequency
        }

        set {
            UserDefaults.standard.set(newValue, forKey: Key.updateFrequency.rawValue)
        }
    }
}
