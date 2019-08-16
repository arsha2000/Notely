//
//  SettingsView.swift
//  Notely
//
//  Created by Arsha Hassas on 8/16/19.
//  Copyright © 2019 Olly Taylor. All rights reserved.
//

import SwiftUI

struct SettingsView: View {
    
    @State private var folderSortingIndex = 0
    @State private var noteSortingIndex = 0
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Sorting").font(.subheadline)) {
                    
                    Picker("Sort Folders By", selection: $folderSortingIndex) {
                        Text(" ")
                    }
                    
                    Picker("Sort Notes By", selection: $noteSortingIndex) {
                        Text("Hi")
                        
                    }
                    
                    
                }
                
                Section {
                    HStack {
                        Text("Version")
                            .font(.body)
                        
                        Spacer()
                        
                        Text("0.9")
                            .font(.body)
                            .foregroundColor(.secondary)
                    }
                }
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
