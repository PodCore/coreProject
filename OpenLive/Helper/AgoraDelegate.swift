//
//  AgoraDelegate.swift
//  OpenLive
//
//  Created by Sky Xu on 3/3/18.
//  Copyright © 2018 Agora. All rights reserved.
//

import Foundation
import AgoraRtcEngineKit

//class AgoraDelegate<VideoSession>: NSObject, AgoraRtcEngineDelegate {
//    
//    var rtcEngine: AgoraRtcEngineKit!
//    var videoSessions: [VideoSession]
//    init(videoSessions: [VideoSession]) {
//        self.videoSessions = videoSessions
//    }
//    
//    func fetchSession(ofUid uid: Int64) -> VideoSession? {
//        for session in videoSessions {
//            if session.uid == uid {
//                return session
//            }
//        }
//        return nil
//    }
//    
//    func videoSession(ofUid uid: Int64) -> VideoSession {
//        if let fetchedSession = fetchSession(ofUid: uid) {
//            return fetchedSession
//        } else {
//            let newSession = VideoSession(uid: uid)
//            videoSessions.append(newSession)
//            return newSession
//        }
//    }
//    
//    func rtcEngine(_ engine: AgoraRtcEngineKit, didJoinedOfUid uid: UInt, elapsed: Int) {
//        let userSession = videoSession(ofUid: Int64(uid))
//        //  MARK:  Set remote video view in rtcEngine callback
//        rtcEngine.setupRemoteVideo(userSession.canvas)
//    }
//    
//    func rtcEngine(_ engine: AgoraRtcEngineKit, firstLocalVideoFrameWith size: CGSize, elapsed: Int) {
//        if let _ = videoSessions.first {
//            updateInterface(withAnimation: false)
//        }
//    }
//    
//    func rtcEngine(_ engine: AgoraRtcEngineKit, didOfflineOfUid uid: UInt, reason: AgoraRtcUserOfflineReason) {
//        var indexToDelete: Int?
//        for (index, session) in videoSessions.enumerated() {
//            if session.uid == Int64(uid) {
//                session.hostingView.removeFromSuperview()
//            }
//        }
//        
//        if let indexToDelete = indexToDelete {
//            let deletedSession = videoSessions.remove(at: indexToDelete)
//            deletedSession.hostingView.removeFromSuperview()
//            
//            if deletedSession == fullScreenSession {
//                fullScreenSession = nil
//            }
//        }
//    }
//}

