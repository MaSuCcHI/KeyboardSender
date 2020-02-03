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
                            encryptionPreference: .optional)
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
                do {
                    try self.session.send(data as Data, toPeers: self.session.connectedPeers, with: .reliable)
                } catch {
                    print(error)
                }
            case .mouse:
                do {
                    try self.session.send(data as Data, toPeers: self.session.connectedPeers, with: .unreliable)
                } catch {
                    print(error)
                }
            }
        } else {
            print("接続されていません")
        }
    }
    
    
}

extension Connection: MCSessionDelegate {
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        switch state {
        case .connected:
            print(session.connectedPeers.count)
            browser.stopBrowsingForPeers()
            let data = "OK".data(using: .utf8)
            sendData(data: data!, type: .keyboard)
            break
        case .connecting:
            print(session.connectedPeers.count)
            break
        case .notConnected:
            print(session.connectedPeers.count)
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
    
    func session(_ session: MCSession, didReceiveCertificate certificate: [Any]?, fromPeer peerID: MCPeerID, certificateHandler: @escaping (Bool) -> Void) {
        certificateHandler(true)
    }
    
}
extension Connection: MCNearbyServiceBrowserDelegate {
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        print("Found \(peerID.displayName)")
        // TODO　パスワード認証を入れる
        browser.invitePeer(peerID, to: session, withContext: nil, timeout: 5)
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        searchService()
    }
    
    
}
