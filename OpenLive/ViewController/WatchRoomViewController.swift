//
//  WatchRoomViewController.swift
//  OpenLive
//
//  Created by Sky Xu on 2/15/18.
//  Copyright © 2018 Agora. All rights reserved.
//

import UIKit
import AgoraRtcEngineKit
//import Alamofire
import SocketIO

protocol WatchRoomVCDelegate: NSObjectProtocol {
    func watchVCNeedClose(_ watchVC: WatchRoomViewController)
}

class WatchRoomViewController: UIViewController {
    @IBOutlet weak var remoteContainerView: UIView!
    @IBOutlet weak var remoteButton: UIButton!
    @IBOutlet weak var roomNameLabel: UILabel!
    // MARK: this is Channel ID , has to be unique
    var roomId: String?
    
    var roomName: String!
    
    var videoProfile: AgoraRtcVideoProfile!
    //video Profile to set Quality/FrameR (retrieved from previous VC)
    
    weak var delegate: WatchRoomVCDelegate?

    var rtcEngine : AgoraRtcEngineKit!
   
    fileprivate var isMuted = false {
        didSet {
            rtcEngine?.muteLocalAudioStream(isMuted)
        }
    }
    
    fileprivate var videoSessions = [VideoSession]() {
        didSet {
            guard remoteContainerView != nil else {
                return
            }
            updateInterface(withAnimation: true)
        }
    }
    // VideoSessions is a helper class to manage the # of broadcasters in the channel
    // Updates the interface based on # of broadcasters (see updateInterface() below)
    
    fileprivate var fullScreenSession: VideoSession? {
        didSet {
            if fullScreenSession != oldValue && remoteContainerView != nil {
                updateInterface(withAnimation: true)
            }
        }
    }
    
    fileprivate let viewLayouter = VideoViewLayouter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        roomNameLabel.text = roomName
        loadAgoraKit()
    }
    
    @IBAction func doMutePressed(_ sender: UIButton) {
        isMuted = !isMuted
    }
    
    //    switch client role
    @IBAction func doBroadcastPressed(_ sender: UIButton) {
            if fullScreenSession?.uid == 0 {
                fullScreenSession = nil
            }
        updateInterface(withAnimation :true)
    }
    
    @IBAction func doLeavePressed(_ sender: UIButton) {
        leaveChannel()
    } //Leave channel when X is clicked
}


//MARK: - Agora Media SDK
private extension WatchRoomViewController {
    
    // MARK: connect to  engine and channel room
    func loadAgoraKit() {
        rtcEngine = AgoraRtcEngineKit.sharedEngine(withAppId: KeyCenter.AppId, delegate: self)
        // Set Channel Profile
        rtcEngine.setChannelProfile(.channelProfile_LiveBroadcasting)
        // (Ignore Now) Enable dual stream mode
//        rtcEngine.enableDualStreamMode(true)
        //  Enable Video
        rtcEngine.enableVideo()
        //Set video profile (using videoProfile variable from previous VC)
        rtcEngine.setVideoProfile(videoProfile, swapWidthAndHeight: true)
        rtcEngine.setVideoQualityParameters(false)
        
        // Set client role (using clientRole variable)
    rtcEngine.setClientRole(AgoraRtcClientRole.clientRole_Audience, withKey: nil)
//      Set up local session
        addLocalSession()
        
        // MARK: Join rtcEngine channel
        let successCode = rtcEngine.joinChannel(byKey: KeyCenter.AppId, channelName: roomId!, info: nil, uid: 0, joinSuccess: nil)
        
        // MARK: Success code: 0 when executed successfully, and return negative value when failed.
        if successCode == 0 {
            setIdleTimerActive(false)
            //  MARK: Join socket (also using observe NSNotif to get current username")
            SocketService.instance.joinChannel(username: "current username", owner: "sky", completion: { (success) in
                self.dismiss(animated: true, completion: nil)
            })
            
        } else {
            DispatchQueue.main.async(execute: {
                self.alert(string: "Join channel failed: \(successCode)")
            })
        }
    }
    
    
    
    // MARK:   leave channel
    func leaveChannel() {
        setIdleTimerActive(true)
        
        // Unbind the local video view
        //Leave the channel
        rtcEngine.setupLocalVideo(nil)
        rtcEngine.leaveChannel(nil)
       
        //Removes all video sessions from the array of VideoSessions
        videoSessions.removeAll()
        
        delegate?.watchVCNeedClose(self)
    }
    
}

// MARK: private EXtension of update UI due to different member detection
private extension WatchRoomViewController {
   
    func setIdleTimerActive(_ active: Bool) {
        UIApplication.shared.isIdleTimerDisabled = !active
    }
    
    func alert(string: String) {
        guard !string.isEmpty else {
            return
        }
        
        let alert = UIAlertController(title: nil, message: string, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

// MARK:  extension of watchRoomVC's UI
private extension WatchRoomViewController {
    func updateInterface(withAnimation animation: Bool) {
        if animation {
            UIView.animate(withDuration: 0.3, animations: { [weak self] in
                self?.updateInterface()
                self?.view.layoutIfNeeded()
            })
        } else {
            updateInterface()
        }
    }
    
    //   MARK: Remove??
    func updateInterface() {
        var displaySessions = videoSessions //# of video sessions (broadcasters) = # of display sessions for the view
        
        viewLayouter.layout(sessions: displaySessions, fullScreenSession: fullScreenSession, inContainer: remoteContainerView)
        setStreamType(forSessions: displaySessions, fullScreenSession: fullScreenSession)
    }
    
    func setStreamType(forSessions sessions: [VideoSession], fullScreenSession: VideoSession?) {
        if fullScreenSession != nil {
            for session in sessions {
                // If the videoSession is a fullscreenSession, choose to recieve high stream, the others to recieve the low stream
                rtcEngine.setRemoteVideoStream(UInt(session.uid), type: (session == fullScreenSession ? .videoStream_High : .videoStream_Low))
                
            }
        } else {
            for session in sessions {
                //.videoStream_High -> high resolution, high frame rate (based on videoProfile)
                rtcEngine.setRemoteVideoStream(UInt(session.uid), type: .videoStream_High)
            }
        }
    }
    
    // MARK: Set up the local video canvas
    func addLocalSession() {
        let localSession = VideoSession.localSession()
        videoSessions.append(localSession)
        rtcEngine.setupLocalVideo(localSession.canvas)
    }
    
    func fetchSession(ofUid uid: Int64) -> VideoSession? {
        for session in videoSessions {
            if session.uid == uid {
                return session
            }
        }
        return nil
    }
    
    func videoSession(ofUid uid: Int64) -> VideoSession {
        if let fetchedSession = fetchSession(ofUid: uid) {
            return fetchedSession
        } else {
            let newSession = VideoSession(uid: uid)
            videoSessions.append(newSession)
            return newSession
        }
    }
}

//MARK: Engine Delegate

extension WatchRoomViewController: AgoraRtcEngineDelegate {
    func rtcEngine(_ engine: AgoraRtcEngineKit, didJoinedOfUid uid: UInt, elapsed: Int) {
        let userSession = videoSession(ofUid: Int64(uid))
        //  MARK:  Set remote video view in rtcEngine callback
        rtcEngine.setupRemoteVideo(userSession.canvas)
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, firstLocalVideoFrameWith size: CGSize, elapsed: Int) {
        if let _ = videoSessions.first {
            updateInterface(withAnimation: false)
        }
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, didOfflineOfUid uid: UInt, reason: AgoraRtcUserOfflineReason) {
        var indexToDelete: Int?
        for (index, session) in videoSessions.enumerated() {
            if session.uid == Int64(uid) {
                indexToDelete = index
            }
        }
        
        if let indexToDelete = indexToDelete {
            let deletedSession = videoSessions.remove(at: indexToDelete)
            deletedSession.hostingView.removeFromSuperview()
            
            if deletedSession == fullScreenSession {
                fullScreenSession = nil
            }
        }
    }
    
    
}
