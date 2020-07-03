//
//  AppDelegate.swift
//  Image
//
//  Created by Камиль Бакаев on 22.06.2020.
//  Copyright © 2020 Камиль Бакаев. All rights reserved.
//

import UIKit
import CoreLogic

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        loadToken()
        return true
    }
    
    func loadToken() {
        let session = URLSession(configuration: .default)
        let networkManager = NetworkManager(session: session)
        let tokenLoader = HTTPTokenLoader(httpCLient: networkManager)
        tokenLoader.auth() { result in
            switch result {
            case let .success(token):
                AuthHTTPClient.token = token
            case let .failure(error):
                print(error)
            }
        }
    }

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }


}

