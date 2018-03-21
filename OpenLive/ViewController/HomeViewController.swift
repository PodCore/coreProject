//
//  ViewController.swift
//  Streaming
//
//  Created by Sky Xu on 1/11/18.
//  Copyright © 2018 Sky Xu. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
 
    var allRooms = [Room]()
    var popularVideos = [Room]()
    var newPopularVideos = [Room]() {
        didSet {
            self.collectionView.reloadData()
        }
    }
    
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
        //  trigger collecionViewFlowlayout delegate
        self.collectionView.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.popularVideos = LiveRoomData.instance.rooms
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        //        assign collectionView Dataspurce
        self.collectionViewDatasource.items = self.popularVideos + self.newPopularVideos
        self.collectionView.dataSource = self.collectionViewDatasource
        
        SocketService.instance.getNewChannel { (success, newRoom) in
            if success {
                self.newPopularVideos.append(newRoom)
                print(self.newPopularVideos)
            }
        }
     
        //     update Cell UI vy calling configureCell call back function
        collectionViewDatasource.configureCell = { [unowned self] (collectionView, indexPath) -> UICollectionViewCell in
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath) as! CollectionCell
            self.allRooms = self.popularVideos + self.newPopularVideos
            if self.allRooms.count != 0 {
                DispatchQueue.main.async {
                    cell.roomName.text = self.allRooms[indexPath.row].name
                    let roomImg = self.allRooms[indexPath.row].image
                    if roomImg == "empty"{
                        cell.img.loadImageFromUrlString(urlString: "https://www.pixelstalk.net/wp-content/uploads/2016/11/Entertainment-Desktop-Wallpaper.jpg")
                        print(cell.img.image)
                    } else {
                        let cellImg = CameraHandler.shared.convertBase64ToImgStr(encodedImgData: roomImg)
                        cell.img.image = cellImg
                    }
                    
                }
            }
            return cell
        }
    }
    
}

extension HomeViewController: UICollectionViewDelegate {
    //    go to watch VC when click on the cell
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyBoard = UIStoryboard.init(name: "WatchRoom", bundle: nil)
        let watchRoomVC = storyBoard.instantiateViewController(withIdentifier: "watchRoomVC") as! WatchRoomViewController
        watchRoomVC.roomId = self.allRooms[indexPath.row].id
        watchRoomVC.roomName = self.allRooms[indexPath.row].name
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


