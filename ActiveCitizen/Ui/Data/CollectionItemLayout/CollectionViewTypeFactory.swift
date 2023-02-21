//
//  CollectionViewTypeFactory.swift
//  ActiveCitizen
//
//  Created by Vladimir Vetrov on 26.08.2020.
//  Copyright © 2020 Novotorica. All rights reserved.
//

import UIKit

class CollectionViewTypeFactory {
    static func cellForCollectionViewItem(collectionView: UICollectionView,
                                          indexPath: IndexPath,item: AbstractCollectionViewItem)-> UICollectionViewCell {
        switch item.type {
            
        case .imageLeftPreviewItem: do {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LeftImagePreviewCollectionViewCell.identifier, for: indexPath) as? LeftImagePreviewCollectionViewCell {
                cell.item = item as? ElementLeftImagePreviewCollectionItem
                return cell
            }
            }
        case .smallCardCollection: do {
            
            }
        case .croppedRightImageChip: do {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CroppedRightImageChipCollectionViewCell.identifier, for: indexPath) as? CroppedRightImageChipCollectionViewCell {
                cell.item = item as? CroppedRightImageChipItem
                return cell
            }
            }
        default:
            return UICollectionViewCell()
        }
        //Should not be a thing
        return UICollectionViewCell()
    }
}
