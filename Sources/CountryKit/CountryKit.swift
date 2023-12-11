import Foundation

public class CountryKit {
    public private(set) var name = "CountryKit"
    
    public static var assetBundle: Bundle {
        get {
            #if SWIFT_PACKAGE
            return Bundle.module
            #else
            return Bundle(for: CountryKit.self)
            #endif
        }
    }
}
