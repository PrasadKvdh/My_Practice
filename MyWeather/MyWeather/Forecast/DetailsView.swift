//
//  DetailsView.swift
//  MyWeather
//
//  Created by Prasad Kukkala on 2/20/26.
//

import SwiftUI

struct DetailsView: View {
    @State var response: [DataList]
    
    init(response: [DataList]) {
        self.response = response
    }
    var body: some View {
        Text("Details View")
    }
}
