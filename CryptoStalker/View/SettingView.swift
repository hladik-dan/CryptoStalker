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

struct SettingView: View {
    @EnvironmentObject var preferencesViewModel: PreferencesViewModel
    
    var body: some View {
        VStack {
            HStack {
                Picker("UpdateFrequency",
                       selection: self.$preferencesViewModel.currency) {
                        Text("CZK").tag(Currency.CZK)
                        Text("EUR").tag(Currency.EUR)
                        Text("USD").tag(Currency.USD)
                }
                .pickerStyle(SegmentedPickerStyle())
                .labelsHidden()
                .frame(width: 350)
            }
            
            HStack {
                Picker("UpdateFrequency",
                       selection: self.$preferencesViewModel.updateFrequency) {
                        Text("1").tag(1)
                        Text("5").tag(5)
                        Text("15").tag(15)
                        Text("30").tag(30)
                        Text("60").tag(60)
                }
                .pickerStyle(SegmentedPickerStyle())
                .labelsHidden()
                .frame(width: 350)
            }
        }
    }
}

struct SettingView_Previews: PreviewProvider {
    static func getPreferencesViewModel() -> PreferencesViewModel {
        return PreferencesViewModel()
    }
    
    static func getItem() -> Item {
        return Item(cryptocurrency: .BTC,
                    name: "Bitcoin",
                    address: "Bitcoin Address")
    }


    static var previews: some View {
        SettingView().environmentObject(getPreferencesViewModel())
    }
}
