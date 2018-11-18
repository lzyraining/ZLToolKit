//
//  SlideContentView.swift
//  SlideViewControl
//
//  Created by Zhuoyu Li on 11/17/18.
//  Copyright © 2018 Zhuoyu Li. All rights reserved.
//

import UIKit

protocol SlideContentViewDelegate {
    func willSlide(contentView: SlideContentView, direction: SlideContentView.SlideDirection)
    func didSlide(contentView: SlideContentView, direction: SlideContentView.SlideDirection)
}

class SlideContentView: UIView {
    
    enum SlideDirection {
        case left
        case right
    }
    
    var delegate: SlideContentViewDelegate?
    
    var contentView: UIView!
    var nextContentView: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(swipe(_:)))
        addGestureRecognizer(panGesture)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initContentView(_ view: UIView) {
        contentView = view
        addSubview(contentView)
        setContentView(contentView)
    }
    
    func setContentView(_ view: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        view.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        view.leftAnchor.constraint(equalTo: leftAnchor, constant: 0).isActive = true
        view.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true
        view.rightAnchor.constraint(equalTo: rightAnchor, constant: 0).isActive = true
    }
    
    @objc func swipe(_ gesture: UIPanGestureRecognizer) {
        let velocity = gesture.velocity(in: self)
        switch gesture.state {
        case .changed:
            self.delegate?.willSlide(contentView: self, direction: getSlideDirection(velocity))
        case .ended:
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: {
                self.delegate?.didSlide(contentView: self, direction: self.getSlideDirection(velocity))
                self.slideToNextView()
            })
        default:
            break
        }
    }
    
    func getSlideDirection(_ velocity: CGPoint) -> SlideDirection {
        return velocity.x > 0 ? .left : .right
    }
    
    func prepareNextSlideView(_ view: UIView) {
        self.nextContentView = view
    }
    
    func slideToNextView() {
        if let nextContentView = self.nextContentView {
            UIView.transition(from: self.contentView, to: nextContentView, duration: 0.2, options: [.curveEaseIn], completion: { (completed) in
                self.contentView = nextContentView
                self.setContentView(self.contentView)
                self.nextContentView = nil
            })
        }
    }
}
