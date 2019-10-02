//
//  ViewController.swift
//  Training 4 Maps
//
//  Created by yudha on 02/10/19.
//  Copyright © 2019 yudha. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var lblJarak: UILabel!
    @IBOutlet weak var lblWaktu: UILabel!
    
    var gps = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        
        gps.delegate = self
        gps.startUpdatingLocation()
        gps.requestLocation()
        gps.requestWhenInUseAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let latTujuan = locations.last?.coordinate.latitude
        let longTujuan = locations.last?.coordinate.longitude
        
        //tentukan latlong asal dan latlong tujuan
        let asal = CLLocationCoordinate2D(latitude: -6.2074111, longitude: 106.7952495)
        let tujuan = CLLocationCoordinate2D(latitude: latTujuan!, longitude: longTujuan!)
        
        //untuk create marker
        let pinAsal = MKPointAnnotation()
        pinAsal.title = "Lokasi Anda Saat Ini"
        pinAsal.coordinate = asal
        
        let pinTujuan = MKPointAnnotation()
        pinTujuan.title = "Stasiun Palmerah"
        pinTujuan.coordinate = tujuan
        
        //tampilkan marker
        mapView.showAnnotations([pinAsal, pinTujuan], animated: true)
        
        //convert coordinate ke placemarker
        let tempatAsal = MKPlacemark(coordinate: asal)
        let tempatTujuan = MKPlacemark(coordinate: tujuan)
        
        //convert dari placemark ke mapItem
        let itemAsal = MKMapItem(placemark: tempatAsal)
        let itemTujuan = MKMapItem(placemark: tempatTujuan)
        
        //item ke direction request
        let mkRequest = MKDirections.Request()
        mkRequest.source = itemAsal
        mkRequest.destination = itemTujuan
        mkRequest.transportType = .automobile
        
        //hitung jarak
        let direction = MKDirections(request: mkRequest)
        direction.calculate { (getRoute, error) in
            
            let jarak = getRoute?.routes[0].distance
            let waktu = getRoute?.routes[0].expectedTravelTime
            let route = getRoute?.routes[0].polyline
            
            self.lblJarak.text = String(jarak!)
            self.lblWaktu.text = String(waktu!)
            
            self.mapView.addOverlay(route!, level: .aboveRoads)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error")
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let gambarRute = MKPolylineRenderer(overlay: overlay)
        gambarRute.lineWidth = 3
        gambarRute.strokeColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
        return gambarRute
    }
}

