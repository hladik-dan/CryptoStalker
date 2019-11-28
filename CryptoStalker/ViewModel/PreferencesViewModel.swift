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

import SwiftUI

class PreferencesViewModel: ObservableObject {
    @Published var currency: Currency {
        didSet {
            if self.currency == Preferences.currency {
                return
            }

            Preferences.currency = self.currency

            guard let application = NSApplication.shared.delegate as? AppDelegate else {
                return
            }

            application.itemsViewModel.update()
        }
    }

    @Published var updateFrequency: Int {
        didSet {
            if Double(self.updateFrequency) == Preferences.updateFrequency {
                return
            }

            Preferences.updateFrequency = Double(self.updateFrequency)

            if let timer = self.updateFrequencyTimer {
                timer.invalidate()
            }

            self.updateFrequencyTimer = setUpdateFrequencyTimer()
        }
    }

    private var updateFrequencyTimer: Timer?

    init() {
        self.currency = Preferences.currency
        self.updateFrequency = Int(Preferences.updateFrequency)
        self.updateFrequencyTimer = self.setUpdateFrequencyTimer()
    }

    private func setUpdateFrequencyTimer() -> Timer {
        let minute = 60.0

        let timer = Timer.scheduledTimer(withTimeInterval: Preferences.updateFrequency * minute, repeats: true) { _ in
            guard let application = NSApplication.shared.delegate as? AppDelegate else {
                return
            }

            application.itemsViewModel.update()
        }

        RunLoop.main.add(timer, forMode: .common)

        return timer
    }
}
