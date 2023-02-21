//
//  WelcomingScreenViewController.swift
//  ActiveCitizen
//
//  Created by Vladimir Vetrov on 06.07.2020.
//  Copyright © 2020 Novotorica. All rights reserved.
//

import UIKit
import YandexMobileMetrica

class WelcomingScreenViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    @IBAction func buttonKJNO(_ sender: Any) {
        pressButtonKJNO()
    }
    
    override func viewWillAppear(_ animated: Bool) {
           super.viewWillAppear(animated)
           navigationController?.setNavigationBarHidden(true, animated: animated)
       }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        openWelcomeViewController()
    }
    override func viewWillDisappear(_ animated: Bool) {
           super.viewWillDisappear(animated)
           navigationController?.setNavigationBarHidden(false, animated: animated)
       }
    
    func openWelcomeViewController() {
    YMMYandexMetrica.reportEvent("Открытие экрана Добро пожаловать", onFailure: { (error) in
        print("REPORT ERROR: %@", error.localizedDescription)
        })
    }
    func pressButtonKJNO() {
    YMMYandexMetrica.reportEvent("Переход по кнопке Войти через карту жителя НО", onFailure: { (error) in
        print("REPORT ERROR: %@", error.localizedDescription)
        })
    }
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
