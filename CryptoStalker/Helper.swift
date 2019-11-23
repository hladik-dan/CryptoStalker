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

class Helper {
    static private let formater: NumberFormatter = NumberFormatter()
    
    static private var currencyFormater: NumberFormatter {
        get {
            formater.numberStyle = .currency
            formater.locale = self.locale(currency: Preferences.currency)
            
            return self.formater
        }
    }
    
    static public func formatCurrency(value: Double) -> String {
        return self.currencyFormater.string(from: NSNumber(value: value))!
    }
    
    static private func locale(currency: Currency) -> Locale {
        switch currency {
        case .CZK:
            return Locale(identifier: "cs_CZ")
        case .EUR:
            return Locale(identifier: "de_DE")
        case .GBP:
            return Locale(identifier: "en_GB")
        case .USD:
            return Locale(identifier: "en_US")
        }
    }
}
