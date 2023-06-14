//
//  YESApp.swift
//  YES
//
//  Created by Alberto Ruiz on 1/6/23.
//

import SwiftUI
@main
struct YESApp: App {
    init(){
        if let settingsBundle = Bundle.main.url(forResource: "Settings", withExtension: "bundle"),
            let settings = NSDictionary(contentsOf: settingsBundle.appendingPathComponent("Root.plist")),
            let preferences = settings.object(forKey: "PreferenceSpecifiers") as? [[String: Any]] {
                
            var defaultValues = [String: Any]()
            
            for preference in preferences {
                if let key = preference["Key"] as? String,
                    let defaultValue = preference["DefaultValue"] {
                    
                    defaultValues[key] = defaultValue
                }
            }
            
            UserDefaults.standard.register(defaults: defaultValues)
            UserDefaults.standard.synchronize()
        }
    }
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                loginView()
            }
        }
    }
}
