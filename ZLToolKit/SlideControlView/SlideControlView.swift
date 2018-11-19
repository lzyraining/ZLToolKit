//
//  SlideControlView.swift
//  SlideViewControl
//
//  Created by Zhuoyu Li on 11/17/18.
//  Copyright © 2018 Zhuoyu Li. All rights reserved.
//

import UIKit

public class SlideControlView: UIView {

    private static let pageControlCellId = "pageControlCell"
    private let pageControlHeight: CGFloat = 44
    private var pageTitles: [String] = [String]()
    private var contentViewControllers: [UIViewController]?
    private var preHighlightedIndex: Int = 0
    private var infiniteSlideEnabled: Bool = false
    
    lazy var contentView: SlideContentView = {
        let view = SlideContentView(frame: CGRect.zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.delegate = self
        return view
    }()
    
    lazy var pageControl: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.register(SlideViewPageControlCell.self, forCellWithReuseIdentifier: SlideControlView.pageControlCellId)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        addSubview(pageControl)
        addSubview(contentView)
    }
    
    override public func layoutSubviews() {
        pageControl.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        pageControl.leftAnchor.constraint(equalTo: leftAnchor, constant: 8).isActive = true
        pageControl.rightAnchor.constraint(equalTo: rightAnchor, constant: -8).isActive = true
        pageControl.heightAnchor.constraint(equalToConstant: pageControlHeight).isActive = true
        contentView.topAnchor.constraint(equalTo: pageControl.bottomAnchor, constant: 0).isActive = true
        contentView.leftAnchor.constraint(equalTo: leftAnchor, constant: 0).isActive = true
        contentView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true
        contentView.rightAnchor.constraint(equalTo: rightAnchor, constant: 0).isActive = true
    }
    
    
    public func setPageControlTitles(_ titles: [String]) {
        pageTitles = titles;
        DispatchQueue.main.async {
            self.pageControl.reloadData()
        }
    }
    
    public func setContentViewControllers(_ viewControllers: [UIViewController]) {
        contentViewControllers = viewControllers
        if let viewController = contentViewControllers, viewController.count > 0 {
            contentView.initContentView(viewController[0].view)
        }
    }
    
    public func setInfinteSliding(_ enable: Bool) {
        infiniteSlideEnabled = enable
    }
    
    func updateCurrentPage(_ index: Int) {
        let newIndexPath = IndexPath(row: index, section: 0)
        pageControl.scrollToItem(at: newIndexPath, at: .centeredHorizontally, animated: true)
        preHighlightedIndex = index
        pageControl.reloadData()
    }
}

extension SlideControlView: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pageTitles.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SlideControlView.pageControlCellId, for: indexPath) as? SlideViewPageControlCell {
            cell.text = pageTitles[indexPath.row]
            if preHighlightedIndex == indexPath.row {
                cell.setHightlight(true)
            } else {
                cell.setHightlight(false)
            }
            return cell
        }
        return UICollectionViewCell()
    }
}

extension SlideControlView: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        updateCurrentPage(indexPath.row)
        if let viewController = contentViewControllers?[indexPath.row] {
            contentView.prepareNextSlideView(viewController.view)
            contentView.slideToNextView()
        }
    }
}

extension SlideControlView: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.row < pageTitles.count {
            let data = pageTitles[indexPath.row]
            let size = data.size(withAttributes: [.font : UIFont.systemFont(ofSize:16.0)])
            return CGSize.init(width: size.width + 8, height: pageControlHeight)
        }
        return CGSize.zero
    }
}

extension SlideControlView: SlideContentViewDelegate {
    func willSlide(contentView: SlideContentView, direction: SlideContentView.SlideDirection) {
        if validateSlide(preHighlightedIndex, direction: direction) {
            if let nextIndex = getSlideNextIndex(direction), let viewController = contentViewControllers?[nextIndex] {
                contentView.prepareNextSlideView(viewController.view)
            }
        }
    }
    
    func didSlide(contentView: SlideContentView, direction: SlideContentView.SlideDirection) {
        if validateSlide(preHighlightedIndex, direction: direction), let nextIndex = getSlideNextIndex(direction) {
            updateCurrentPage(nextIndex)
        }
    }
    
    private func getSlideNextIndex(_ direction: SlideContentView.SlideDirection) -> Int? {
        switch direction {
        case .left:
            if preHighlightedIndex > 0 {
                return preHighlightedIndex - 1
            } else {
                return pageTitles.count - 1
            }
        case .right:
            if preHighlightedIndex < pageTitles.count - 1 {
                return preHighlightedIndex + 1
            } else {
                return 0
            }
        case .none:
            return nil
        }
    }
    
    private func validateSlide(_ currentIndex: Int, direction: SlideContentView.SlideDirection) -> Bool{
        if !infiniteSlideEnabled {
            if preHighlightedIndex == pageTitles.count - 1 && direction == .right {
                return false
            }
            if preHighlightedIndex == 0 && direction == .left {
                return false
            }
            return true
        }
        return true
    }
}
