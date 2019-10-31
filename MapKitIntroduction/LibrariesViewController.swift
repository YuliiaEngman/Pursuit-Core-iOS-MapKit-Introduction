import UIKit
import MapKit
import CoreLocation

class LibrariesViewController: UIViewController {

    // MARK:- IBOutlets
    
    @IBOutlet var mapView: MKMapView!
    
    // MARK:- Private Properties
    
    private let locationManager = CLLocationManager()
    
    private var libraries = [Library]() {
        didSet {
            mapView.addAnnotations(libraries.filter { $0.hasValidCoordinates } )
        }
    }
    
    // MARK:- Lifecycle Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        requestLocationAndAuthorizeIfNeeded()
        mapView.userTrackingMode = .follow
        loadLibraries()
    }
    
    // MARK:- Private methods
    
    private func requestLocationAndAuthorizeIfNeeded() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.requestLocation()
        default:
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    private func loadLibraries() {
        libraries = Library.getLibraries(from: BundleManager.getDataFromBundle(withName: "BklynLibraryInfo", andType: "json"))
    }
}

// MARK:- CLLocationManagerDelegate Conformance

extension LibrariesViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("New locations \(locations)")
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("An error occurred: \(error)")
    }
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print("Authorization status changed to \(status.rawValue)")
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.requestLocation()
        default:
            break
        }
    }
}
