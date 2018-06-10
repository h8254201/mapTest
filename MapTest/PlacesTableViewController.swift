//
//  RouteTableViewController.swift
//  MapTest
//
//  Created by Swifty on 2018/6/10.
//  Copyright © 2018年 tony. All rights reserved.
//

import UIKit
import GooglePlaces

class PlacesTableViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate {
    @IBOutlet weak var placesTableView: UITableView!
    var delegate : ViewControllerDelegate?
    var placesClient = GMSPlacesClient()
    var places = Array<GMSPlace>()
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        placesTableView.delegate = self
        placesTableView.dataSource = self
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if places.count == 0{
            return 1
        }else{
            return places.count + 1
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PlacesTableViewCell
        let row = indexPath.row
        cell.placeNameTxt.text = ""
        if row >= places.count{
            cell.numberLbl.text = "#" + (row + 1).description
            cell.placeNameTxt.placeholder = "Enter your place"
        }else{
            let place = places[row]
            cell.numberLbl.text = "#" + (row + 1).description
            cell.placeNameTxt.text = place.name
        }
        cell.placeNameTxt.clearButtonMode = .always
        cell.placeNameTxt.tag = row
        cell.placeNameTxt.delegate = self
        cell.deleteBt.tag = row
        cell.deleteBt.addTarget(self, action: #selector(self.deletePlace(_:)), for: .touchUpInside)
        return cell
    }
    @objc func deletePlace(_ sender: UIButton){
        if sender.tag < places.count - 1{
            places.remove(at: sender.tag)
            if self.places.count >= 2{
                self.delegate?.reloadRoute(placesTableViewController: self)
            }
            self.placesTableView.reloadData()
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        if textField.text != ""{
            placeAutocomplete(place: textField.text!, row: textField.tag)
        }
        return true
    }
    func placeAutocomplete(place:String,row:Int) {
        let filter = GMSAutocompleteFilter()
        filter.type = .noFilter
        
        placesClient.autocompleteQuery(place, bounds: nil, filter: filter, callback: {(results, error) -> Void in
            if let error = error {
                print("Autocomplete error \(error)")
                return
            }
            if let results = results {
                self.placesClient.lookUpPlaceID(results[0].placeID!, callback: { (place, erroe) in
                    if row >= self.places.count{
                        self.places.append(place!)
                    }else{
                        self.places[row] = place!
                    }
                    self.placesTableView.reloadData()
                    if self.places.count >= 2{
                        self.delegate?.reloadRoute(placesTableViewController: self)
                    }
                })
                
            }
        })
    }
}
class PlacesTableViewCell:UITableViewCell{
    @IBOutlet weak var numberLbl: UILabel!
    @IBOutlet weak var placeNameTxt: UITextField!
    @IBOutlet weak var deleteBt: UIButton!
}
