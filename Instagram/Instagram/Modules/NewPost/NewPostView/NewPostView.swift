//
//  NewPostView.swift
//  Instagram
//
//  Created by Admin on 28.01.2021.
//

import UIKit

protocol NewPostViewDelegate: AnyObject {
    func newPostViewDidRequestCellMedia(_ newPostView: NewPostView)
    func newPostViewDidRequestOriginalMedia(_ newPostView: NewPostView, atIndex index: Int)
}

final class NewPostView: UIView {
    // MARK: Properties
    
    weak var delegate: NewPostViewDelegate? {
        didSet {
            delegate?.newPostViewDidRequestCellMedia(self)
        }
    }
    
    var selectedMediaFile: MediaFileType?
    
    private var mediaFiles = [MediaFileType]()
    private var selectedMediaFileIndex: Int?
    
    // MARK: Subviews
    
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    
    // MARK: Initialization
    
    init() {
        super.init(frame: .zero)
        
        setupAppearance()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Public Methods

extension NewPostView {    
    func appendCellMediaFile(_ mediaFile: MediaFileType) {
        mediaFiles.append(mediaFile)
        
        if selectedMediaFileIndex == nil {
            selectedMediaFileIndex = 0
            
            delegate?.newPostViewDidRequestOriginalMedia(self, atIndex: 0)
        }
        
        collectionView.reloadData()
    }
    
    func setOriginalMediaFile(_ mediaFile: MediaFileType) {
        if let headerView = collectionView.visibleSupplementaryViews(
            ofKind: UICollectionView.elementKindSectionHeader).first as? MediaCell {
            headerView.configure(withMediaFile: mediaFile)
        }
        
        selectedMediaFile = mediaFile
    }
}

// MARK: - Appearance

private extension NewPostView {
    func setupAppearance() {
        backgroundColor = .systemBackground
        
        setupCollectionViewAppearance()
    }
    
    func setupCollectionViewAppearance() {
        collectionView.backgroundColor = .clear
        collectionView.delaysContentTouches = false
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.register(MediaCell.self, forCellWithReuseIdentifier: MediaCell.reuseIdentifier)
        collectionView.register(
            MediaCell.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: MediaCell.reuseIdentifier)
    }
}

// MARK: - Layout

private extension NewPostView {
    func setupLayout() {
        setupSubviews()
        
        setupCollectionViewLayout()
    }
    
    func setupSubviews() {
        addSubview(collectionView)
    }
    
    func setupCollectionViewLayout() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
        ])
        
        collectionView.collectionViewLayout = NewPostView.createCollectionViewCompositionalLayout()
    }
}

// MARK: - Layout Helpers

private extension NewPostView {
    static func createCollectionViewCompositionalLayout() -> UICollectionViewCompositionalLayout {
        let itemLayoutSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalWidth(1 / CGFloat(NewPostConstants.Constants.columnsCount)))
        
        let item = NSCollectionLayoutItem(layoutSize: itemLayoutSize)
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: itemLayoutSize,
            subitem: item,
            count: NewPostConstants.Constants.columnsCount)
        
        group.interItemSpacing = .fixed(NewPostConstants.Metrics.gridCellSpace)
        
        let headerLayoutSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalWidth(1))
        
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerLayoutSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top)
        
        let section = NSCollectionLayoutSection(group: group)
        
        section.contentInsets = NSDirectionalEdgeInsets(
            top: NewPostConstants.Metrics.gridCellSpace,
            leading: 0,
            bottom: 0,
            trailing: 0)
        section.boundarySupplementaryItems = [sectionHeader]
        
        return UICollectionViewCompositionalLayout(section: section)
    }
}

// MARK: - UICollectionViewDataSource

extension NewPostView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mediaFiles.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: MediaCell.reuseIdentifier,
            for: indexPath) as? MediaCell
        else {
            return UICollectionViewCell()
        }
        
        cell.configure(withMediaFile: mediaFiles[indexPath.row])

        if let selectedMediaFileIndex = selectedMediaFileIndex, selectedMediaFileIndex == indexPath.row {
            cell.selectCell()
        } else {
            cell.deselectCell()
        }
        
        if indexPath.row == mediaFiles.count - 1 {
            delegate?.newPostViewDidRequestCellMedia(self)
        }
        
        return cell
    }

    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: MediaCell.reuseIdentifier,
            for: indexPath) as? MediaCell
        else {
            return UICollectionReusableView()
        }

        return header
    }
}

// MARK: - UICollectionViewDelegate

extension NewPostView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let previousSelectedMediaFileIndex = selectedMediaFileIndex
        
        selectedMediaFileIndex = indexPath.row
        
        if previousSelectedMediaFileIndex != selectedMediaFileIndex {
            setOriginalMediaFile(mediaFiles[indexPath.row])
            
            delegate?.newPostViewDidRequestOriginalMedia(self, atIndex: indexPath.row)
            
            if let previousSelectedMediaFileIndex = previousSelectedMediaFileIndex {
                let previousIndexPath = IndexPath(row: previousSelectedMediaFileIndex, section: 0)

                collectionView.reloadItems(at: [previousIndexPath])
            }

            collectionView.reloadItems(at: [indexPath])
        }
    }
}
