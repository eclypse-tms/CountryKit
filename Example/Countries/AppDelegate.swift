//
//  AppDelegate.swift
//  Countries
//
//  Created by eclypse on 12/11/23.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        print("locale,regioncode,region,language,script")
        Locale.availableIdentifiers
            .compactMap({ eachIdentifier -> LocaleComponents? in
                let components = eachIdentifier.components(separatedBy: "_")
                switch components.count {
                case 0:
                    fatalError("components(separatedBy:) function should always return at least 1 component")
                case 1:
                    //it must be the language component only (skip this not useful)
                    return nil //LocaleComponents(identifier: eachIdentifier, languageCode: components[0], languageScript: nil, regionCode: nil)
                case 2:
                    //the components could be either language and script or
                    //language and country/region code
                    //script codes are always 4 digit
                    if components[1].count == 4 {
                        //language and script combo (skip this not useful)
                        return nil //LocaleComponents(identifier: eachIdentifier, languageCode: components[0], languageScript: components[1], regionCode: nil)
                    } else {
                        let regionCode = components[1]
                        if let validInteger = Int(regionCode) {
                            //this is a continent or world
                            return nil
                        } else {
                            //language and country/region combo
                            return LocaleComponents(identifier: eachIdentifier, languageCode: components[0], languageScript: nil, regionCode: components[1])
                        }
                    }
                case 3:
                    return LocaleComponents(identifier: eachIdentifier, languageCode: components[0], languageScript: components[1], regionCode: components[2])
                default:
                    fatalError("was not expecting to have a locale identifier with more than 3 components")
                }
            })
            .sorted(by: { lhs, rhs -> Bool in
                return lhs.regionCode < rhs.regionCode
            })
            
            .forEach { eachLocaleComponent in
                
                let validLocale = Locale(identifier: eachLocaleComponent.identifier)
                let p1 = eachLocaleComponent.identifier
                let p2 = "\(validLocale.regionCode ?? "--")"
                let p3: String
                if let englishNameForRegionCode = Locale.current.localizedString(forRegionCode: eachLocaleComponent.regionCode) {
                    p3 = englishNameForRegionCode
                } else {
                    p3 = "--"
                }
                
                let p4: String
                if let englishNameForLanguage = Locale.current.localizedString(forLanguageCode: eachLocaleComponent.languageCode) {
                    p4 = englishNameForLanguage
                } else {
                    p4 = "--"
                }
                
                let p6: String
                if let validScript = eachLocaleComponent.languageScript, let englishNameForScriptCode = Locale.current.localizedString(forScriptCode: validScript) {
                    p6 = englishNameForScriptCode
                } else {
                    p6 = "--"
                }
                
                
                
                let parts: [String] = [p1, p2, p3, p4, p6]
                print(parts.joined(separator: ","))
            }
        
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

