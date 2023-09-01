//
//  LKGalleryView.swift
//  STYLiSH
//
//  Created by WU CHIH WEI on 2019/3/2.
//  Copyright © 2019 AppWorks School. All rights reserved.
//

import UIKit

protocol LKGalleryViewDelegate: AnyObject {
    func sizeForItem(_ galleryView: LKGalleryView) -> CGSize
}

class LKGalleryView: UIView, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    weak var delegate: LKGalleryViewDelegate? {
        didSet {
            collectionView.dataSource = self
            collectionView.delegate = self
            collectionView.reloadData()
        }
    }

    private lazy var collectionView: UICollectionView = {
        let layoutObject = UICollectionViewFlowLayout()
        layoutObject.minimumInteritemSpacing = 0
        layoutObject.minimumLineSpacing = 0
        layoutObject.itemSize = bounds.size
        layoutObject.sectionInset = UIEdgeInsets.zero
        layoutObject.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(
            frame: CGRect.zero,
            collectionViewLayout: layoutObject
        )
        collectionView.register(
            LKGalleryViewCell.self,
            forCellWithReuseIdentifier: String(describing: LKGalleryViewCell.self)
        )
        collectionView.backgroundColor = .white
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()

    private lazy var pageControl: UIPageControl = {
        let control = UIPageControl()
        control.numberOfPages = datas.count
        control.pageIndicatorTintColor = .black
        control.currentPageIndicatorTintColor = .white
        return control
    }()

    var datas: [String] = [] {
        didSet {
            collectionView.reloadData()
            pageControl.numberOfPages = datas.count
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initView()
    }

    private func initView() {
        backgroundColor = .white
        stickSubView(collectionView)
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        addSubview(pageControl)
        pageControl.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16.0).isActive = true
        pageControl.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.0).isActive = true
    }

    // MARK: - UICollectionViewDataSource
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return datas.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: String(describing: LKGalleryViewCell.self),
            for: indexPath
        )
        guard let galleryCell = cell as? LKGalleryViewCell else { return cell }
        galleryCell.galleryImg.loadImage(datas[indexPath.row], placeHolder: .asset(.Image_Placeholder))
        return galleryCell
    }

    // MARK: - UICollectionViewDelegateFlowLayout
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        return delegate?.sizeForItem(self) ?? bounds.size
    }

    func collectionView(
        _ collectionView: UICollectionView,
        willDisplay cell: UICollectionViewCell,
        forItemAt indexPath: IndexPath
    ) {
        pageControl.currentPage = indexPath.row
    }
}

private class LKGalleryViewCell: UICollectionViewCell {

    let galleryImg = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initView()
    }

    private func initView() {
        stickSubView(galleryImg)
        galleryImg.contentMode = .scaleAspectFill
        galleryImg.clipsToBounds = true
    }
}
