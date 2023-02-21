//
//  ExtentionMainViewController.swift
//  ActiveCitizen
//
//  Created by Sergey on 07.04.2021.
//  Copyright © 2021 Novotorica. All rights reserved.
//
import Instructions
extension MainViewController: CoachMarksControllerDelegate,CoachMarksControllerDataSource,CoachMarksControllerAnimationDelegate {
    

    func coachMarksController(_ coachMarksController: CoachMarksController, configureOrnamentsOfOverlay overlay: UIView) {

        overlay.addSubview(self.labelDescription)
        self.labelDescription.anchor(bottom: overlay.bottomAnchor, paddingBottom: 96, width: 244, height: 60)
        self.labelDescription.centerX(inView: overlay)
        
        overlay.addSubview(self.imageTraning)
        self.imageTraning.anchor( bottom: labelDescription.topAnchor, paddingBottom: 13)
        self.imageTraning.centerX(inView: overlay)

        overlay.addSubview(self.pageControl)
        self.pageControl.anchor(bottom:overlay.bottomAnchor,paddingBottom: 20)
        self.pageControl.centerX(inView: overlay)
        
       
        
        snapshotDelegate?.coachMarksController(coachMarksController,configureOrnamentsOfOverlay: overlay)
       
       }
     
    func coachMarksController(_ coachMarksController: CoachMarksController, coachMarkViewsAt index: Int, madeFrom coachMark: CoachMark) -> (bodyView: (UIView & CoachMarkBodyView), arrowView: (UIView & CoachMarkArrowView)?) {
        
        var hintText = ""

        switch index {
        case 0:
            hintText = "Здесь мы показываем, сколько ты прошел за день"
        case 1:
            hintText = "Это количество баллов, которые ты можешь потратить у партнеров"
        case 2:
            hintText = "Тут ты можешь выбирать, каким спортом заняться сегодня!"
        case 3:
            hintText = "Здесь отображаются события с лучшими призами!"
        case 4:
            hintText = "Здесь отображаются спецзадания с лучшими призами. Они ограничены по времени!"
        case 5:
            hintText = "Раздел заработать показывает ближайшие места, где ты сможешь заниматься спортом, а так же получать дополнительные баллы за активности"
        case 6:
            hintText = "В этом разделе ты сможешь найти партнеров и купить различные товары за баллы"
        case 7:
            hintText = "case 7"
            
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
            self.pageControl.currentPage = 0
            self.labelDescription.isHidden = false
            self.labelDescription.text = "Смахни вправо, чтобы прочесть следующую подсказку или влево, чтобы вернуться назад"
            self.imageTraning.isHidden = false
            self.imageTraning.image = #imageLiteral(resourceName: "swipeleftright")
            self.coachMarksController.skipView?.isHidden = false
            self.tabBarController?.tabBar.isUserInteractionEnabled = true
            self.tabBarController?.tabBar.backgroundColor = .white
            let markView = tableView.cellForRow(at: .init(row: 0, section: 0))?.viewWithTag(1)
            return coachMarksController.helper.makeCoachMark(for: markView)
            
            
        case 1:
            self.pageControl.currentPage = 1
            self.labelDescription.isHidden = false
            self.labelDescription.text = "Смахни вниз, чтобы закончить обучение"
            self.imageTraning.isHidden = false
            self.imageTraning.image = #imageLiteral(resourceName: "swipedown")
            self.coachMarksController.skipView?.isHidden = false
            let markView = tableView.cellForRow(at: .init(row: 0, section: 0))?.viewWithTag(2)
            var coach = coachMarksController.helper.makeCoachMark(for: markView)
            coach.isUserInteractionEnabledInsideCutoutPath = false
            return coach
        case 2:
            self.pageControl.currentPage = 2
            self.labelDescription.isHidden = true
            self.imageTraning.isHidden = true
            self.coachMarksController.skipView?.isHidden = true
            let markView = tableView.cellForRow(at: .init(row: 1, section: 0))?.viewWithTag(1)
            var coach =  coachMarksController.helper.makeCoachMark(for: markView)
            coach.isUserInteractionEnabledInsideCutoutPath = true
            return coach
        case 3:
            self.pageControl.currentPage = 3
            self.coachMarksController.skipView?.isHidden = true
            let markView = tableView.cellForRow(at: .init(row: 3, section: 0))
             var coach = coachMarksController.helper.makeCoachMark(for: markView,
              cutoutPathMaker:  { (frame: CGRect) -> UIBezierPath in
                return UIBezierPath(roundedRect: frame.insetBy(dx: 4, dy: 2), cornerRadius: 6)})
            coach.isUserInteractionEnabledInsideCutoutPath = false
            return coach
        case 4:
            self.pageControl.currentPage = 4
            self.coachMarksController.skipView?.isHidden = true
            _ = self.tabBarController?.selectedIndex = 0
            let markView = tableView.cellForRow(at: .init(row: 4, section: 0))
            self.tabBarController?.tabBar.isUserInteractionEnabled = true
            self.tabBarController?.tabBar.backgroundColor = .white
            return coachMarksController.helper.makeCoachMark(for: markView,
            cutoutPathMaker:  { (frame: CGRect) -> UIBezierPath in
            return UIBezierPath(roundedRect: frame.insetBy(dx: 4, dy: 2), cornerRadius: 6)})
        case 5:
            self.pageControl.currentPage = 5
            self.coachMarksController.skipView?.isHidden = true
            coachMarksController.overlay.buttonNext.isHidden = false
            _ = self.tabBarController?.selectedIndex = 1
            tabBarController?.tabBar.subviews[2].tag = 5
            let markView = tabBarController?.tabBar.subviews[2].viewWithTag(5)
            return coachMarksController.helper.makeCoachMark(for: markView,
            cutoutPathMaker: { (frame: CGRect) -> UIBezierPath in
            return UIBezierPath(roundedRect: frame , cornerRadius: 6)})
        case 6:
            self.pageControl.currentPage = 6
            self.coachMarksController.skipView?.isHidden = true
            _ = self.tabBarController?.selectedIndex = 3
            tabBarController?.tabBar.subviews[4].tag = 5
            let markView = tabBarController?.tabBar.subviews[4].viewWithTag(5)
            let coach = coachMarksController.helper.makeCoachMark(for: markView ,
                        cutoutPathMaker: { (frame: CGRect) -> UIBezierPath in
            return UIBezierPath(roundedRect: frame , cornerRadius: 6)})
            coachMarksController.overlay.buttonNext.isHidden = true
            return coach
        case 7:
           // self.pageControl.currentPage = 7
            self.coachMarksController.skipView?.isHidden = true
            _ = self.tabBarController?.selectedIndex = 0
            UserDefaults.standard.set(false, forKey: "startTraning")
            UserDefaults.standard.set(false, forKey: "repidMain")
            
            self.coachMarksController.stop(immediately: true)
            return coachMarksController.helper.makeCoachMark(for: .init(frame: CGRect(x: view.bounds.minX - 20, y: view.bounds.minY - 20, width: 0, height: 0)), pointOfInterest: nil, cutoutPathMaker: .none)

        default:
            return coachMarksController.helper.makeCoachMark(for: .init(frame: CGRect(x: view.bounds.minX - 40, y: view.bounds.minY - 40, width: 0, height: 0)), pointOfInterest: nil, cutoutPathMaker: .none)
        }
 
    }

    func coachMarksController(_ coachMarksController: CoachMarksController,
                                       willHide coachMark: CoachMark, at index: Int) {
        let swipe = UserDefaults.standard.bool(forKey: "swipe")
        if index == 3 && swipe {
            self.tableView.scrollToRow(at: .init(row: 4, section: 0), at: .middle ,animated: true)
        }
        if index == 3 && !swipe {
            self.tableView.scrollToRow(at: .init(row: 2, section: 0), at: .middle ,animated: true)
        }
        if index == 2 && swipe {
            let indexPath = IndexPath(row: 3, section: 0)
            self.tableView.scrollToRow(at: indexPath, at: .middle, animated: true)
        }
        if index == 2 && !swipe {
            let indexPath = IndexPath(row: 1, section: 0)
            self.tableView.scrollToRow(at: indexPath, at: .middle, animated: true)
        }

    }
    func coachMarksController(_ coachMarksController: CoachMarksController, willShow coachMark: inout CoachMark, beforeChanging change: ConfigurationChange, at index: Int) {

    }

    func coachMarksController( _ coachMarksController: CoachMarksController, constraintsForSkipView skipView: UIView, inParent parentView: UIView  ) -> [NSLayoutConstraint]? {

        var constraints: [NSLayoutConstraint] = []

            constraints.append(contentsOf: [
                skipView.topAnchor.constraint(equalTo: labelDescription.bottomAnchor, constant: 30),
                skipView.leadingAnchor.constraint(equalTo: parentView.leadingAnchor, constant: 20)
            ])

        return constraints
    }
    func coachMarksController(_ coachMarksController: CoachMarksController, willLoadCoachMarkAt index: Int) -> Bool {
        let traning = UserDefaults.standard.bool(forKey: "repidMain")
        
        switch index {
        case 0:
            if traning { return false
            } else { return true }
        case 1:
            if traning { return false
            } else { return true}

        default:
            return true
        }
    }
    func numberOfCoachMarks(for coachMarksController: CoachMarksController) -> Int {
        8
    }
}

extension MainViewController: ButtonDelegate {
    func onButtonTap() {        
        let indexPath = IndexPath(row: 1, section: 0)
        self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        self.coachMarksController.start(in: .window(over: self))

    }
}
extension MainViewController: StartTraningDelegate {
    func onButtonTapTraning() {
        self.coachMarksController.stop(immediately: false)
                       
    }
}
