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

struct ContentView: View {
    @EnvironmentObject var preferencesViewModel: PreferencesViewModel
    @EnvironmentObject var itemsViewModel: ItemsViewModel

    @State var cryptocurrency: Cryptourrency = .BTC
    @State var name: String = ""
    @State var address: String = ""

    @State var showSettings: Bool = false

    var body: some View {
        VStack {
            HStack {
                AddItemView()

                Button("Settings",
                       action: {
                    self.showSettings.toggle()
                })
            }
            .padding(EdgeInsets(top: 5, leading: 5, bottom: 0, trailing: 5))

            Divider()

            VStack {
                HStack {
                    Text("")
                        .frame(width: 39)

                    Text("Wallet")
                        .frame(width: 300)

                    Text("Balance")
                        .frame(width: 100)
                }

                ForEach(itemsViewModel.items) { item in
                    ItemView(item: item)
                }
            }
            .padding(.bottom, 5)

            if self.showSettings {
                Divider()

                SettingView()
                    .padding(.bottom, 10)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static func getPreferencesViewModel() -> PreferencesViewModel {
        let preferencesViewModel = PreferencesViewModel()

        return preferencesViewModel
    }

    static func getItemsViewModel() -> ItemsViewModel {
        let item1 = Item(cryptocurrency: .BTC,
                         name: "Bitcoin",
                         address: "Bitcoin Address")
        let item2 = Item(cryptocurrency: .ETH,
                         name: "Ethereum",
                         address: "Ethereum Address")
        let item3 = Item(cryptocurrency: .LTC,
                         name: "Litecoin",
                         address: "Litecoin Address")

        let itemsViewModel = ItemsViewModel(statusBarButton: NSStatusBarButton())
        itemsViewModel.items = [item1, item2, item3]

        return itemsViewModel
    }


    static var previews: some View {
        ContentView().environmentObject(getPreferencesViewModel()).environmentObject(getItemsViewModel())
    }
}
