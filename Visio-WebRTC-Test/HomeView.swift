//
//  HomeView.swift
//  Visio-WebRTC-Test
//
//  Created by Julian Ladjani on 17/06/2020.
//  Copyright © 2020 julian ladjani. All rights reserved.
//

import Combine
import SwiftUI

struct HomeView: View {
    @State var nbFD: Int = 1

    var body: some View {
        NavigationView {
        VStack(alignment: .leading) {
            HStack(alignment: .top) {
                Text("\(nbFD) open File descriptors")
                    .padding()
                Spacer()
            }
            Spacer()
        }.navigationBarTitle(Text("WebRTC Test"))
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
