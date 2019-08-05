//
//  NotesList.swift
//  Notely
//
//  Created by Arsha Hassas on 8/1/19.
//  Copyright © 2019 Olly Taylor. All rights reserved.
//

import SwiftUI

struct NotesList: View {
    var body: some View {
            List {
                Text(/*@START_MENU_TOKEN@*/"Hello World!"/*@END_MENU_TOKEN@*/)
                Text("I hate this job")
            }
        .navigationBarTitle("Hello")
    }
}

#if DEBUG
struct NotesList_Previews: PreviewProvider {
    static var previews: some View {
        NotesList()
    }
}
#endif
