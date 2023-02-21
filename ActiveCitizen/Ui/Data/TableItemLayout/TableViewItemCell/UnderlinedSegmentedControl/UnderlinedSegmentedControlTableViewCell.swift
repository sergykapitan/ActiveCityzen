//
//  TableViewCell.swift
//  ActiveCitizen
//
//  Created by Vladimir Vetrov on 31.08.2020.
//  Copyright © 2020 Novotorica. All rights reserved.
//

import UIKit

class UnderlinedSegmentedControlTableViewCell: AbstractTableViewCell , CustomSegmentedControlDelegate{
    
    
    
    @IBOutlet weak var cusSegmentControll: CustomSegmentedControl! {
        didSet {
            cusSegmentControll.selectorViewColor = UIColor(hexString: "6181F2")
            cusSegmentControll.selectorTextColor = UIColor(hexString: "#6181F2")
          //  cusSegmentControll.setButtonTitles(buttonTitles: ["1", "2"])
        }
    }
    

//
//    @IBOutlet weak var customSegmentControll: CustomSegmentedControl! {
//        didSet {
//            customSegmentControll.selectorViewColor = .blue
//            customSegmentControll.selectorTextColor = .black
//            customSegmentControll.setButtonTitles(buttonTitles: ["1", "2"])
//        }
//    }
//
//
    
//    @IBOutlet weak var customSegmentControl: CustomSegmentedControl! {
//        didSet {
//            customSegmentControl.selectorViewColor = .blue
//            customSegmentControl.selectorTextColor = .black
//        }
//    }
    
   // @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    var arrSegment = [String]()
    
    var item: UnderlinedSegmentedControlTableItem? {
        didSet {
            guard let item = item else {  return  }
            if arrSegment.isEmpty {
                _ = item.controls.map { (sing) -> Void in
                    arrSegment.append(sing.title)
                }
                cusSegmentControll.setButtonTitles(buttonTitles: arrSegment)
            } else {
                print("arrSegment = \(arrSegment)")
            }
            cusSegmentControll.delegate = self
        }
    }
    
    func change(to index: Int) {
        item?.controls.first(where: { (singleElementControl) -> Bool in
            singleElementControl.position == index
        })?.onClick()
       }

    
    

//    var item: UnderlinedSegmentedControlTableItem? {
//        didSet {
//            guard let item = item else {  return  }
//            if segmentedControl.numberOfSegments == 0 {
//                _ = item.controls.map({ (singleElementControl) -> Void in
//                    segmentedControl.insertSegment(withTitle: singleElementControl.title,
//                                                   at: singleElementControl.position,
//                                                   animated: true)
//                })
//                self.segmentedControl.selectedSegmentIndex = 0
//
//
//            }
//            segmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged), for: .valueChanged)}
//    }
    
    
    @objc func segmentedControlValueChanged(segment: UISegmentedControl) {
        item?.controls.first(where: { (singleElementControl) -> Bool in
            singleElementControl.position == segment.selectedSegmentIndex
        })?.onClick()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
       // cusSegmentControll = nil
       // cusSegmentControll.willRemoveSubview(self)
        
       // cusSegmentControll.removeFromSuperview()
       // arrSegment = [String]()
        
        print("awakeFromNib")
        
        self.backgroundColor = UIColor(hexString: "#f5f5f5")
        self.selectionStyle = .none
       // setNeedsLayout()
       // layoutIfNeeded()
    }
    
}
