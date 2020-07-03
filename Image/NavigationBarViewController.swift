//
//  NavigationBarViewController.swift
//  Image
//
//  Created by Камиль Бакаев on 22.06.2020.
//  Copyright © 2020 Камиль Бакаев. All rights reserved.
//

import UIKit

class NavigationBarViewController: UIViewController {
    var regularConstraints = [NSLayoutConstraint]()
    var compactConstraints = [NSLayoutConstraint]()
    
    private var firstTime = true
    
    let navigationBar = UIView()
    
    override func viewWillLayoutSubviews() {
      super.viewWillLayoutSubviews()
      if firstTime {
        firstTime = false
        enableConstraintsForWidth(traitCollection.horizontalSizeClass)
      }
    }
    
    let shareButton: UIButton = {
        let button = UIButton.init(type: .system)
        button.isUserInteractionEnabled = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("1", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20)
        button.setTitleColor(UIColor.systemBlue, for: .normal)
        return button
    }()
    
    let moreButton: UIButton = {
        let button = UIButton.init(type: .system)
        button.isUserInteractionEnabled = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("2", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20)
        button.setTitleColor(UIColor.systemBlue, for: .normal)
        return button
    }()
    
    let sortButton: UIButton = {
        let button = UIButton.init(type: .system)
        button.isUserInteractionEnabled = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("2", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20)
        button.setTitleColor(UIColor.systemBlue, for: .normal)
        return button
    }()
    
    let filterButton: UIButton = {
        let button = UIButton.init(type: .system)
        button.isUserInteractionEnabled = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("3", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20)
        button.setTitleColor(UIColor.systemBlue, for: .normal)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.translatesAutoresizingMaskIntoConstraints = false
    }

    func createAndSetupNavigationBar() {
        
        navigationBar.isUserInteractionEnabled = true
        navigationBar.backgroundColor = .brown
        view.addSubview(navigationBar)
        navigationBar.addSubview(shareButton)
        shareButton.addTarget(self, action: #selector(share(_:)), for: .touchUpInside)
        moreButton.addTarget(self, action: #selector(showMore(_:)), for: .touchUpInside)
        sortButton.addTarget(self, action: #selector(sort(_:)), for: .touchUpInside)
        filterButton.addTarget(self, action: #selector(filter(_:)), for: .touchUpInside)
        
        compactConstraints.append(navigationBar.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 0))
        compactConstraints.append(navigationBar.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: 0))
        compactConstraints.append(navigationBar.topAnchor.constraint(equalTo: view.topAnchor, constant: 0))
        compactConstraints.append(navigationBar.heightAnchor.constraint(equalToConstant: 90))
        compactConstraints.append(moreButton.rightAnchor.constraint(equalTo: navigationBar.safeAreaLayoutGuide.rightAnchor, constant: -20))
        compactConstraints.append(moreButton.topAnchor.constraint(equalTo: navigationBar.safeAreaLayoutGuide.topAnchor, constant: 0))
        compactConstraints.append(shareButton.topAnchor.constraint(equalTo: navigationBar.safeAreaLayoutGuide.topAnchor, constant: 0))
        compactConstraints.append(shareButton.rightAnchor.constraint(equalTo: moreButton.rightAnchor, constant: -20))
        
        
        regularConstraints.append(navigationBar.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0))
        regularConstraints.append(navigationBar.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0))
        regularConstraints.append(navigationBar.topAnchor.constraint(equalTo: view.topAnchor, constant: 0))
        regularConstraints.append(navigationBar.heightAnchor.constraint(equalToConstant: 90))
        
        regularConstraints.append(filterButton.rightAnchor.constraint(equalTo: navigationBar.safeAreaLayoutGuide.rightAnchor, constant: -20))
        regularConstraints.append(filterButton.topAnchor.constraint(equalTo: navigationBar.safeAreaLayoutGuide.topAnchor, constant: 0))
        regularConstraints.append(sortButton.rightAnchor.constraint(equalTo: filterButton.rightAnchor, constant: -20))
        regularConstraints.append(sortButton.topAnchor.constraint(equalTo: navigationBar.safeAreaLayoutGuide.topAnchor, constant: 0))
        regularConstraints.append(shareButton.rightAnchor.constraint(equalTo: sortButton.rightAnchor, constant: -20))
        
        regularConstraints.append(shareButton.topAnchor.constraint(equalTo: navigationBar.safeAreaLayoutGuide.topAnchor, constant: 0))
        
        navigationBar.updateConstraints()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        createAndSetupNavigationBar()
    }
    
    private func enableConstraintsForWidth(_ horizontalSizeClass: UIUserInterfaceSizeClass) {
      if horizontalSizeClass == .regular {
        moreButton.removeFromSuperview()
        navigationBar.addSubview(sortButton)
        navigationBar.addSubview(filterButton)
        NSLayoutConstraint.deactivate(compactConstraints)
        NSLayoutConstraint.activate(regularConstraints)
      } else {
        navigationBar.addSubview(moreButton)
        sortButton.removeFromSuperview()
        filterButton.removeFromSuperview()
               
        NSLayoutConstraint.deactivate(regularConstraints)
        NSLayoutConstraint.activate(compactConstraints)
      }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if traitCollection.horizontalSizeClass != previousTraitCollection?.horizontalSizeClass {
          enableConstraintsForWidth(traitCollection.horizontalSizeClass)
        }
    }
    
    @objc func share(_ sender: UIButton) {
        print("share")
    }
    
    @objc func showMore(_ sender: UIButton) {
            let vc = MoreTableViewController()
            vc.modalPresentationStyle = .popover
            let popOverVC = vc.popoverPresentationController
            popOverVC?.delegate = self
            popOverVC?.sourceView = self.moreButton
            popOverVC?.sourceRect = CGRect(x: self.moreButton.bounds.midX, y: self.moreButton.bounds.minY, width: 0, height: 9)
            vc.preferredContentSize = CGSize(width: 200, height: 200)
            self.present(vc, animated: true)
    }
    
    @objc func sort(_ sender: UIButton) {
        print("sort")
    }
    
    @objc func filter(_ sender: UIButton) {
        print("filter")
    }
}

extension NavigationBarViewController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}
