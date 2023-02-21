//
//  TableViewTypeFactoryDataSource.swift
//  ActiveCitizen
//
//  Created by Vladimir Vetrov on 11.08.2020.
//  Copyright © 2020 Novotorica. All rights reserved.
//

import UIKit

class TableViewTypeFactory {
    static func cellForTableViewItem(tableView: UITableView, item: AbstractTableViewItem)-> UITableViewCell {
        switch item.type {
        case .coloredFootersItem: do {
            if let cell = tableView.dequeueReusableCell(withIdentifier: ColoredFootersItemCell.identifier) as? ColoredFootersItemCell {
                cell.item = item as? ColoredFootersItem
                return cell}
            }
        case .welcomingScreenItem: do {
            if let cell = tableView.dequeueReusableCell(withIdentifier:  MainScreenItemCell.identifier) as? MainScreenItemCell {
                let mainScreenItem = item as? MainScreenItem
                cell.item = mainScreenItem
                cell.didTapSectionRightClosure = mainScreenItem?.onSectionRightClicked
                cell.didTapSectionLeftClosure = mainScreenItem?.onSectionLeftClickeds
                return cell
            }
            }
        case .imageLeftPreviewItem: do {
            if let cell = tableView.dequeueReusableCell(withIdentifier: ElementLeftImagePreviewCell.identifier) as? ElementLeftImagePreviewCell {
                cell.item = item as? ElementLeftImagePreviewItem
                return cell }
            }
        case .bigImageTitleFooter: do {
            if let cell = tableView.dequeueReusableCell(withIdentifier: BigImageTitleFooterTableViewCell.identifier) as? BigImageTitleFooterTableViewCell {
                cell.item = item as? BigImageTitleFooterItem
                return cell }
            }
            
        case .textBoxItem: do {
            if let cell = tableView.dequeueReusableCell(withIdentifier: TextBoxTableViewCell.identifier) as? TextBoxTableViewCell {
                cell.item = item as? TextBoxItem
                return cell }
            }
            
        case .horizontalLeftImageCollection: do {
            if let cell = tableView.dequeueReusableCell(withIdentifier:HorizontalLeftImagePreviewCollectionTableViewCell.identifier) as? HorizontalLeftImagePreviewCollectionTableViewCell {
                let horizontalLeftImageCollectionItem = item as? HorizontalLeftImageCollectionItem
                cell.item = horizontalLeftImageCollectionItem
                cell.didTapShowMoreClosure = horizontalLeftImageCollectionItem?.didTapShowAllClosure
                cell.layoutIfNeeded()
                return cell
            }
            }
            
        case .bigImageHorizontalSmallCardItem: do {
            if let cell = tableView.dequeueReusableCell(withIdentifier: BigImageHorizontalSmallCardTableCell.identifier) as? BigImageHorizontalSmallCardTableCell {
                cell.item = item as? BigImageHorizontalSmallCardTableItem
                return cell
            }
            }
        case .singleButton: do {
            if let cell = tableView.dequeueReusableCell(withIdentifier: SingleButtonTableViewCell.identifier) as? SingleButtonTableViewCell {
                cell.item = item as? SingleButtonItem
                cell.contentView.isUserInteractionEnabled = false
                return cell
            }
            }
        case .underlinedSegmentedControlTableItem: do {
            if let cell = tableView.dequeueReusableCell(withIdentifier: UnderlinedSegmentedControlTableViewCell.identifier) as? UnderlinedSegmentedControlTableViewCell {
                cell.item = item as? UnderlinedSegmentedControlTableItem
                return cell
            }
            }
            
        case .rightSmallClippedImage: do {
            if let cell = tableView.dequeueReusableCell(withIdentifier: RightSmallClippedImageTableViewCell.identifier) as? RightSmallClippedImageTableViewCell {
                cell.item = item as? RightSmallClippedImageItem
                return cell
            }
            }
        case .viewControllerHolder: do {
            if let cell = tableView.dequeueReusableCell(withIdentifier: ViewControllerHolderTableCell.identifier) as? ViewControllerHolderTableCell {
                cell.item = item as? ViewControllerHolderItem
                cell.contentView.isUserInteractionEnabled = false
                return cell
            }
            }
        
        case .badgeImageTitle: do {
            if let cell = tableView.dequeueReusableCell(withIdentifier: BigImageTitleBadgeTableViewCell.identifier) as? BigImageTitleBadgeTableViewCell {
                cell.item = item as? BadgeImageTitleItem
                return cell
            }
        }
        
        case .narrowImageItem: do {
            if let cell = tableView.dequeueReusableCell(withIdentifier: NarrowImageTableViewCell.identifier) as? NarrowImageTableViewCell {
                cell.item = item as? NarrowImageItem
                return cell
            }
        }
        case .expandableTextBox: do {
            if let cell = tableView.dequeueReusableCell(withIdentifier: ExpandableTextBoxTableViewCell.identifier) as? ExpandableTextBoxTableViewCell {
                    cell.item = item as? ExpandableTextBoxItem
                    return cell
            }
        }
        case .multilineSpannedTextBox: do {
            if let cell = tableView.dequeueReusableCell(withIdentifier: MultilineSpannedTextTableViewCell.identifier) as? MultilineSpannedTextTableViewCell {
                cell.item = item as? MultilineSpannedTextBoxItem
                return cell
            }
        }
        case .multilineColorfulRightFooter: do {
            if let cell = tableView.dequeueReusableCell(withIdentifier: MultilineColorfulRightFooterTableViewCell.identifier) as? MultilineColorfulRightFooterTableViewCell {
                cell.item = item as? MultilineColorfulRightFooterItem
                return cell
            }
        }
        case .titleBadgeChipFooter: do {
            if let cell = tableView.dequeueReusableCell(withIdentifier: TitleBadgeChipFooterTableViewCell.identifier) as? TitleBadgeChipFooterTableViewCell {
                cell.item = item as? TitleBadgeChipFooterItem
                return cell
            }
        }
        
        case .singleShortButtonImageItem: do {
            if let cell = tableView.dequeueReusableCell(withIdentifier: SingleShortButtonTableViewCell.identifier) as? SingleShortButtonTableViewCell {
                cell.item = item as? SingleShortButtonImageItem
                return cell
            }
        }
        
        case .empty: return UITableViewCell()
        }
        
        // Should not be a thing
        return UITableViewCell()
    }
}
