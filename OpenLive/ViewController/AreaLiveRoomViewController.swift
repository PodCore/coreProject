//
//  AreaLiveRoomViewController.swift
//  OpenLive
//
//  Created by Sky Xu on 3/15/18.
//  Copyright © 2018 Agora. All rights reserved.
//

import UIKit

class AreaLiveRoomViewController: UIViewController {
    
    var roomTableDatasource = TableViewDataSource(items: [])
    var rooms = LiveRoomData.instance.rooms {
        didSet {
            self.tableView.reloadData()
        }
    }
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        roomTableDatasource.items = rooms
        self.tableView.dataSource = roomTableDatasource
        
        roomTableDatasource.configureCell = {(tableView, indexPath) -> UITableViewCell in
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! LocationLiveTableViewCell
            if self.rooms.count != 0 {
                DispatchQueue.main.async {
                    let roomImg = self.rooms[indexPath.row].image
                    if roomImg == "empty" {
                        cell.imgView.loadImageFromUrlString(urlString: "https://www.pixelstalk.net/wp-content/uploads/2016/11/Entertainment-Desktop-Wallpaper.jpg")
                    } else {
                        let cellImg = CameraHandler.shared.convertBase64ToImgStr(encodedImgData: roomImg)
                        cell.imgView.image = cellImg
                    }
                    cell.topicLabel.text = self.rooms[indexPath.row].topic
                }
            }
            return cell
        }
    }
    
}

extension AreaLiveRoomViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard.init(name: "WatchRoom", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "watchRoomVC") as! WatchRoomViewController
        vc.roomId = self.rooms[indexPath.row].id
        vc.roomName = self.rooms[indexPath.row].name
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
