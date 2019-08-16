//
//  NoteEditorView.swift
//  Notely
//
//  Created by Arsha Hassas on 8/5/19.
//  Copyright © 2019 Olly Taylor. All rights reserved.
//

import SwiftUI
import Combine

struct NoteEditorView: View {
    
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var model: NoteEditorViewModel
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white.opacity(colorScheme == .light ? 1 : 0.15))
                .shadow(radius: 2, y: 1)
            
            TextView(text: $model.body)
                .padding([.top, .bottom])
        }
    .padding()
    .navigationBarTitle(model.title)
    }
}


final class NoteEditorViewModel: ObservableObject {
    
    var objectWillChange = PassthroughSubject<Void, Never>()

    private var _note: Note
    private let persistentManager = PersistentManager(of: Note.self)

    var title: String { _note.title }
    var body: String {
        get { _note.body }
        set {
            self.objectWillChange.send()
            persistentManager.modify(_note) { note in
                note.body = newValue
            }
        }
    }
    
    
    init(note: Note) {
        self._note = note
    }
    
}

#if DEBUG
struct NoteEditorView_Previews: PreviewProvider {
    static var previews: some View {
        NoteEditorView(model: .init(note: sampleFolder.notes[0]))
    }
}
#endif
