//  MapRoomViewController.swift
//  OpenLive
//
//  Created by Sky Xu on 3/14/18.
//  Copyright © 2018 Agora. All rights reserved.
//

import UIKit
import GoogleMaps

class MapRoomViewController: UIViewController, GMUClusterManagerDelegate, GMSMapViewDelegate {
//    private var heatmapLayer: GMUHeatmapTileLayer!
    private var clusterManager: GMUClusterManager!
    private var mapView: GMSMapView!
    
    private var gradientColors = [UIColor.green, UIColor.red]
    private var gradientStartPoints = [0.2, 1.0] as? [NSNumber]
    let locations = LiveRoomData.instance.locations
    let currentUserLocation = LocationService.shared.currentLocation
    
    //    load base map first before add gradient layer on it
    override func loadView() {
//        show the part that user's at first and allow them to zoom out 
        let camera = GMSCameraPosition.camera(withLatitude: (currentUserLocation?.coordinate.latitude)!, longitude: (currentUserLocation?.coordinate.longitude)!, zoom: 7)
        mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        self.view = mapView

        mapView.settings.tiltGestures = false
        mapView.settings.rotateGestures = false
        mapView.settings.zoomGestures = true
        mapView.settings.scrollGestures = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let iconGenerator = GMUDefaultClusterIconGenerator()
        let renderer = GMUDefaultClusterRenderer(mapView: mapView, clusterIconGenerator: iconGenerator)
        clusterManager = GMUClusterManager(map: mapView, algorithm: GMUNonHierarchicalDistanceBasedAlgorithm(), renderer: renderer)
        
        // Generate and add random items to the cluster manager.
        generateClusterItems()

        // Call cluster() after items have been added to perform the clustering
        // and rendering on map.
        clusterManager.cluster()
        
        //        REGISTER SELF TO LISTEN TO BOTH CLUSGER MANAGER AND GMAP MANAGER
        clusterManager.setDelegate(self, mapDelegate: self)
    }
    
//    cluster manager delegate
//    private func clusterManager(clusterManager: GMUClusterManager, didTapCluster cluster: GMUCluster) {
//        
//         enterWatchRoom()
//    }
    func clusterManager(_ clusterManager: GMUClusterManager, didTap cluster: GMUCluster) -> Bool {
//        let newCam = GMSCameraPosition.camera(withTarget: cluster.position, zoom: mapView.camera.zoom + 1)
//        let update = GMSCameraUpdate.setCamera(newCam)
//        mapView.moveCamera(update)

        enterWatchRoom()
        return true

    }
    
    // MARK: - GMUMapViewDelegate
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        if let item = marker.userData as? ClusterItem {
            enterWatchRoom()
            NSLog("Did tap marker for cluster item \(item.name)")
        } else {
            NSLog("Did tap a normal marker")
        }
        return false
    }
    
    private func generateClusterItems() {
         for l in self.locations {
            let item = ClusterItem(position: l, name: "cluster")
            clusterManager.add(item)
        }
    }
    
    func convertLocationToPoint(location: [CLLocationCoordinate2D], completion: @escaping ([CGPoint], Bool) -> Void) {
        let points = location.map{ mapView.projection.point(for: $0) }
        completion(points, true)
    }
    
    func createAnnotatePoint(location: [CLLocationCoordinate2D], superView: UIView) {
        convertLocationToPoint(location: location) { (pointLocations, success) in
            if success {
                for loca in pointLocations {
                    let view = UIImageView()
                    view.image = UIImage(named: "gift-1")
                    view.frame.size = CGSize(width: 45, height: 45)
                    view.center = loca
                    DispatchQueue.main.async {
                        superView.addSubview(view)
                    }
                }
            }
        }
    }
    
    func enterWatchRoom() {
        let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
        let watchRoomVC = storyBoard.instantiateViewController(withIdentifier: "areaVC") as! AreaLiveRoomViewController
        let allRooms = LiveRoomData.instance.rooms
//        watchRoomVC.roomId = allRooms[indexPath.row].id
//        watchRoomVC.roomName = allRooms[indexPath.row].name
        self.navigationController?.pushViewController(watchRoomVC, animated: true)
    }
}
