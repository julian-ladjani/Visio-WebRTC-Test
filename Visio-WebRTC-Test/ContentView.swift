//
//  ContentView.swift
//  Visio-WebRTC-Test
//
//  Created by Julian Ladjani on 17/06/2020.
//  Copyright © 2020 julian ladjani. All rights reserved.
//

import Combine
import SwiftUI


struct ContentView: View {
    @ObservedObject var viewModel: ContentViewModel

    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Text("\(viewModel.nbFds) open File descriptors")
                        .padding()
                    Spacer()
                }
                List {
                    ForEach(viewModel.peers, id: \.self) { peer in
                        Text("Remote \(peer)")
                    }.onDelete { idx in
                        self.viewModel.deletePeer(index: idx)
                    }
                }
                Spacer()
            }
            .navigationBarTitle(Text("WebRTC Test"))
            .navigationBarItems(trailing: Button(action: {
                self.viewModel.addPeer()
            }, label: {
                HStack {
                    Text("Ajouter")
                    Image(systemName: "plus.circle").font(.system(size: 28.0, weight: .light))
                }
            }))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewModel: ContentViewModel())
    }
}
