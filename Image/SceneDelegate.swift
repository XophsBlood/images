//
//  SceneDelegate.swift
//  Image
//
//  Created by Камиль Бакаев on 22.06.2020.
//  Copyright © 2020 Камиль Бакаев. All rights reserved.
//

import UIKit
import CoreLogic

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let scene = (scene as? UIWindowScene) else { return }
        
        let session = URLSession(configuration: .default)
        let networkManager = NetworkManager(session: session)
        let tokenLoader = HTTPTokenLoader(httpCLient: networkManager)
        let authClient = AuthHTTPClient(networkManager: networkManager, tokenLoader: tokenLoader)
        
        let store = Store()
        let localImageDataLoader = LocalImageDataLoader(store: store)
        let imagesLoader = HTTPImagesLoader(httpCLient: authClient, localImageDataLoader: localImageDataLoader)
        let alwaysFail = AlwaysFail()
        let imagesFeedLoaderCompositor = ImagesFeedLoaderCompositor(imagesLoader: alwaysFail, localImageDataLoader: localImageDataLoader)
        let imageDataLoader = HTTPImageDataLoader(httpCLient: networkManager, localImageDataLoader: localImageDataLoader)
        let imageDataLoaderCompositor = ImageDataLoaderCompositor(imageDataLoader: imageDataLoader, localImageDataLoader: localImageDataLoader)
        window = UIWindow(windowScene: scene)
        window?.rootViewController = ImageUIComposer.makeViewController(imagesLoader: imagesFeedLoaderCompositor, imageDataLoader: imageDataLoaderCompositor)
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

