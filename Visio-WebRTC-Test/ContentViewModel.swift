//
//  ContentViewModel.swift
//  Visio-WebRTC-Test
//
//  Created by Julian Ladjani on 17/06/2020.
//  Copyright © 2020 julian ladjani. All rights reserved.
//

import Foundation
import Combine
import WebRTC

class ContentViewModel: ObservableObject {
    @Published var nbFds = 0
    @Published var peers: [Int] = []

    init() {
        
    }

    func deletePeer(index: IndexSet) {
        guard let idx = index.first else { return }
        peers.remove(at: idx)
    }

    func addPeer() {
        //self.objectWillChange.send()
        peers.append(peers.count + 1)
    }
}
