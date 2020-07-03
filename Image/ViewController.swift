//
//  ViewController.swift
//  Image
//
//  Created by Камиль Бакаев on 22.06.2020.
//  Copyright © 2020 Камиль Бакаев. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var collectionViewController = ImageCollectionViewController(collectionViewLayout: UICollectionViewFlowLayout())

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let navigationController = NavigationBarViewController()
                view.addSubview(navigationController.view)
                addChild(navigationController)
                navigationController.didMove(toParent: self)
                navigationController.view.translatesAutoresizingMaskIntoConstraints = false
                navigationController.view.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
                navigationController.view.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
                navigationController.view.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
                navigationController.view.heightAnchor.constraint(equalToConstant: 90).isActive = true
                collectionViewController.view.backgroundColor = .cyan

                view.addSubview(collectionViewController.view)
                addChild(collectionViewController)
                collectionViewController.view.translatesAutoresizingMaskIntoConstraints = false
        collectionViewController.view.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
                collectionViewController.view.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
                collectionViewController.view.topAnchor.constraint(equalTo: navigationController.view.bottomAnchor, constant: 0).isActive = true
                collectionViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
                
                
                collectionViewController.didMove(toParent: self)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        self.collectionViewController.collectionViewLayout.invalidateLayout()

        super.viewWillTransition(to: size, with: coordinator)
    }
}

