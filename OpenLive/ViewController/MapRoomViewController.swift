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
    
    //    load base map first before add gradient layer on it
    override func loadView() {
        let camera = GMSCameraPosition.camera(withLatitude: -37, longitude: 145, zoom: 7)
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
        heatmapLayer.radius = 50
        heatmapLayer.opacity = 0.7
        heatmapLayer.gradient = GMUGradient(colors: gradientColors,
                                            startPoints: gradientStartPoints!,
                                            colorMapSize: 256)
        addHeatmap()
        heatmapLayer.map = mapView
    }
    
    
    func addHeatmap() {
        let locations = LiveRoomData.instance.locations
        var list = [GMUWeightedLatLng]()
        for l in locations {
            let coords = GMUWeightedLatLng(coordinate: l, intensity: 0.8)
            list.append(coords)
        }
        heatmapLayer.weightedData = list
        
    }
}
