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

class ItemsViewModel: ObservableObject {
    @Published var items: [Item] = []
    @Published var totalValue: Double? {
        willSet {
            let newValue = newValue ?? 0
            let totalValue = self.totalValue ?? 0
            
            let positiveColor = NSColor.init(red: 0.52, green: 0.73, blue: 0.39, alpha: 1.00)
            let negativeColor = NSColor.init(red: 0.85, green: 0.27, blue: 0.24, alpha: 1.00)
            
            var balance = "   "
            var color = NSColor.init(red: 0.00, green: 0.00, blue: 0.00, alpha: 1.00)
            if newValue > totalValue {
                balance = " ▲ "
                color = positiveColor
            } else if newValue < totalValue {
                balance = " ▼ "
                color = negativeColor
            }
            
            let title = NSMutableAttributedString()
            title.append(NSAttributedString(string: balance, attributes: [ .foregroundColor : color ]))
            title.append(NSAttributedString(string: String(format: "%.2f \(Preferences.currency)", newValue)))
            
            self.statusBarButton.attributedTitle = title
        }
    }
    
    let dispatchGroup: DispatchGroup = DispatchGroup()
    
    let statusBarButton: NSStatusBarButton
    
    init(statusBarButton: NSStatusBarButton) {
        self.statusBarButton = statusBarButton
        
        self.items = Preferences.items
        
        self.update()
    }
    
    func addItem(item: Item) {
        self.items.append(item)
        self.update()
        
        Preferences.items = self.items
    }
    
    func deleteItem(item: Item) {
        guard let index = self.items.firstIndex(of: item) else {
            return
        }
        
        self.items.remove(at: index)
        self.update()
        
        Preferences.items = self.items
    }
    
    func update() {
        for item in self.items {
            item.update(dispatchGroup: dispatchGroup)
        }
        
        dispatchGroup.notify(queue: .main) {
            self.updateTotalValue()
        }
    }
    
    func updateTotalValue() {
        let totalValue = self.items.map({ $0._value }).compactMap({ $0 }).reduce(0, +)
        self.totalValue = totalValue
    }
}
