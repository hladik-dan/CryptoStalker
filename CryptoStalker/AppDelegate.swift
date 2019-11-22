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

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    var statusItem: NSStatusItem!
    var statusBarButton: NSStatusBarButton!
    var preferencesViewModel: PreferencesViewModel!
    var itemsViewModel: ItemsViewModel!
    var popover: NSPopover!

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        
        statusBarButton = statusItem.button
        statusBarButton.title = "CryptoStalker"
        statusBarButton.target = self
        statusBarButton.action = #selector(showPopover)
        
        preferencesViewModel = PreferencesViewModel()
        
        itemsViewModel = ItemsViewModel(statusBarButton: statusBarButton)
        
        popover = NSPopover()
        popover.contentViewController = NSHostingController(rootView: ContentView().environmentObject(preferencesViewModel).environmentObject(itemsViewModel))
        popover.behavior = .transient
    }

    func applicationWillTerminate(_ aNotification: Notification) {
    }

    @objc func showPopover() {
        popover.show(relativeTo: statusBarButton.bounds,
                     of: statusBarButton,
                     preferredEdge: .maxY)
    }
}
