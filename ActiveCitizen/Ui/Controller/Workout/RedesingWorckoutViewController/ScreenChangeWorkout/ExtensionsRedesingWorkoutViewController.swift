//
//  ExtensionsRedesingWorkoutViewController.swift
//  ActiveCitizen
//
//  Created by Sergey on 18.04.2021.
//  Copyright © 2021 Novotorica. All rights reserved.
//

import Foundation
import Instructions

extension RedesingWorkoutViewController: CoachMarksControllerDelegate,CoachMarksControllerDataSource,CoachMarksControllerAnimationDelegate {
    func coachMarksController(_ coachMarksController: CoachMarksController, configureOrnamentsOfOverlay overlay: UIView) {
        
        overlay.addSubview(self.pageControl)
        self.pageControl.anchor(bottom:overlay.bottomAnchor,paddingBottom: 20)
        self.pageControl.centerX(inView: overlay)
        

       }
       func coachMarksController(_ coachMarksController: CoachMarksController, coachMarkViewsAt index: Int, madeFrom coachMark: CoachMark) -> (bodyView: (UIView & CoachMarkBodyView), arrowView: (UIView & CoachMarkArrowView)?) {
           
           var hintText = ""

           switch index {
           case 0:
               hintText = "Выбирай вид тренировки"
     
           default: break
           }
    
           
           let coachViews = coachMarksController.helper.makeDefaultCoachViews( withArrow: true,
                                                                               arrowOrientation: .top,
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
            self.pageControl.currentPage = 0
            let markView = redesingView.workoutView
            return coachMarksController.helper.makeCoachMark(for: markView, pointOfInterest: CGPoint(x: redesingView.workoutView.bounds.minX + 40, y: redesingView.workoutView.bounds.minY))
   
 
           default:
            return coachMarksController.helper.makeCoachMark(for: .init(frame: CGRect(x: view.bounds.minX - 40, y: view.bounds.minY - 40, width: 0, height: 0)), pointOfInterest: nil, cutoutPathMaker: .none)
           }
    
       }

       func coachMarksController(_ coachMarksController: CoachMarksController,
                                          willHide coachMark: CoachMark, at index: Int) {
           if index == 0 {
                self.presentWorkoutForTheInstraction()
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
           1
       }
    func handleGesture(gesture: UISwipeGestureRecognizer) -> Void {
       if gesture.direction == .right {
            print("Swipe Right")
       }
       else if gesture.direction == .left {
            print("Swipe Left")
       }
       else if gesture.direction == .up {
            print("Swipe Up")
       }
       else if gesture.direction == .down {
            print("Swipe Down")
       }
    }
}
