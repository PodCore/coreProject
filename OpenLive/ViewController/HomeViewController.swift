//
//  ViewController.swift
//  Streaming
//
//  Created by Sky Xu on 1/11/18.
//  Copyright © 2018 Sky Xu. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
//    reload data when fetch rooms from server
    var popularVideos = [Room]()
//    {
//        didSet {
//            collectionView.reloadData()
//        }
//    }
    
    let collectionViewDatasource = CollectionViewDatasource(items: [])
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBAction func hostButtonTapped(_ sender: UIButton) {
//        if AuthService.instance.isLoggedIn {
//            print("CREATE ROOM")
            let storyBoard = UIStoryboard.init(name: "CreateRoom", bundle: nil)
            let createRoomVC = storyBoard.instantiateViewController(withIdentifier: "createRoomVC") as! CreateRoomViewController
            self.navigationController?.pushViewController(createRoomVC, animated: true)
//        } else {
//            print("REGISTER")
//            let storyBoard = UIStoryboard.init(name: "Register", bundle: nil)
//            let registerVC = storyBoard.instantiateViewController(withIdentifier: "registerVC") as! RegisterViewController
//            self.navigationController?.pushViewController(registerVC, animated: true)
//        }
    }
    
 
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.collectionViewDatasource.items = popularVideos
        self.collectionView.dataSource = self.collectionViewDatasource
        //  trigger collecionViewFlowlayout delegate
        self.collectionView.delegate = self

        //     update Cell UI vy calling configureCell call back function
        collectionViewDatasource.configureCell = { (collectionView, indexPath) -> UICollectionViewCell in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath) as! CollectionCell
                if self.popularVideos.count != 0 {
                    DispatchQueue.main.async {
                    cell.roomName.text = self.popularVideos[indexPath.row].name
//                    cell.img.loadImageFromUrlString(urlString: self.popularVideos[indexPath.row].image)
                    }
                }

            return cell
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        SocketService.instance.observeIfConnected { (payload, ack) in
//            it keeps being called, maybe that's why only one text is displayed on view?
            SocketService.instance.getChannel { (success, rooms) in
                if success {
                    self.popularVideos = rooms
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                    }
                }
            }
        }
        //        MARK: get new rooms after we load this VC!
        SocketService.instance.getNewChannel { (success, newRoom) in
            self.popularVideos.append(newRoom)
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
}

extension HomeViewController: UICollectionViewDelegate {
//    go to watch VC when click on the cell
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyBoard = UIStoryboard.init(name: "WatchRoom", bundle: nil)
        let watchRoomVC = storyBoard.instantiateViewController(withIdentifier: "watchRoomVC") as! WatchRoomViewController
        watchRoomVC.roomId = self.popularVideos[indexPath.row].id
        watchRoomVC.roomName = self.popularVideos[indexPath.row].name
        self.navigationController?.pushViewController(watchRoomVC, animated: true)
    }
}

// first section of collection view to be across the width of the screen, the rests be halves of width
extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = CGFloat(250)
        let width: CGFloat
        let section = indexPath.section
        switch (section) {
        case (0):
            width = self.collectionView.bounds.size.width - 20
        case (1):
            width = (self.collectionView.bounds.size.width - 40) / 2
        default:
            width = 250
        }
        
        return CGSize(width: width, height: height)
    }
}

