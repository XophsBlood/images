//
//  ViewController.swift
//  Image
//
//  Created by Камиль Бакаев on 22.06.2020.
//  Copyright © 2020 Камиль Бакаев. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let navigationController = NavigationBarViewController()
        view.addSubview(navigationController.view)
        addChild(navigationController)
        navigationController.didMove(toParent: self)
        
        print("_-----------------")
        
        let collectionViewController = ImageCollectionViewController(collectionViewLayout: UICollectionViewFlowLayout())
        collectionViewController.view.backgroundColor = .cyan
        collectionViewController.view.frame = CGRect(x: 0, y: navigationController.view.bounds.height, width: view.bounds.width, height: view.bounds.height - navigationController.view.bounds.height)
        view.addSubview(collectionViewController.view)
        addChild(collectionViewController)
        collectionViewController.didMove(toParent: self)
        
        print(collectionViewController.view.frame)
        print(view.subviews)
        // Do any additional setup after loading the view.
    }


}

