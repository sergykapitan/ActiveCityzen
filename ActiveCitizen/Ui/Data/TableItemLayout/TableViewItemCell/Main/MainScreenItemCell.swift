//
//  MainScreenItemCell.swift
//  ActiveCitizen
//
//  Created by Vladimir Vetrov on 06.08.2020.
//  Copyright © 2020 Novotorica. All rights reserved.
//

import Foundation
import UIKit

class MainScreenItemCell: AbstractTableViewCell {
    
    @IBOutlet weak var labelWelcomingCaption: UILabel!
    @IBOutlet weak var labelUserName: UILabel!
    @IBOutlet weak var labelSectionLeft: UILabel!
    @IBOutlet weak var labelSectionRight: UILabel!
    
    @IBOutlet weak var sectionRight: UIView!
    @IBOutlet weak var sectionLeft: UIView!
    
    var didTapSectionRightClosure: (() -> Void)?
    var didTapSectionLeftClosure: (() -> Void)?
    
    
    var item: MainScreenItem? {
        didSet {
            guard let item = item else {
                return
            }
            self.labelWelcomingCaption.text = item.preTitle
            self.labelUserName.text = item.title
            self.labelSectionLeft.text = item.sectionLeft
            self.labelSectionRight.text = item.sectionRight
        }
    }
    
    @objc func didTapSectionRight(_ sender: UITapGestureRecognizer? = nil) {
        didTapSectionRightClosure?()
    }
    @objc func didTapSectionLeft(_ sender: UITapGestureRecognizer? = nil) {
        didTapSectionLeftClosure?()
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.didTapSectionRight(_:)))
        tap.numberOfTapsRequired = 1
        self.sectionRight.addGestureRecognizer(tap)
        
        let tapLeft = UITapGestureRecognizer(target: self, action: #selector(self.didTapSectionLeft(_:)))
        tapLeft.numberOfTapsRequired = 1
        self.sectionLeft.addGestureRecognizer(tapLeft)
        
    }
}
