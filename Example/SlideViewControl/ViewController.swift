//
//  ViewController.swift
//  SlideViewControl
//
//  Created by Zhuoyu Li on 11/17/18.
//  Copyright © 2018 Zhuoyu Li. All rights reserved.
//

import UIKit
import ZLToolKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let slideView = SlideControlView(frame: CGRect.zero)
        slideView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(slideView)
        slideView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        slideView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        slideView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        slideView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        slideView.setPageControlTitles(["OneOneOneOne", "TwoTwoTwoTwo", "ThreeThreeThree", "FourFourFourFour"])
        let viewController1 = UIViewController()
        viewController1.view.backgroundColor = .yellow
        let viewController2 = UIViewController()
        viewController2.view.backgroundColor = .red
        let viewController3 = UIViewController()
        viewController3.view.backgroundColor = .blue
        let viewController4 = UIViewController()
        viewController4.view.backgroundColor = .green
        slideView.setContentViewControllers([viewController1, viewController2, viewController3, viewController4])
        slideView.setInfinteSliding(true)
    }


}

