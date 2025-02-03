//
//  SearchBarView.swift
//  delivery
//
//  Created by Aref Chucri on 03/02/25.
//

import SwiftUI

struct SearchBarView: View {
    @Binding var searchText : String
    
    var body: some View {
        InputView(searchText: $searchText, icon: .constant("magnifyingglass"), placeHolder: .constant("Search drop off location..."))
        .ignoresSafeArea(edges: [.bottom])
        .background(LinearGradient.gradientWalk.opacity(0.58))
        .padding(.top, 7)
    }
}

#Preview  {
   SearchBarView(searchText: .constant("asd"))
}
