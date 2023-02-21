//
//  ExTableViewDataSourse.swift
//  ActiveCitizen
//
//  Created by Sergey on 17.02.2021.
//  Copyright © 2021 Novotorica. All rights reserved.
//

import UIKit

extension AllSaveWorkoutViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.categories.count
    }
 
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "AllSaveWorkoutViewCell", for: indexPath) as! AllSaveWorkoutViewCell
        
        let category = categories.reversed()[indexPath.section]
        
        if category.typeWorkout == "Ходьба на месте" || category.typeWorkout == "Бег на месте" {
            let stepscount = category.pace.toUInt()
            cell.bottomLabel.text = stepsCountUniversal(count: stepscount ?? 0) + " \u{2022} " + category.time
        } else {
        cell.bottomLabel.text = category.distance + " \u{2022} " + category.pace + " \u{2022} " + category.time
        }
        
        cell.dataLabel.text = "\(category.created.userFriendlyDateTime)"
        cell.typeActivityLabel.text = category.typeWorkout
        cell.imageTypeActivity.image = UIImage(named: category.imageName)
        
        cell.backgroundColor = .white
        cell.layer.cornerRadius = 8
        cell.clipsToBounds = true       
        return cell
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
           let headerView = UIView()
        headerView.backgroundColor = UIColor(red: 0.961, green: 0.961, blue: 0.961, alpha: 1)
           return headerView
       }
    
    
    private func stepsCountUniversal(count: UInt) -> String{

        print(count)
        let formatString : String = NSLocalizedString("stepscount",
                                                      comment: "stepscount string format to be found in Localized.stringsdict")
        let resultString : String = String.localizedStringWithFormat(formatString, count)
        return resultString
    }

}
