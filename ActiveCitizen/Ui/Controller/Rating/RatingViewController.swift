//
//  RatingViewController.swift
//  ActiveCitizen
//
//  Created by Sergey on 23.03.2021.
//  Copyright © 2021 Novotorica. All rights reserved.
//

import UIKit

class RatingViewController: UIViewController {

    @IBOutlet weak var personalRating: UIButton!
    @IBOutlet weak var districtRating: UIButton!
    
    var shadowView = UIView(frame: CGRect(origin: CGPoint(x: 0, y: 2), size: CGSize(width: 0, height: 0)))
    var shadowDistrictView = UIView(frame: CGRect(origin: CGPoint(x: 0, y: 2), size: CGSize(width: 0, height: 0)))
    var isCurrentOutside = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        actionButton()
        
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        customPersonalRatingShadowView()
        customDistrictRatingShadowView()
    }
    
    //MARK: - ActionButton
    func actionButton() {
        personalRating.addTarget(self, action: #selector(goPersonalRating), for: .touchUpInside)
        districtRating.addTarget(self, action: #selector(goDistrictRating), for: .touchUpInside)
        
        personalRating.addTarget(self, action: #selector(shrinkAllowAnimation), for: .touchDown)
        personalRating.addTarget(self, action: #selector(restoreAllowAnimation), for: .touchUpInside)
        personalRating.addTarget(self, action: #selector(restoreAllowAnimation), for: .touchUpOutside)
        personalRating.addTarget(self, action: #selector(restore), for: .touchDragOutside)
        personalRating.addTarget(self, action: #selector(shrink), for: .touchDragInside)
        
        districtRating.addTarget(self, action: #selector(shrinkAllowAnimationDistrict), for: .touchDown)
        districtRating.addTarget(self, action: #selector(restoreAllowAnimationDistrict), for: .touchUpInside)
        districtRating.addTarget(self, action: #selector(restoreAllowAnimationDistrict), for: .touchUpOutside)
        districtRating.addTarget(self, action: #selector(restoreDistrict), for: .touchDragOutside)
        districtRating.addTarget(self, action: #selector(shrinkDistrict), for: .touchDragInside)
    }
    //MARK: - Selectors
    @objc func goPersonalRating () {
        let webBalanceViewController = WebViewController()
        let token = UserDefaults.standard.string(forKey: Constants.accessTokenKeyUserDefaults)!
        webBalanceViewController.url = Constants.webViewPwa + "/rating?token=\(token)"
        self.navigationController?.pushViewController(webBalanceViewController, animated: true)
    }
    @objc func goDistrictRating () {
        let webBalanceViewController = WebViewController()
        let token = UserDefaults.standard.string(forKey: Constants.accessTokenKeyUserDefaults)!
        webBalanceViewController.url = Constants.webViewPwa + "/districts-rating?token=\(token)"
        self.navigationController?.pushViewController(webBalanceViewController, animated: true)
    }
    func customPersonalRatingShadowView(){
    let backgroundView = UIView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: personalRating.frame.size))
    let label = UILabel(frame: CGRect(origin: CGPoint(x: 32, y: 0), size: personalRating.frame.size))
        label.text = "Личный"
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.textColor = UIColor(red: 0.18, green: 0.227, blue: 0.282, alpha: 0.8)
        let image: UIImageView = {
        let image = UIImageView()
        image.image = #imageLiteral(resourceName: "personal")
        image.contentMode = .center
        return image
        }()
    let imageback = UIImageView(frame: CGRect(origin: CGPoint(x: personalRating.frame.maxX - 28, y: 12), size: CGSize(width: 8, height: 8)))
        imageback.image = UIImage(named: "iconArrowNext")
        imageback.contentMode = .center
        backgroundView.addSubview(imageback)
        backgroundView.addSubview(image)
        image.anchor( left: backgroundView.leftAnchor, paddingLeft: 8, width: 16, height: 16)
        image.centerY(inView: backgroundView)
        backgroundView.addSubview(label)
        backgroundView.layer.cornerRadius = personalRating.layer.cornerRadius
        backgroundView.backgroundColor = .white
        backgroundView.isUserInteractionEnabled = false
        personalRating.addSubview(backgroundView)
        shadowView.frame.size = personalRating.frame.size
        shadowView.layer.cornerRadius = personalRating.layer.cornerRadius
        shadowView.backgroundColor = backgroundView.backgroundColor?.darker(by: 10)
        shadowView.isUserInteractionEnabled = false
        personalRating.addSubview(shadowView)
        personalRating.sendSubviewToBack(shadowView)
    }
    func customDistrictRatingShadowView(){
    let backgroundView = UIView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: districtRating.frame.size))
    let label = UILabel(frame: CGRect(origin: CGPoint(x: 32, y: 0), size: districtRating.frame.size))
        label.text = "Районный"
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.textColor = UIColor(red: 0.18, green: 0.227, blue: 0.282, alpha: 0.8)
        let image: UIImageView = {
        let image = UIImageView()
        image.image = #imageLiteral(resourceName: "district")
        image.contentMode = .center
        return image
        }()
    let imageback = UIImageView(frame: CGRect(origin: CGPoint(x: personalRating.frame.maxX - 28, y: 12), size: CGSize(width: 8, height: 8)))
        imageback.image = UIImage(named: "iconArrowNext")
        imageback.contentMode = .center
        backgroundView.addSubview(imageback)
        backgroundView.addSubview(image)
        image.anchor( left: backgroundView.leftAnchor, paddingLeft: 8, width: 16, height: 16)
        image.centerY(inView: backgroundView)
        backgroundView.addSubview(label)
        backgroundView.layer.cornerRadius = districtRating.layer.cornerRadius
        backgroundView.backgroundColor = .white
        backgroundView.isUserInteractionEnabled = false
        districtRating.addSubview(backgroundView)
        shadowDistrictView.frame.size = districtRating.frame.size
        shadowDistrictView.layer.cornerRadius = districtRating.layer.cornerRadius
        shadowDistrictView.backgroundColor = backgroundView.backgroundColor?.darker(by: 10)
        shadowDistrictView.isUserInteractionEnabled = false
        districtRating.addSubview(shadowDistrictView)
        districtRating.sendSubviewToBack(shadowDistrictView)
    }
    //MARK: - Personal Rating Animation
    @objc func shrinkAllowAnimation(){
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: CGFloat(0.6),
                       initialSpringVelocity: CGFloat(25.0),
                       options: [.curveEaseOut, .allowUserInteraction],
                       animations: {
                        self.personalRating.transform = CGAffineTransform(translationX: 0, y: 2)
                        self.shadowView.transform = CGAffineTransform(translationX: 0, y: -2)
        } )
    }
    
    @objc func restoreAllowAnimation(){
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: CGFloat(0.6),
                       initialSpringVelocity: CGFloat(10.0),
                       options: [.curveEaseIn, .allowUserInteraction],
                       animations: {
                        self.personalRating.transform = CGAffineTransform.identity
                        self.shadowView.transform = CGAffineTransform.identity
        })
    }
    
    @objc func shrink(){
        if isCurrentOutside == true{
            UIView.animate(withDuration: 0.5,
                           delay: 0,
                           usingSpringWithDamping: CGFloat(0.6),
                           initialSpringVelocity: CGFloat(15.0),
                           options: [.curveEaseOut],
                           animations: {
                            self.personalRating.transform = CGAffineTransform(translationX: 0, y: 2)
                            self.shadowView.transform = CGAffineTransform(translationX: 0, y: -2)
            }, completion: {_ in
                self.isCurrentOutside = false})
        }
    }
    
    @objc func restore(){
        if isCurrentOutside == false{
            UIView.animate(withDuration: 0.5,
                           delay: 0,
                           usingSpringWithDamping: CGFloat(0.6),
                           initialSpringVelocity: CGFloat(15.0),
                           options: [.curveEaseIn],
                           animations: {
                            self.personalRating.transform = CGAffineTransform.identity
                            self.shadowView.transform = CGAffineTransform.identity
            },completion: {_ in
                self.isCurrentOutside = true})
        }
    }
    //MARK: - District Animation
    @objc func shrinkAllowAnimationDistrict(){
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: CGFloat(0.6),
                       initialSpringVelocity: CGFloat(25.0),
                       options: [.curveEaseOut, .allowUserInteraction],
                       animations: {
                        self.districtRating.transform = CGAffineTransform(translationX: 0, y: 2)
                        self.shadowDistrictView.transform = CGAffineTransform(translationX: 0, y: -2)
                       })
    }
    @objc func restoreAllowAnimationDistrict(){
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: CGFloat(0.6),
                       initialSpringVelocity: CGFloat(10.0),
                       options: [.curveEaseIn, .allowUserInteraction],
                       animations: {
                        self.districtRating.transform = CGAffineTransform.identity
                        self.shadowDistrictView.transform = CGAffineTransform.identity
        })
    }
    
    @objc func shrinkDistrict(){
        if isCurrentOutside == true{
            UIView.animate(withDuration: 0.5,
                           delay: 0,
                           usingSpringWithDamping: CGFloat(0.6),
                           initialSpringVelocity: CGFloat(15.0),
                           options: [.curveEaseOut],
                           animations: {
                            self.districtRating.transform = CGAffineTransform(translationX: 0, y: 2)
                            self.shadowDistrictView.transform = CGAffineTransform(translationX: 0, y: -2)
            }, completion: {_ in self.isCurrentOutside = false})
        }
    }
    
    @objc func restoreDistrict(){
        if isCurrentOutside == false{
            UIView.animate(withDuration: 0.5,
                           delay: 0,
                           usingSpringWithDamping: CGFloat(0.6),
                           initialSpringVelocity: CGFloat(15.0),
                           options: [.curveEaseIn],
                           animations: {
                            self.districtRating.transform = CGAffineTransform.identity
                            self.shadowDistrictView.transform = CGAffineTransform.identity
            },completion: {_ in self.isCurrentOutside = true})
        }
    }
}
