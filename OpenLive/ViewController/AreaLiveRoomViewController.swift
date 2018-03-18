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
    let rooms = LiveRoomData.instance.rooms
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        roomTableDatasource.items = rooms
        self.tableView.dataSource = roomTableDatasource
        
        roomTableDatasource.configureCell = {(tableView, indexPath) -> UITableViewCell in
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! LocationLiveTableViewCell
            if self.rooms.count != 0 {
                DispatchQueue.main.async {
                    cell.imgView.loadImageFromUrlString(urlString: self.rooms[indexPath.row].image)
                    cell.topicLabel.text = self.rooms[indexPath.row].topic
                }
            }
            return cell
        }
    }
    
}

extension AreaLiveRoomViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "watchRoomVC") as! WatchRoomViewController
        vc.roomId = self.rooms[indexPath.row].id
        vc.roomName = self.rooms[indexPath.row].name
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
