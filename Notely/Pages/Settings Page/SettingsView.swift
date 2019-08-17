//
//  SettingsView.swift
//  Notely
//
//  Created by Arsha Hassas on 8/16/19.
//  Copyright © 2019 Olly Taylor. All rights reserved.
//

import SwiftUI
import Combine

struct SettingsView: View {
    
    @ObservedObject var model: SettingsViewModel
        
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Sorting").font(.subheadline)) {
                    
                    Picker("Sort Folders By", selection: $model.foldersSorting) {
                        ForEach(Preference.SortingMethod.allCases, id: \.self) { method in
                            Text(method.string)
                        }
                    }
                    
                    Picker("Sort Notes By", selection: $model.notesSorting) {
                        ForEach(Preference.SortingMethod.allCases, id: \.self) { method in
                            Text(method.string)
                        }
                    }
                    
                    
                }
                
                Section(header: Text("About").font(.subheadline)) {
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

final class SettingsViewModel: ObservableObject {
    
    var objectWillChange = PassthroughSubject<Void, Never>()
    
    var foldersSorting: Preference.SortingMethod {
        get { preference.foldersSortingMethod }
        set {
            objectWillChange.send()
            preference.foldersSortingMethod = newValue
        }
    }
    var notesSorting: Preference.SortingMethod {
        get { preference.notesSortingMethod }
        set {
            objectWillChange.send()
            preference.notesSortingMethod = newValue
        }
    }
    
    private var preference = Preference.shared
    
}

#if DEBUG
struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(model: .init())
    }
}
#endif
