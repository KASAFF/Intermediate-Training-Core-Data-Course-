//
//  UIViewController+Helpers.swift
//  IntermediateTraining
//
//  Created by Aleksey Kosov on 10.01.2023.
//

import UIKit

extension UIViewController {

    func setupPlusButtonInNavBar(selector: Selector) {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "plus"), style: .plain, target: self, action: selector)
    }

    func setupCancelButton() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancelModal))
    }

    @objc func handleCancelModal() {
        dismiss(animated: true)
    }

    func setupLightBlueBackgroundView(height: CGFloat) {

            let lightBlueBackgroundView = UIView()
            view.addSubview(lightBlueBackgroundView)
            lightBlueBackgroundView.backgroundColor = .lightBlue
            lightBlueBackgroundView.translatesAutoresizingMaskIntoConstraints = false
            lightBlueBackgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
            lightBlueBackgroundView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
            lightBlueBackgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
            lightBlueBackgroundView.heightAnchor.constraint(equalToConstant: height).isActive = true
    }
}
