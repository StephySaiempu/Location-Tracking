//
//  LocationViewModel.swift
//  Telyport_Assignment
//
//  Created by Girira Stephy on 14/02/21.
//

import UIKit
import Firebase
import CoreLocation


class LocationViewModel: NSObject {
    
    private var locationManager: CLLocationManager?
    var ref: DatabaseReference!
    var myCurrentLocation: CLLocationCoordinate2D?
    var updatingLocationValue : CLLocationCoordinate2D?
    weak var delegate: UpdateLocationProtocol?
    
    convenience init(delegateValue: UpdateLocationProtocol) {
        self.init()
        self.delegate = delegateValue
        ref = Database.database().reference()
        getUserLocation()
        addFireBaseObservers()
        getTimedLocation()
    }
    
    func getTime() -> String{
            let now = Date()
            let format = "EEE, dd MMM yyyy HH:mm:ss zzz"
            let dateFormatter = DateFormatter.init()
            dateFormatter.timeZone = TimeZone.current
            dateFormatter.dateFormat = format
            return dateFormatter.string(from: now)
        }
        
        func getDateString() -> String {
            let now = Date()
            let format = "dd MMM yyyy"
            let dateFormatter = DateFormatter.init()
            dateFormatter.timeZone = TimeZone.current
            dateFormatter.dateFormat = format
            return dateFormatter.string(from: now)
        }
        
        func getTimedLocation(){
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(30), execute: { [weak self] in
                guard let unwrappedLocation = self?.updatingLocationValue else { return }
                self?.updateDatabase(value: unwrappedLocation)
                self?.getTimedLocation()
            })
        }
        
        func updateDatabase(value: CLLocationCoordinate2D) {
            
            var modelValue = [String: Any]()
            modelValue["latitude"] = value.latitude
            modelValue["longitude"] = value.longitude
            modelValue["time"] = getTime()
            self.ref.child(getDateString()).child("location").childByAutoId().setValue(modelValue)
        }
        
        
        func addFireBaseObservers(){
            ref.child(getDateString()).child("location").queryOrderedByKey().queryLimited(toLast: 1).observe(.value) { [weak self] (snapshot) in
                guard let unwrappedSnapshot = snapshot.value as? [String: Any] else {
                    self?.delegate?.updateTime("")
                    return
                }
                let keyValue = Array(unwrappedSnapshot.keys)[0]
                guard let timeValue = unwrappedSnapshot[keyValue] as? [String: Any] else{ return }
                self?.delegate?.updateTime(timeValue["time"] as? String ?? "")
            }
            
            ref.child(getDateString()).child("location").queryOrderedByKey().observe(.value) { [weak self] (snapshot) in
                guard let unwrappedSnapshot = snapshot.value as? [String: Any] else {
                    self?.delegate?.updateLocationCount("No values")
                    return
                }
                print("Count Value : \(unwrappedSnapshot.keys.count)")
                self?.delegate?.updateLocationCount("No. of Uploads: \(unwrappedSnapshot.keys.count)")
               
            }
        }
    
    func getUserLocation() {
            locationManager = CLLocationManager()
            
            switch locationManager?.authorizationStatus {
            case .denied , .restricted:
                delegate?.presentError("Oh no!", subHeading: "Please allow location \"Always\" for better experience")
                break
            case .notDetermined:
                // Ask for Authorisation from the User.
                self.locationManager?.requestAlwaysAuthorization()
                // For use in foreground
                self.locationManager?.requestWhenInUseAuthorization()
                break
            default:
                break
            }
            if CLLocationManager.locationServicesEnabled() {
                locationManager?.delegate = self
                locationManager?.desiredAccuracy = kCLLocationAccuracyBest
                locationManager?.startUpdatingLocation()
                locationManager?.allowsBackgroundLocationUpdates = true
            }
        }
    
}


extension LocationViewModel: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        self.updatingLocationValue = locValue
        guard let unwrappedLocation = myCurrentLocation else {
            myCurrentLocation = locValue
            return
        }
        //get distance between locValue and myCurrentLocation
        let currentCoordinates = CLLocation(latitude: locValue.latitude, longitude: locValue.longitude)
        let previousCoordinates = CLLocation(latitude: unwrappedLocation.latitude, longitude: unwrappedLocation.longitude)
        let distance = currentCoordinates.distance(from: previousCoordinates)
        print("Distance Value : \(distance.magnitude)")
        
        //if this is greater than 200
        if distance.magnitude > 200 {
            //UPLOAD Location to CLoud DB
           myCurrentLocation = locValue
            self.updateDatabase(value: locValue)
        }
        
    }
}




