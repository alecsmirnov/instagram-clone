//
//  NewPostHeaderView.swift
//  Instagram
//
//  Created by Admin on 05.02.2021.
//

import UIKit

final class NewPostHeaderView: UICollectionReusableView {
    // MARK: Properties
    
    static var reuseIdentifier: String {
        return String(describing: self)
    }
    
    private var isSizeToFit = true
    
    // MARK: Subviews
    
    private let adjustButton = UIButton(type: .system)
    private let scrollView = UIScrollView()
    private let imageView = UIImageView()
    
    // MARK: Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupAppearance()
        setupLayout()
        setupActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Public Methods

extension NewPostHeaderView {
    func configure(with mediaFile: MediaFileType) {
        switch mediaFile {
        case .image(let image):
            setImage(image)
        }
    }
}

// MARK: - Private Methods

private extension NewPostHeaderView {
    func setImage(_ image: UIImage) {
        imageView.image = image
        
        setScrollViewContentScale(size: image.size)
        scrollViewContentToCenter()
    }

    func setScrollViewContentScale(size: CGSize) {
        let horizontalRatio = scrollView.bounds.width / size.width
        let verticalRatio = scrollView.bounds.height / size.height

        let aspectRatioScale = isSizeToFit ?
            min(horizontalRatio, verticalRatio) :
            max(horizontalRatio, verticalRatio)

        scrollView.minimumZoomScale = aspectRatioScale
        scrollView.maximumZoomScale = scrollView.minimumZoomScale * 10

        scrollView.zoomScale = scrollView.minimumZoomScale
        
        layoutIfNeeded()
    }
    
    func scrollViewContentToCenter() {
        if isSizeToFit {
            scrollViewZoomToCenter()
        } else {
            scrollViewToCenter()
        }
    }
    
    func scrollViewZoomToCenter() {
        guard let imageSize = imageView.image?.size else { return }

        if imageSize.width < imageSize.height {
            if scrollView.contentSize.width < scrollView.bounds.width {
                scrollViewToCenterX()
            }
        } else {
            if scrollView.contentSize.height < scrollView.bounds.height {
                scrollViewToCenterY()
            }
        }
    }
    
    func scrollViewToCenter() {
        scrollViewToCenterX()
        scrollViewToCenterY()
    }
    
    func scrollViewToCenterX() {
        let xOffset = (scrollView.contentSize.width - scrollView.bounds.width) / 2
        
        scrollView.contentOffset.x = xOffset
    }
    
    func scrollViewToCenterY() {
        let yOffset = (scrollView.contentSize.height - scrollView.bounds.height) / 2
        
        scrollView.contentOffset.y = yOffset
    }
}

// MARK: - Appearance

private extension NewPostHeaderView {
    func setupAppearance() {
        setupAdjustButtonAppearance()
        setupScrollViewAppearance()
    }
    
    func setupAdjustButtonAppearance() {
        adjustButton.setImage(
            NewPostConstants.Images.adjustButton?.withRenderingMode(.alwaysOriginal),
            for: .normal)
        adjustButton.alpha = NewPostConstants.Constants.adjustButtonAlpha
        adjustButton.contentVerticalAlignment = .fill
        adjustButton.contentHorizontalAlignment = .fill
    }
    
    func setupScrollViewAppearance() {
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.alwaysBounceVertical = true
        scrollView.alwaysBounceHorizontal = true
        scrollView.isMultipleTouchEnabled = false
        
        scrollView.delegate = self
    }
}

// MARK: - Layout

private extension NewPostHeaderView {
    func setupLayout() {
        setupSubviews()
        
        setupAdjustButtonLayout()
        setupScrollViewLayout()
        setupImageViewLayout()
    }
    
    func setupSubviews() {
        addSubview(scrollView)
        addSubview(adjustButton)
        
        scrollView.addSubview(imageView)
    }
    
    func setupAdjustButtonLayout() {
        adjustButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            adjustButton.bottomAnchor.constraint(
                equalTo: safeAreaLayoutGuide.bottomAnchor,
                constant: -NewPostConstants.Metrics.adjustButtonSpace),
            adjustButton.leadingAnchor.constraint(
                equalTo: safeAreaLayoutGuide.leadingAnchor,
                constant: NewPostConstants.Metrics.adjustButtonSpace),
            adjustButton.heightAnchor.constraint(equalToConstant: NewPostConstants.Metrics.adjustButtonSize),
            adjustButton.widthAnchor.constraint(equalToConstant: NewPostConstants.Metrics.adjustButtonSize),
        ])
    }
    
    func setupScrollViewLayout() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
        ])
    }
    
    func setupImageViewLayout() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
        ])
    }
}

// MARK: - Actions

private extension NewPostHeaderView {
    func setupActions() {
        adjustButton.addTarget(self, action: #selector(didPressAdjustButton), for: .touchUpInside)
    }
    
    @objc func didPressAdjustButton() {
        guard let imageSize = imageView.image?.size else { return }
        
        isSizeToFit.toggle()
        
        setScrollViewContentScale(size: imageSize)
        scrollViewContentToCenter()
    }
}

// MARK: - UIScrollViewDelegate

extension NewPostHeaderView: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        scrollViewZoomToCenter()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollViewZoomToCenter()
    }
}
