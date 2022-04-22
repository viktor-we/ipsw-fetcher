//
//  SearchBar.swift
//  ipsw-fetcher
//
//  Created by Viktor Weigandt on 28.10.21.
//

import SwiftUI

struct SearchBar: View {
    
    @Binding var text: String
    @State private var isEditing = false
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
            TextField("toolbar_search", text: $text)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(minWidth: 250)
        }
        .padding(.horizontal,10)
    }
}
