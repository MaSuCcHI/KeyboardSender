//
//  ConnectionManager.swift
//  KeyboardSender
//
//  Created by KEISUKE MASUDA on 2020/02/02.
//  Copyright © 2020 KEISUKE MASUDA. All rights reserved.
//

import Foundation
import MultipeerConnectivity

enum ControllType {
    case mouse
    case keyboard
}

class Connection: NSObject {
    private let selfID = MCPeerID(displayName: "Sender")
    private let session: MCSession
    private let browser: MCNearbyServiceBrowser
    override init() {
        session = MCSession(peer: selfID,
                            securityIdentity: nil,
                            encryptionPreference: .none)
        browser = MCNearbyServiceBrowser(peer: selfID, serviceType: "isReceiver")
        super.init()
        session.delegate = self
        browser.delegate = self
    }
    
    open func searchService(){
        browser.startBrowsingForPeers()
    }
    
    open func sendData(data: Data, type: ControllType) {
        if !session.connectedPeers.isEmpty {
            switch type {
            case .keyboard:
                try? self.session.send(data, toPeers: self.session.connectedPeers, with: .reliable)
                
            case .mouse:
                try? session.send(data, toPeers: session.connectedPeers, with: .unreliable)
                break
            default:
                break
            }
        } else {
            print("どこにも接続していません")
        }
    }
    
    
}

extension Connection: MCSessionDelegate {
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        switch state {
        case .connected:
            browser.stopBrowsingForPeers()
            break
        case .connecting:
            break
        case .notConnected:
            browser.startBrowsingForPeers()
            break
        default:
            break
        }
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        return
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        
        return
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        return
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        return
    }
    
}
extension Connection: MCNearbyServiceBrowserDelegate {
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        print("Found \(peerID.displayName)")
        // TODO　パスワード認証を入れる
        browser.invitePeer(peerID, to: session, withContext: nil, timeout: 0)
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        searchService()
    }
    
    
}
