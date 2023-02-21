//
//  ExtensionsRedesingWorkoutTypeViewController.swift
//  ActiveCitizen
//
//  Created by Sergey on 18.04.2021.
//  Copyright © 2021 Novotorica. All rights reserved.
//

import Foundation
import Instructions

extension RedesingWorkoutTypeViewController: CoachMarksControllerDelegate,CoachMarksControllerDataSource,CoachMarksControllerAnimationDelegate {
    
    func coachMarksController(_ coachMarksController: CoachMarksController, configureOrnamentsOfOverlay overlay: UIView) {

        overlay.addSubview(self.pageControl)
        self.pageControl.anchor(bottom:overlay.bottomAnchor,paddingBottom: 20)
        self.pageControl.centerX(inView: overlay)
        
       }
       func coachMarksController(_ coachMarksController: CoachMarksController, coachMarkViewsAt index: Int, madeFrom coachMark: CoachMark) -> (bodyView: (UIView & CoachMarkBodyView), arrowView: (UIView & CoachMarkArrowView)?) {
           
           var hintText = ""

           switch index {
           case 0:
               hintText = "Твои результаты отображаются сразу"
           case 1:
            hintText = "Приостанови свою тренировку, если хочешь прерваться"
           case 2:
               hintText = "Зажми и держи, чтоб выйти из режима тренировки"
           default: break
           }
    
           
           let coachViews = coachMarksController.helper.makeDefaultCoachViews( withArrow: true,
                                                                               arrowOrientation: coachMark.arrowOrientation,
                                                   hintText: hintText,
                                                   nextText: nil
                                                                             )
           coachViews.bodyView.background.innerColor = UIColor(hexString: "43ACFF")
           coachViews.bodyView.background.borderColor = UIColor(hexString: "43ACFF")
           coachViews.arrowView?.background.innerColor = UIColor(hexString: "43ACFF")
           coachViews.arrowView?.background.borderColor = UIColor(hexString: "43ACFF")
           
           return (bodyView: coachViews.bodyView, arrowView: coachViews.arrowView)
       }
       
       func coachMarksController(_ coachMarksController: CoachMarksController, coachMarkAt index: Int) -> CoachMark {
           
           
           switch index {
           case 0:
            self.pageControl.currentPage = 1
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) { // in half a second...
                WorkoutService.instance.pauseWorkout(sender: self.redesingWorkoutView.bottomView.buttonPauseWorkout)
             // WorkoutService.instance.stopWorkout()
            }
            
            let markView = redesingWorkoutView.bottomView.workoutDistanceChangeLabel
            return coachMarksController.helper.makeCoachMark(for: markView,
            cutoutPathMaker:  { (frame: CGRect) -> UIBezierPath in
            return UIBezierPath(roundedRect: frame.insetBy(dx: -140, dy: -20), cornerRadius: 6)})
           case 1:
            self.pageControl.currentPage = 2
            let markView = redesingWorkoutView.bottomView.buttonPauseWorkout
            return coachMarksController.helper.makeCoachMark(for: markView,
            cutoutPathMaker:  { (frame: CGRect) -> UIBezierPath in
            return UIBezierPath(roundedRect: frame.insetBy(dx: -6, dy: -25), cornerRadius: 6)})
            
           case 2:
            self.pageControl.currentPage = 3
            let markView = redesingWorkoutView.bottomView.buttonStopWorkout
            return coachMarksController.helper.makeCoachMark(for: markView,
            cutoutPathMaker:  { (frame: CGRect) -> UIBezierPath in
            return UIBezierPath(roundedRect: frame.insetBy(dx: -6, dy: -25), cornerRadius: 6)})
 
           default:
            return coachMarksController.helper.makeCoachMark(for: .init(frame: CGRect(x: view.bounds.minX - 40, y: view.bounds.minY - 40, width: 0, height: 0)), pointOfInterest: nil, cutoutPathMaker: .none)
           }
    
       }

       func coachMarksController(_ coachMarksController: CoachMarksController,
                                          willHide coachMark: CoachMark, at index: Int) {
        if index == 1 {
            redesingWorkoutView.bottomView.buttonPauseWorkout.isHidden = true
            redesingWorkoutView.bottomView.pauseLabel.isHidden = true
            redesingWorkoutView.bottomView.buttonStopWorkout.isHidden = false
            redesingWorkoutView.bottomView.stopLabel.isHidden = false
            
        }
        if index == 2 {
             UserDefaults.standard.set(false, forKey: "startTraning")
             UserDefaults.standard.set(true, forKey: "repidMain")
             self.navigationController?.popToRootViewController(animated: true)
           }
   
       }

       func coachMarksController( _ coachMarksController: CoachMarksController, constraintsForSkipView skipView: UIView, inParent parentView: UIView  ) -> [NSLayoutConstraint]? {

           var constraints: [NSLayoutConstraint] = []

               constraints.append(contentsOf: [
                   skipView.bottomAnchor.constraint(equalTo: parentView.bottomAnchor, constant: -30),
                   skipView.leadingAnchor.constraint(equalTo: parentView.leadingAnchor, constant: 20)
               ])

           return constraints
       }

       func numberOfCoachMarks(for coachMarksController: CoachMarksController) -> Int {
           3
       }
 
}
