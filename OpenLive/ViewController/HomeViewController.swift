//
//  ViewController.swift
//  Streaming
//
//  Created by Sky Xu on 1/11/18.
//  Copyright © 2018 Sky Xu. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
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
        
//        // present alertVC when load the view
//        let storyboard = UIStoryboard.init(name: "CustomAlertView", bundle: nil)
//        let alertVC = storyboard.instantiateViewController(withIdentifier: "customAlertVC") as! CustomAlertView
//        alertVC.modalPresentationStyle = .overCurrentContext
//        alertVC.modalTransitionStyle = .crossDissolve
//        self.present(alertVC, animated: false, completion: nil)
        //  Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
//        SocketService.instance.observeIfConnected { (payload, ack) in
//            SocketService.instance.getChannel { (success, rooms) in
//                if success {
//                    self.popularVideos = rooms
//                    DispatchQueue.main.async {
//                        self.collectionView.reloadData()
//                    }
//                    // remove alertVC when connected to socket and got all rooms
//                    alertVC.alertLogo.stopAnimating()
//                    alertVC.dismiss(animated: true, completion: nil)
//                }
//            }
//            
//        }
        //        assign collectionView Dataspurce
        self.collectionViewDatasource.items = self.popularVideos + self.newPopularVideos
        self.collectionView.dataSource = self.collectionViewDatasource
        
        //     update Cell UI vy calling configureCell call back function
        collectionViewDatasource.configureCell = { (collectionView, indexPath) -> UICollectionViewCell in
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath) as! CollectionCell
            if self.popularVideos.count != 0 {
                DispatchQueue.main.async {
                    cell.roomName.text = self.popularVideos[indexPath.row].name
//                    let cellImg = self.convertBase64ToImgStr(encodedImgData: self.popularVideos[indexPath.row].image)
//                    cell.img.image = cellImg
                    cell.img.loadImageFromUrlString(urlString: "https://www.gettyimages.com/gi-resources/images/Embed/new/embed2.jpg")
                }
            }
            return cell
        }
    }
    
    //    convert img data we fetched from server to UIImage
    func convertBase64ToImgStr(encodedImgData: String) -> UIImage {
        let imgData = NSData(base64Encoded: encodedImgData, options: .ignoreUnknownCharacters) as Data?
        var image: UIImage!
        if let imgData = imgData {
            image = UIImage(data: imgData)
        }
        return image!
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


