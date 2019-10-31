import Foundation
import CoreLocation
import MapKit

struct LibraryFetchResponse: Codable {
    let locations: [LibraryWrapper]
}

struct LibraryWrapper: Codable {
    let data: Library
}

class Library: NSObject, Codable, MKAnnotation {
    
    // MARK:- Internal Properties
    
    let title: String?
    let address: String
    
    // MARK:- Private Properties
    
    private let position: String
    
    // MARK:- Computed Properties
    
    @objc var coordinate: CLLocationCoordinate2D {
        let latLong = position
            .components(separatedBy: ",")
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .map { Double($0) }
        
        guard latLong.count == 2,
            let lat = latLong[0],
            let long = latLong[1] else { return CLLocationCoordinate2D.init() }
        
        return CLLocationCoordinate2D(latitude: lat, longitude: long)
    }
    
    var hasValidCoordinates: Bool {
        return coordinate.latitude != 0 && coordinate.longitude != 0
    }
    
    // MARK:- Static Methods
    
    static func getLibraries(from jsonData: Data) -> [Library] {
        do {
            return try JSONDecoder().decode(LibraryFetchResponse.self, from: jsonData).locations.map { $0.data }
        } catch {
            print("Decoding error: \(error)")
            return []
        }
    }
}
