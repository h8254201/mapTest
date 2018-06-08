//
//  ViewController.swift
//  MapTest
//
//  Created by larvata_ios on 2018/6/7.
//  Copyright © 2018年 tony. All rights reserved.
//

import UIKit
import Alamofire
import GoogleMaps
import GooglePlaces
import GooglePlacePicker

class ViewController: UIViewController,GMSMapViewDelegate,CLLocationManagerDelegate {
  @IBOutlet weak var googleMapView: GMSMapView!
  var placesClient = GMSPlacesClient()
  var locationManager = CLLocationManager()
  var apiKey = "AIzaSyDH9y8n8SHTWhUTOxsNHuBfl7itmCuP3qE"
  var mark = GMSMarker()
  override func viewDidLoad() {
    super.viewDidLoad()



    let camera = GMSCameraPosition.camera(withLatitude: 25.0364162,
                                          longitude: 121.5654694,
                                          zoom: 12)

    Alamofire.request(URL(string: "https://maps.googleapis.com/maps/api/directions/json?origin=25.036411%2C121.565944&destination=25.041707%2C121.552012&waypoints=via:25.058559%2C121.557216&key=AIzaSyD5SoAx_IJviu9FzM1pMEifBrbAc5o2cDw")!).responseJSON { (response) in
      if let json = response.result.value {
        var dataArray = try? JSONSerialization.jsonObject(with: response.data!, options: .allowFragments) as! [String:Any]
        var routes = dataArray!["routes"] as! Array<[String:Any]>
        for route in routes{
          print(route["legs"])
        }
      }
    }

    //  https://maps.googleapis.com/maps/api/directions/json?origin=25.036411%2C121.565944&destination=25.041707%2C121.552012&waypoints=via:25.058559%2C121.557216&key=AIzaSyD5SoAx_IJviu9FzM1pMEifBrbAc5o2cDw
    let path = GMSMutablePath(fromEncodedPath: "s|xwCeg~dViHGwBCwBDOL?dAA~AE~De@EQBOAg@Iu@YaAe@gB}@g@i@qAs@sDkBwDkBoMwGgFkCeFiCsHwDoGiDOEa@@wAAq@BgEd@_Hx@yARyALqJ`A_CTmIx@FbBEJ@d@p@lTNxEA@E@GBSNOVCP?TBTDLNRJFB@DND\\HjCD`@FLFBBx@d@jNv@nV?TNCbAKzAOdIy@hEc@TETMhAs@fBeANKbBa@|Ac@|Aa@fBa@`@EBeBtIF|HLnD@`B@nEDt@?r@?DXJx@TtB^fDt@`HDz@F`CE~Ck@dKQxCL?Z@RqD\\gFvDBvDDhDG")
//    path.addLatitude(25.034271, longitude:121.565764) // Sydney
//    path.addLatitude(23.499504, longitude:120.536467) // Fiji

    let polyline = GMSPolyline(path: path)
    polyline.strokeColor = .red
    polyline.strokeWidth = 5.0
    polyline.map = googleMapView

    let mark = GMSMarker()
    mark.position = CLLocationCoordinate2D(latitude: 25.0364162, longitude: 121.5654694)
    mark.map = googleMapView

    let m = GMSMarker()
    m.position = CLLocationCoordinate2D(latitude: 34.0522342, longitude: -118.2436849)
    m.map = googleMapView

    googleMapView.mapType = .normal
    googleMapView.camera = camera

    googleMapView.delegate = self
    googleMapView.settings.myLocationButton = true

    self.locationManager.delegate = self
    self.locationManager.startUpdatingLocation()
    // Do any additional setup after loading the view, typically from a nib.
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    let location = locations.last
  }
  func mapView(_ mapView: GMSMapView, didTapPOIWithPlaceID placeID: String, name: String, location: CLLocationCoordinate2D) {
    print(location.latitude)
  }
  func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
//    let m = GMSMarker()
//    mark.position = CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
//    mark.map = googleMapView
  }
  func mapView(_ mapView: GMSMapView, didLongPressAt coordinate: CLLocationCoordinate2D) {
    mark.appearAnimation = .pop
    mark.position = CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
    mark.map = googleMapView
  }
}

