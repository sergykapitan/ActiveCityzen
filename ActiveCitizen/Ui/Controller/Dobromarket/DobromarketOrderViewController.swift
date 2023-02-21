//
//  DobromarketOrderViewController.swift
//  ActiveCitizen
//
//  Created by Vladimir Vetrov on 12.10.2020.
//  Copyright © 2020 Novotorica. All rights reserved.
//

import UIKit
import RxSwift

class DobromarketOrderViewController: UIViewController {
    
    @Inject var citizenApi: CitizenAPI
    
    var orderId: Int?
    var dobroOrder: DobroOrder?
    var dobroOffer: DobroOffer?
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var labelPurchaseDateTime: UILabel!
    @IBOutlet weak var labelOrderHeader: UILabel!
    @IBOutlet weak var labelPromocode: UILabel!
    
    @IBOutlet weak var imageViewQrCode: UIImageView!
    @IBOutlet weak var buttonToggleQrCode: UIButton!
    
    @IBAction func toggleQrCode(_ sender: UIButton) {
        self.imageViewQrCode.isHidden = !self.imageViewQrCode.isHidden
        self.constraintFromButtonToggleQrCodeToPromocode.isActive = !self.constraintFromButtonToggleQrCodeToPromocode.isActive
        self.constraintFromButtonTogglePromocodeToQrCode.isActive =  !self.constraintFromButtonTogglePromocodeToQrCode.isActive
        
        if imageViewQrCode.isHidden {
            self.buttonToggleQrCode.setTitle("Показать QR-код", for: .normal)
        } else {
            self.buttonToggleQrCode.setTitle("Скрыть QR-код", for: .normal)
        }
    }
    
    @IBOutlet weak var buttonActivatePromocodeViaQr: UIButton!
    @IBOutlet weak var constraintFromPartnerWebsiteToPromocodeContainer: NSLayoutConstraint!
    
    @IBOutlet weak var constraintFromPromoDescriptionToQrCode: NSLayoutConstraint!
    @IBOutlet weak var constraintFromButtonToggleQrCodeToPromocode: NSLayoutConstraint!
    @IBOutlet weak var constraintFromButtonTogglePromocodeToQrCode: NSLayoutConstraint!
    
    @IBAction func activatePromocodeViaQrCode(_ sender: Any) {
        guard let orderId = orderId else { return }
        let qrCodeVC = self.storyboard?.instantiateViewController(withIdentifier: "QrCodeScanViewController") as! QrCodeScanViewController
      
        qrCodeVC.dobroOrderId = orderId
        self.navigationController?.pushViewController(qrCodeVC, animated: true)
    }
    
    @IBAction func openPartnerWebsite(_ sender: Any) {
        if let link = URL(string: dobroOffer?.redirectUrl ?? "") {
          UIApplication.shared.open(link)
        }
    }
    
    @IBOutlet weak var labelDescription: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.backButtonTitle = " "
        self.title = "Мои покупки"
        citizenApi.getDobroOrderById(orderId: self.orderId!)
            .subscribe(onNext: { dobroOrder in
            
            self.labelPurchaseDateTime.text = dobroOrder.createdAt.iso8601?.userFriendlyDateTime
            self.labelOrderHeader.text = dobroOrder.header
            self.labelPromocode.text = dobroOrder.coupon
                if let dobroOffer = dobroOrder.offer {
                    self.dobroOffer = dobroOffer
                    self.scrollView.layoutIfNeeded()
                    self.labelDescription.text = dobroOffer.description
                    
                    if !dobroOffer.isPartnerQr {
                        self.buttonActivatePromocodeViaQr.isHidden = true
                        self.constraintFromPartnerWebsiteToPromocodeContainer.isActive = true
                    }
                    
                    if !dobroOffer.isPersonalQr {
                        self.imageViewQrCode.isHidden = true
                        self.buttonToggleQrCode.isHidden = true
                        self.constraintFromPromoDescriptionToQrCode.isActive = true
                    } else {
                        self.imageViewQrCode.image = self.generateQRCode(from: dobroOrder.coupon)
                    }
                }
        }, onError: {  error in
            print(error)
        })
    }
    
    func generateQRCode(from string: String) -> UIImage? {
        let data = string.data(using: String.Encoding.ascii)

        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 7, y: 7)

            if let output = filter.outputImage?.transformed(by: transform) {
                return UIImage(ciImage: output)
            }
        }

        return nil
    }
    static func storyboardInstance() -> DobromarketOrderViewController? {
            let storyboard = UIStoryboard(name: String(describing: self), bundle: nil)
            return storyboard.instantiateInitialViewController() as? DobromarketOrderViewController
        }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.barStyle = .default
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.barTintColor = .white
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.tintColor = .systemBlue
    }
    
}
