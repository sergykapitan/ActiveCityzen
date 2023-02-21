//
//  TutorialPageViewController.swift
//  ActiveCitizen
//
//  Created by Vladimir Vetrov on 26.05.2020.
//  Copyright © 2020 Novotorica. All rights reserved.
//

import UIKit

class TutorialPageViewController: UIPageViewController {
    
    private lazy var orderedViewControllers: [TutorialViewController] = []    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self
        delegate = self
        
        
        let tutorial1 = TutorialViewController()
        let tutorial2 = TutorialViewController()
        let tutorial3 = TutorialViewController()
        
        tutorial1.tutorialTitle = "Приложение для тех, кто не сидит на месте"
        tutorial1.tutorialDescription = "Получай скидки и бонусы за занятия спортом и посещение мероприятий."
        tutorial1.tutorialImage = UIImage(resource: R.image.iconTutorial1)
        
        tutorial2.tutorialTitle = "Получай баллы"
        tutorial2.tutorialDescription = "За физическую активность - прогулки, пробежки, езду на велосипеде и посещение культурных и спортивных событий."
        tutorial2.tutorialImage =  UIImage(resource: R.image.iconTutorial2)
        
        tutorial3.tutorialTitle = "Меняй баллы"
        tutorial3.tutorialDescription = "Получай скидки на билеты в кино и театры, абонементы в спортзалы и спортинвентарь."
        tutorial3.tutorialImage =  UIImage(resource: R.image.iconTutorial3)
        
        orderedViewControllers.append(tutorial1)
        orderedViewControllers.append(tutorial2)
        orderedViewControllers.append(tutorial3)
        
        if let firstViewController = orderedViewControllers.first {
            setViewControllers([firstViewController],
                               direction: .forward,
                               animated: true,
                               completion: nil)
        }        
    }
    
    func skipTutorial() {
        openWelcomingScreenViewController()
    }
    
    private func openWelcomingScreenViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let nextViewController = storyboard.instantiateViewController(withIdentifier: "WelcomingScreenNavigationController") //as! WelcomingScreenViewController
        nextViewController.modalPresentationStyle = .fullScreen
        self.present(nextViewController, animated:true)
    }
    
    func nextTutorialPage() {
        guard let currentController = self.viewControllers?.first else { return }
        guard let viewControllerIndex = self.orderedViewControllers.firstIndex(of: currentController as! TutorialViewController) else { return }
        if viewControllerIndex + 1 < orderedViewControllers.count {
            self.setViewControllers([self.orderedViewControllers[viewControllerIndex + 1]], direction: .forward, animated: true, completion: nil)
        } else {
            openWelcomingScreenViewController()
        }
        print("going to the next page")
        
    }
}


/*
 // MARK: - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 
 
 override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
 // Get the new view controller using segue.destination.
 // Pass the selected object to the new view controller.
 }
 */

extension TutorialPageViewController: UIPageViewControllerDelegate {
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        guard let currentController = pageViewController.viewControllers?.first else {
            return 0 }
        guard let index = orderedViewControllers.firstIndex(of: currentController as! TutorialViewController) else { return 0 }
        return index
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        let appearance = UIPageControl.appearance()
        appearance.pageIndicatorTintColor = UIColor(hexString: "#C4C4C4")
        appearance.currentPageIndicatorTintColor = UIColor(hexString: "#6181F2")
        appearance.backgroundColor = UIColor(hexString: "#F5F5F5")
        return orderedViewControllers.count
    }
    
    func pageViewController(pageViewController: UIPageViewController,
                            viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = self.orderedViewControllers.firstIndex(of: viewController as! TutorialViewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else {
            return nil
        }
        
        guard orderedViewControllers.count > previousIndex else {
            return nil
        }
        
        return orderedViewControllers[previousIndex]
    }
    
    func pageViewController(pageViewController: UIPageViewController,
                            viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.firstIndex(of: viewController as! TutorialViewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        let orderedViewControllersCount = orderedViewControllers.count
        
        guard orderedViewControllersCount != nextIndex else {
            return nil
        }
        
        guard orderedViewControllersCount > nextIndex else {
            return nil
        }
        
        return orderedViewControllers[nextIndex]
    }
}
extension TutorialPageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        nil
    }
}
