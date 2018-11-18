//
//  PageControlCell.swift
//  SlideViewControl
//
//  Created by Zhuoyu Li on 11/17/18.
//  Copyright © 2018 Zhuoyu Li. All rights reserved.
//

import UIKit

class SlideViewPageControlCell: UICollectionViewCell {
    public var text: String? {
        didSet {
            if let text = text {
                textLabel.text = text
            }
        }
    }
    
    var textLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()
    
    var indicatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .red
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(textLabel)
        addSubview(indicatorView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        textLabel.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        textLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 0).isActive = true
        textLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true
        textLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: 0).isActive = true
        indicatorView.leftAnchor.constraint(equalTo: leftAnchor, constant: 0).isActive = true
        indicatorView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4).isActive = true
        indicatorView.rightAnchor.constraint(equalTo: rightAnchor, constant: 0).isActive = true
        indicatorView.heightAnchor.constraint(equalToConstant: 4).isActive = true
    }
    
    func setHightlight(_ highlighted: Bool) {
        indicatorView.isHidden = !highlighted
    }
}
