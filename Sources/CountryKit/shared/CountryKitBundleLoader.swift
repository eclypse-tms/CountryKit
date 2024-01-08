//
//  CountryKitBundleLoader.swift
//  CountryKit
//
//  Created by eclypse on 12/13/23.
//

import Foundation

public protocol CountryKitBundleLoader: AnyObject {
    /// the main bundle
    var bundle: Bundle { get }
    
    /// You use this to retrieve a value from info.plist
    func getValueFromInfoDictionary(key: String) -> Any?
    
    /// returns the app version such as 1.4.3
    func getAppVersion() -> String?
    
    /// returns the build number
    func getBuildNumber() -> String?
    
    /// You use this to locate a file in the bundle
    func getPath(forResource: String, ofType: String) -> String?
    
    /// Returns the contents of a file in the bundle, optionally specify an encoding
    func getFileContents(fileName: String, fileExtension: String, encoding: String.Encoding?) -> String?
    
    /// Returns the file as data in the bundle, optionally specify an encoding
    func getFileAsData(fileName: String, fileExtension: String) -> Data?
    
}

open class CountryKitBundleLoaderImpl: CountryKitBundleLoader {
    open var bundle: Bundle
    open var fileManager: FileManager
    
    /// default initializer. there is generally no need to initialize the bundle loader any other way
    public init() {
        self.fileManager = FileManager.default
        self.bundle = CountryKit.assetBundle
    }
    
    /// only use this initializer if you need specific behaviors from the filemanager or the bundle
    public init(fileManager: FileManager, bundle: Bundle) {
        self.fileManager = fileManager
        self.bundle = bundle
    }
    
    open func getFileContents(fileName: String, fileExtension: String, encoding: String.Encoding?) -> String? {
        guard let validFilePath = getPath(forResource: fileName, ofType: fileExtension) else { return nil }
        if self.fileManager.fileExists(atPath: validFilePath),
            let rawData = fileManager.contents(atPath: validFilePath) {
            let encodingToUse = encoding ?? .utf8
            let fileContents = String(data: rawData, encoding: encodingToUse)
            return fileContents
        } else {
            return nil
        }
    }
    
    open func getFileAsData(fileName: String, fileExtension: String) -> Data? {
        guard let validFilePath = getPath(forResource: fileName, ofType: fileExtension) else { return nil }
        if self.fileManager.fileExists(atPath: validFilePath),
            let rawData = fileManager.contents(atPath: validFilePath) {
            return rawData
        } else {
            return nil
        }
    }
    
    open func getValueFromInfoDictionary(key: String) -> Any? {
        guard let dict = self.bundle.infoDictionary else { return nil }
        return dict[key]
    }
    
    open func getPath(forResource: String, ofType: String) -> String? {
        return bundle.path(forResource: forResource, ofType: ofType)
    }
    
    open func getAppVersion() -> String? {
        return getValueFromInfoDictionary(key: "CFBundleShortVersionString") as? String
    }
    
    open func getBuildNumber() -> String? {
        return getValueFromInfoDictionary(key: "CFBundleVersion") as? String
    }
}
