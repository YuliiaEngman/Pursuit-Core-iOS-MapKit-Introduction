import XCTest
@testable import MapKitIntroduction

class MapKitIntroductionTests: XCTestCase {

    func testLibraryGetLibrariesFrom() {
        // Arrange
        
        let libraryJson = BundleManager.getDataFromBundle(withName: "BklynLibraryInfo", andType: "json")
        
        // Act
        
        let libraries = Library.getLibraries(from: libraryJson)
        
        // Assert
        
        XCTAssertEqual(libraries.count, 59, "Was expecting 59 libraries, but found \(libraries.count)")
    }    
}
