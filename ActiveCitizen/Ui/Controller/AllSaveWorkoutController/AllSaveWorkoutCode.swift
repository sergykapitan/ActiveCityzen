//
//  AllSaveWorkoutCode.swift
//  ActiveCitizen
//
//  Created by Sergey on 17.02.2021.
//  Copyright © 2021 Novotorica. All rights reserved.
//

import UIKit

final class AllSaveWorkoutCode: UIView {

    //MARK: - First layer in TopView    
    let cardView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.961, green: 0.961, blue: 0.961, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
        }()
    var tableView: UITableView = {
        let table = UITableView()
        table.separatorStyle = .none
        table.backgroundColor = UIColor(red: 0.961, green: 0.961, blue: 0.961, alpha: 1)
        return table
    }()
    //MARK: - initial
    override init(frame: CGRect) {
        super.init(frame: frame)
        createCardViewLayer()
    
    }
    //MARK: - constraint First Layer
    func createCardViewLayer() {
        addSubview(cardView)
        cardView.fillSuperview()
        cardView.addSubview(tableView)
        tableView.anchor(top: cardView.topAnchor,
                         left: cardView.leftAnchor,
                         right: cardView.rightAnchor,
                         bottom: cardView.bottomAnchor,
                         paddingTop: 0, paddingLeft: 10, paddingRight: 10, paddingBottom: 0)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
