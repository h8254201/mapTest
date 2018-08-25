//
//  ViewController.swift
//  MapTest
//
//  Created by larvata_ios on 2018/6/7.
//  Copyright © 2018年 tony. All rights reserved.
//

import UIKit
import Alamofire
import SideMenu
import GoogleMaps
import GooglePlaces
import GooglePlacePicker

protocol ViewControllerDelegate {
    func reloadRoute(placesTableViewController:PlacesTableViewController)
    func showPlace(place:GMSPlace)
}

class ViewController: UIViewController,GMSMapViewDelegate,CLLocationManagerDelegate,UITextFieldDelegate,ViewControllerDelegate {
    func showPlace(place: GMSPlace) {
//        let camera = self.googleMapView.camera(for: place.viewport!, insets:UIEdgeInsets())!
//        self.googleMapView.camera = camera
//        print(place.name)
//        self.delay(seconds: 0.5, closure: {
//            self.googleMapView.animate(with: GMSCameraUpdate.setTarget((place.coordinate)))
//        })
        
        let visibleRegion = self.googleMapView.projection.visibleRegion()
        
        var testPath = GMSMutablePath()
        testPath.add(visibleRegion.farLeft)
        testPath.add(visibleRegion.nearRight)
        var testPolyline = GMSPolyline(path: testPath)
        testPolyline.strokeColor = .blue
        testPolyline.strokeWidth = 5.0
        testPolyline.map = self.googleMapView

        let bounds = GMSCoordinateBounds(coordinate: visibleRegion.farLeft, coordinate: visibleRegion.nearRight)

        
        let filter = GMSAutocompleteFilter()
        filter.type = .noFilter
     
        
        
    }
    
    @IBOutlet weak var googleMapView: GMSMapView!
    @IBOutlet weak var wherePlaceTxt: UITextField!
    var polyline = GMSPolyline()
    var path  = GMSPath()
    var placesClient = GMSPlacesClient()
    var locationManager = CLLocationManager()
    var mark = GMSMarker()
    var apiKey = "AIzaSyDH9y8n8SHTWhUTOxsNHuBfl7itmCuP3qE"
    override func viewDidLoad() {
        super.viewDidLoad()
        let button = UIButton(type: .custom)
        button.setImage(#imageLiteral(resourceName: "icons8-menu-50"), for: .normal)
        button.imageEdgeInsets = UIEdgeInsetsMake(0, 8, 0, 0)
        button.frame = CGRect(x: 0, y: 0, width: 40, height: 30)
        button.addTarget(self, action: #selector(self.showSideMenu(_:)), for: .touchUpInside)
        wherePlaceTxt.leftView = button
        wherePlaceTxt.leftViewMode = .always
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let navc = storyboard.instantiateViewController(withIdentifier: "leftSide") as! UISideMenuNavigationController
        SideMenuManager.default.menuWidth = UIScreen.main.bounds.size.width / 2
        SideMenuManager.default.menuPresentingViewControllerUserInteractionEnabled = true
        SideMenuManager.default.menuLeftNavigationController = navc
        
        wherePlaceTxt.delegate = self
        wherePlaceTxt.returnKeyType = .search
        wherePlaceTxt.clearButtonMode = .whileEditing
        
        self.placesClient = GMSPlacesClient.shared()
        
        
//
//        Alamofire.request(URL(string: "https://maps.googleapis.com/maps/api/directions/json?origin=25.036411%2C121.565944&destination=25.041707%2C121.552012&waypoints=via:25.058559%2C121.557216&key=AIzaSyD5SoAx_IJviu9FzM1pMEifBrbAc5o2cDw")!).responseJSON { (response) in
//            if let json = response.result.value {
//                var dataArray = try? JSONSerialization.jsonObject(with: response.data!, options: .allowFragments) as! [String:Any]
//                var routes = dataArray!["routes"] as! Array<[String:Any]>
//                for route in routes{
//                    print(route["legs"])
//                }
//            }
//        }
//
//        //  https://maps.googleapis.com/maps/api/directions/json?origin=25.036411%2C121.565944&destination=25.041707%2C121.552012&waypoints=via:25.058559%2C121.557216&key=AIzaSyD5SoAx_IJviu9FzM1pMEifBrbAc5o2cDw
//        let path = GMSMutablePath(fromEncodedPath: "s|xwCeg~dViHGwBCwBDOL?dAA~AE~De@EQBOAg@Iu@YaAe@gB}@g@i@qAs@sDkBwDkBoMwGgFkCeFiCsHwDoGiDOEa@@wAAq@BgEd@_Hx@yARyALqJ`A_CTmIx@FbBEJ@d@p@lTNxEA@E@GBSNOVCP?TBTDLNRJFB@DND\\HjCD`@FLFBBx@d@jNv@nV?TNCbAKzAOdIy@hEc@TETMhAs@fBeANKbBa@|Ac@|Aa@fBa@`@EBeBtIF|HLnD@`B@nEDt@?r@?DXJx@TtB^fDt@`HDz@F`CE~Ck@dKQxCL?Z@RqD\\gFvDBvDDhDG")
//        //    path.addLatitude(25.034271, longitude:121.565764) // Sydney
//        //    path.addLatitude(23.499504, longitude:120.536467) // Fiji
//
//        let polyline = GMSPolyline(path: path)
//        polyline.strokeColor = .red
//        polyline.strokeWidth = 5.0
//        polyline.map = googleMapView
//
//        let mark = GMSMarker()
//        mark.position = CLLocationCoordinate2D(latitude: 25.0364162, longitude: 121.5654694)
//        mark.map = googleMapView
//
//        let m = GMSMarker()
//        m.position = CLLocationCoordinate2D(latitude: 34.0522342, longitude: -118.2436849)
//        m.map = googleMapView
//
//        googleMapView.mapType = .normal
//        googleMapView.camera = camera
//
//        googleMapView.delegate = self
//        googleMapView.settings.myLocationButton = true
//
//        self.locationManager.delegate = self
//        self.locationManager.startUpdatingLocation()
        // Do any additional setup after loading the view, typically from a nib.
    }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    addBottomSheetView()
  }
  
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func reloadRoute(placesTableViewController: PlacesTableViewController) {
        Alamofire.request(getRouteURL(places: placesTableViewController.places)).responseJSON { (response) in
            if let json = response.result.value {
                var dataArray = try? JSONSerialization.jsonObject(with: response.data!, options: .allowFragments) as! [String:Any]
                self.googleMapView.clear()
                
                
                
                
                
                var routes = dataArray!["routes"] as! Array<[String:Any]>
                var overviewPolyline = routes[0]["overview_polyline"] as! [String:Any]
                var points = overviewPolyline["points"] as! String
                self.path = GMSMutablePath(fromEncodedPath: points)!
                self.polyline = GMSPolyline(path: self.path)
                self.polyline.strokeColor = .red
                self.polyline.strokeWidth = 5.0
                self.polyline.map = self.googleMapView
                

                for route in routes{
                    print(route["legs"])
                }
            }
        }

    }
    @IBAction func showSideMenu(_ sender: Any) {
        if SideMenuManager.default.menuLeftNavigationController?.isHidden == true{
            if let leftNavi = SideMenuManager.default.menuLeftNavigationController{
                var leftVC = leftNavi.topViewController as? PlacesTableViewController
                leftVC?.delegate = self
                present(leftNavi, animated: true, completion: nil)
            }
            
        }else{
            dismiss(animated: true, completion: nil)
        }
        
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        if textField.text != ""{
            placeAutocomplete(place: textField.text!)
        }
        return true
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
    func placeAutocomplete(place:String) {
        let filter = GMSAutocompleteFilter()
        filter.type = .noFilter
        
        placesClient.autocompleteQuery(place, bounds: nil, filter: filter, callback: {(results, error) -> Void in
            if let error = error {
                print("Autocomplete error \(error)")
                return
            }
            if let results = results {
                self.placesClient.lookUpPlaceID(results[0].placeID!, callback: { (place, erroe) in
//                    let camera = GMSCameraPosition.camera(withLatitude:(place?.coordinate.latitude)! ,longitude: (place?.coordinate.longitude)!,zoom: 5)
                    var bounds = place?.viewport
                    let camera = self.googleMapView.camera(for: bounds!, insets:UIEdgeInsets())!
                    self.googleMapView.camera = camera
                    print(place?.name)
                    self.delay(seconds: 0.5, closure: {
                        self.googleMapView.animate(with: GMSCameraUpdate.setTarget((place?.coordinate)!))
                        
                    })
                })
                
            }
        })
        
    }
    func delay(seconds: Double, closure: @escaping () -> ()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            closure()
        }
    }
    func getRouteURL(places : Array<GMSPlace>) -> URL{
        let urlString = "https://maps.googleapis.com/maps/api/directions/json?"
        var origin = "origin="
        var destination = "destination="
        var wayPoint = "waypoints="
        for placeIndex in 0...places.count - 1{
            let place = places[placeIndex]
            if placeIndex == 0{
                origin.append(place.coordinate.latitude.description + "%2C" + place.coordinate.longitude.description + "&")
            }else if placeIndex == places.count - 1{
                destination.append(place.coordinate.latitude.description + "%2C" + place.coordinate.longitude.description + "&")
            }else{
                if placeIndex != places.count - 2{
                    wayPoint.append("via:" + place.coordinate.latitude.description + "%2C" + place.coordinate.longitude.description + "%7C")
                }else{
                    wayPoint.append("via:" + place.coordinate.latitude.description + "%2C" + place.coordinate.longitude.description + "&")
                }
                
            }
        }
        let key = "key=" + self.apiKey
        var url = URL(string: "")
        if places.count == 2{
            url = URL(string: urlString + origin + destination + key)
        }else{
            url = URL(string: urlString + origin + destination + wayPoint + key)
        }
        
        return url!
    }
  func addBottomSheetView() {
    // 1- Init bottomSheetVC
    let bottomSheetVC = BottomSheetViewController()
    
    // 2- Add bottomSheetVC as a child view
    self.addChildViewController(bottomSheetVC)
    self.view.addSubview(bottomSheetVC.view)
    bottomSheetVC.didMove(toParentViewController: self)
    
    // 3- Adjust bottomSheet frame and initial position.
    let height = view.frame.height
    let width  = view.frame.width
    bottomSheetVC.view.frame = CGRect(x: 0, y: self.view.frame.maxY, width: width, height: height)
  }
}


//extension ViewController : GMSAutocompleteResultsViewControllerDelegate{
//    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
//                           didAutocompleteWith place: GMSPlace) {
//        // Do something with the selected place.
//
//        print("Place name: \(place.name)")
//        print("Place address: \(place.formattedAddress)")
//        print("Place attributions: \(place.attributions)")
//    }
//
//    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
//                           didFailAutocompleteWithError error: Error){
//        // TODO: handle the error.
//        print("Error: ", error.localizedDescription)
//    }
//
//    // Turn the network activity indicator on and off again.
//    func didRequestAutocompletePredictions(forResultsController resultsController: GMSAutocompleteResultsViewController) {
//        UIApplication.shared.isNetworkActivityIndicatorVisible = true
//    }
//
//    func didUpdateAutocompletePredictions(forResultsController resultsController: GMSAutocompleteResultsViewController) {
//        UIApplication.shared.isNetworkActivityIndicatorVisible = false
//    }
//}
