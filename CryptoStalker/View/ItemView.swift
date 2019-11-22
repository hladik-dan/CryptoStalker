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

struct ItemView: View {
    @EnvironmentObject var itemsViewModel: ItemsViewModel
    
    @ObservedObject var item: Item

    var body: some View {
        HStack {
            Image("\(item.cryptocurrency)")
                .resizable()
                .frame(width: 24, height: 24)
                .padding(.leading, 15)

            Text("\(item.name)")
                .frame(width: 300)

            Text("\(item.value)")
                .frame(width: 100)
            
        }.contextMenu {
            Button("Copy address", action: {
                NSPasteboard.general.clearContents()
                NSPasteboard.general.setString(self.item.address, forType: .string)
            })
            Button("Delete", action: {
                self.itemsViewModel.deleteItem(item: self.item)
            })
        }
    }
}

struct ItemView_Previews: PreviewProvider {
    static func getItemsViewModel() -> ItemsViewModel {
        return ItemsViewModel(statusBarButton: NSStatusBarButton())
    }
    
    static func getItem() -> Item {
        return Item(cryptocurrency: .BTC,
                    name: "Bitcoin",
                    address: "Bitcoin Address")
    }


    static var previews: some View {
        ItemView(item: getItem()).environmentObject(getItemsViewModel())
    }
}
