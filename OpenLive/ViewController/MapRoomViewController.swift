//
//  MapRoomViewController.swift
//  OpenLive
//
//  Created by Sky Xu on 3/14/18.
//  Copyright © 2018 Agora. All rights reserved.
//

import UIKit
import GoogleMaps

class MapRoomViewController: UIViewController, GMSMapViewDelegate {
    private var heatmapLayer: GMUHeatmapTileLayer!
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
        mapView.delegate = self
        self.view = mapView
        mapView.settings.tiltGestures = false
        mapView.settings.rotateGestures = false
        mapView.settings.zoomGestures = true
        mapView.settings.scrollGestures = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        heatmapLayer = GMUHeatmapTileLayer()
        //        we can change radius based on the ratio of liverom in this area/all liverooms( KEEP IT WITHIN 50)
        heatmapLayer.radius = 55
        heatmapLayer.opacity = 0.7
        heatmapLayer.gradient = GMUGradient(colors: gradientColors,
                                            startPoints: gradientStartPoints!,
                                            colorMapSize: 256)
        addHeatmap()
        heatmapLayer.map = mapView
        
        createAnnotatePoint(location: self.locations, superView: mapView)
    }
    
    
    func addHeatmap() {
        var list = [GMUWeightedLatLng]()
        for l in self.locations {
            let coords = GMUWeightedLatLng(coordinate: l, intensity: 0.8)
            list.append(coords)
        }
        heatmapLayer.weightedData = list
        
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
        let storyBoard = UIStoryboard.init(name: "WatchRoom", bundle: nil)
        let watchRoomVC = storyBoard.instantiateViewController(withIdentifier: "areaVC") as! AreaLiveRoomViewController
        let allRooms = LiveRoomData.instance.rooms
//        watchRoomVC.roomId = allRooms[indexPath.row].id
//        watchRoomVC.roomName = allRooms[indexPath.row].name
        self.navigationController?.pushViewController(watchRoomVC, animated: true)
    }
}
