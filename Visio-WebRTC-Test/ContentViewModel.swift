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
    @Published var peers: [RTCPeerConnection] = []
    private var servers: [RTCIceServer]
    private let factory: RTCPeerConnectionFactory = {
        RTCInitializeSSL()
        let videoEncoderFactory = RTCDefaultVideoEncoderFactory()
        let videoDecoderFactory = RTCDefaultVideoDecoderFactory()

        return RTCPeerConnectionFactory(encoderFactory: videoEncoderFactory, decoderFactory: videoDecoderFactory)
    }()
    private var localDataChannel: RTCDataChannel?
    private var remoteDataChannels: [RTCDataChannel] = []
    private let localPeerConnection: RTCPeerConnection
    private let loopbackConstraints = RTCMediaConstraints(
        mandatoryConstraints: nil,
        optionalConstraints: ["DtlsSrtpKeyAgreement":kRTCMediaConstraintsValueTrue]
    )
    private let mediaConstrains = [
            kRTCMediaConstraintsOfferToReceiveAudio: kRTCMediaConstraintsValueTrue,
            kRTCMediaConstraintsOfferToReceiveVideo: kRTCMediaConstraintsValueTrue
        ]

    private let config: RTCConfiguration

    init() {
        servers = [RTCIceServer(
            urlStrings: [
                "turn:192.158.29.39:3478?transport=tcp",
            ],
            username: "JZEOEt2V3Qb0y27GRntt2u2PAYA=",
            credential: "28224511:1379330808"
        )]
        config = RTCConfiguration()
        config.iceServers = servers
        config.disableLinkLocalNetworks = true
        localPeerConnection = factory.peerConnection(with: config, constraints: loopbackConstraints, delegate: nil)


        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] (timer) in
            guard let number = self?.getFileDescriptors() else { return }
            print(number)
            self?.nbFds = number
        }
    }

    func deletePeer(index: IndexSet) {
        guard let idx = index.first else { return }
        peers[idx].close()
        peers.remove(at: idx)
    }

    func addPeer() {
        //self.objectWillChange.send()
        let constrains = RTCMediaConstraints(mandatoryConstraints: self.mediaConstrains,
                                             optionalConstraints: nil)
        let peerConnection = factory.peerConnection(with: config, constraints: loopbackConstraints, delegate: nil)
        localPeerConnection.offer(for: constrains) { [weak self] (offerDescription, error) in
            guard let offerDescription = offerDescription, let self = self else { return }
            self.localPeerConnection.setLocalDescription(offerDescription, completionHandler: { _ in })
            peerConnection.setRemoteDescription(offerDescription, completionHandler: { _ in })
            peerConnection.answer(for: constrains) { [weak self] (answerDescription, error) in
                guard let answerDescription = answerDescription else { return }
                peerConnection.setLocalDescription(answerDescription, completionHandler: { _ in })
                self?.localPeerConnection.setRemoteDescription(answerDescription, completionHandler: { _ in })
                DispatchQueue.main.async {
                    self?.peers.append(peerConnection)
                }
            }
        }
    }

    func getFileDescriptors() -> Int {
        (0...getdtablesize()).reduce(0) { (result, fd) in result + (fcntl(fd, F_GETFL) >= 0 ? 1 : 0) }
    }
}
