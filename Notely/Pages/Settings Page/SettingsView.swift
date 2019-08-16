//
//  SettingsView.swift
//  Notely
//
//  Created by Arsha Hassas on 8/16/19.
//  Copyright © 2019 Olly Taylor. All rights reserved.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        NavigationView {
            Form {
                Text("Hello")
            }
        .navigationBarTitle("Settings")
        }
    }
}

#if DEBUG
struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
#endif
