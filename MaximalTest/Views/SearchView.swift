//
//  SearchView.swift
//  MaximalTest
//
//  Created by Anton Kinstler on 04.10.2022.
//

import SwiftUI

struct SearchView: View {
    
    @State var queryString: String = ""
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                TextField("Enter user name", text: $queryString)
                Button {
                    
                } label: {
                    
                }
            }.padding()
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
