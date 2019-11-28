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

struct AddItemView: View {
    @EnvironmentObject var itemsViewModel: ItemsViewModel

    @State var cryptocurrency: Cryptourrency = .BTC
    @State var name: String = ""
    @State var address: String = ""

    @State var addButtonText: String = "+"

    @State var showForm: Bool = false

    var body: some View {
        HStack {
            if self.showForm {
                Picker("Cryptocurrency",
                       selection: self.$cryptocurrency) {
                    Image("Bitcoin")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .tag(Cryptourrency.BTC)
                    Image("Ethereum")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .tag(Cryptourrency.ETH)
                    Image("Litecoin")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .tag(Cryptourrency.LTC)
                    Image("Stellar")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .tag(Cryptourrency.XLM)
                }
                .labelsHidden()
                .frame(width: 50)

                TextField("Name", text: self.$name, onEditingChanged: nameTextFieldChanged)
                    .multilineTextAlignment(.center)
                    .frame(width: 100)

                TextField("Address", text: self.$address, onEditingChanged: addressTextFieldChanged)
                    .multilineTextAlignment(.center)
                    .frame(width: 150)
            }

            Button(self.addButtonText, action: addButtonAction)
                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
        }
    }

    func nameTextFieldChanged(_: Bool) {
        if self.name.isEmpty && self.address.isEmpty {
            self.addButtonText = "-"
        } else {
            self.addButtonText = "+"
        }
    }

    func addressTextFieldChanged(_: Bool) {
        if self.name.isEmpty && self.address.isEmpty {
            self.addButtonText = "-"
        } else {
            self.addButtonText = "+"
        }
    }

    func addButtonAction() {
        if !self.showForm {
            self.showForm.toggle()
            self.addButtonText = "-"
            return
        }

        if self.name.count < 1 || self.address.count < 1 {
            self.addButtonText = "+"
            self.showForm.toggle()
            return
        }

        let item = Item(cryptocurrency: self.cryptocurrency,
                        name: self.name,
                        address: self.address)
        self.itemsViewModel.addItem(item: item)

        self.name = ""
        self.address = ""
    }
}

struct AddItemView_Previews: PreviewProvider {
    static var previews: some View {
        AddItemView()
    }
}
