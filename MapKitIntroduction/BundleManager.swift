import Foundation

struct BundleManager {
    static func getDataFromBundle(withName name: String, andType type: String) -> Data {
        guard let pathToData = Bundle.main.path(forResource: name, ofType: type) else {
            fatalError("\(name).\(type) file not found")
        }
        let internalUrl = URL(fileURLWithPath: pathToData)
        do {
            let data = try Data(contentsOf: internalUrl)
            return data
        }
        catch {
            fatalError("An error occurred: \(error)")
        }
    }
}
