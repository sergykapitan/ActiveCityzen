//
//  QrCodeViewController.swift
//  ActiveCitizen
//
//  Created by Vladimir Vetrov on 04.09.2020.
//  Copyright © 2020 Novotorica. All rights reserved.
//

import UIKit
import CoreLocation
import AVFoundation
import YandexMobileMetrica

class QrCodeScanViewController: BaseViewController, QRScannerViewDelegate {
    
    @Inject var citizenApi: CitizenAPI
    
    @IBOutlet weak var qrScannerView: QRScannerView?
    var dobroOrderId: Int?
    
    override func viewDidLoad() {
        qrScannerView?.delegate = self
        self.navigationItem.backButtonTitle = " "
    }
    
    private func addBlurView() {
        let blurEffect = UIBlurEffect(style: .dark)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.alpha = 0.7
        blurView.frame = self.view.bounds
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        let maskLayer = CAShapeLayer()
        
        // Create a path with the rectangle in it.
        let path = UIBezierPath(rect: self.view!.bounds)
        
        let viewCenter =  self.view!.center
        path.move(to: viewCenter)
        path.addLine(to: viewCenter)
        
        path.addLine(to: CGPoint(x: viewCenter.x + 150.0, y: viewCenter.y))
        path.addLine(to: CGPoint(x: viewCenter.x + 150.0, y: viewCenter.y + 150))
        path.addLine(to: CGPoint(x: viewCenter.x, y: viewCenter.y +  150))
        path.addLine(to: CGPoint(x: viewCenter.x - 150.0, y: viewCenter.y +  150))
        path.addLine(to: CGPoint(x: viewCenter.x - 150.0, y: viewCenter.y))
        path.addLine(to: CGPoint(x: viewCenter.x - 150.0, y: viewCenter.y - 150.0))
        path.addLine(to: CGPoint(x: viewCenter.x, y: viewCenter.y - 150.0))
        path.addLine(to: CGPoint(x: viewCenter.x + 150.0, y: viewCenter.y - 150.0))
        path.addLine(to: CGPoint(x: viewCenter.x + 150.0, y: viewCenter.y))
        
        // Give the mask layer the path you just draw
        maskLayer.path = path.cgPath
        // Fill rule set to exclude intersected paths
        maskLayer.fillRule = CAShapeLayerFillRule.evenOdd
        
        // By now the mask is a rectangle with a circle cut out of it. Set the mask to the view and clip.
        blurView.layer.mask = maskLayer
        blurView.clipsToBounds = true
        
        view.addSubview(blurView)
    }
    
    private func addDividerLine() {
        let parent = self.view!
        let dividerView = UIView()
        
        let viewLineWidthMargin = (parent.bounds.size.width - 300) / 2
        dividerView.frame = CGRect(x: 0, y: 0, width: 300, height: 1)
        
        dividerView.backgroundColor = .red
        dividerView.layer.backgroundColor = UIColor(red: 1, green: 0.09, blue: 0.267, alpha: 0.6).cgColor
        parent.addSubview(dividerView)
        
        dividerView.translatesAutoresizingMaskIntoConstraints = false
        dividerView.widthAnchor.constraint(equalToConstant: 300).isActive = true
        dividerView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        dividerView.leadingAnchor.constraint(equalTo: parent.leadingAnchor, constant: viewLineWidthMargin).isActive = true
        
        dividerView.topAnchor.constraint(equalTo: parent.centerYAnchor, constant: 0).isActive = true
    }
    
    func qrScanningDidFail() {
        displayModalFailure()
        print("failed to scan qr code")
    }
    
    func qrScanningDidSucceedWithCode(_ str: String?) {
        guard let str = str else { return }
        print(str)
        do {
            if let data = str.data(using: .utf8) {
                if var dict = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    dict.switchKey(fromKey: "vendor_no", toKey: "vendorNo")
                    self.redeemDobrorubleCode(id: self.dobroOrderId ?? -1, parameters: dict)
                }
            }
        } catch let error {
            // Not a valid json object
            if let code = str.getQueryStringParameter(parameterName: "data") {
                uploadQrCodeData(data: code)
            }
            else {
                displayModalFailure()
                return }
        }
    }
    
    func redeemDobrorubleCode(id: Int, parameters: [String : Any]) {
        citizenApi.orderRedeemCode(id: id, parameters: parameters).subscribe (onNext: { dobroOrder in
            print(dobroOrder)
            
            let dobroOrderConfirmationVC = DobromarketOrderConfirmationViewController()
            dobroOrderConfirmationVC.dobroOrder = dobroOrder
            self.dismiss(animated: true, completion: {
                self.navigationController?.pushViewController(dobroOrderConfirmationVC, animated: true)
            })
        }, onError: { error in
            print(error)
            self.displayModalFailure()
        }).disposed(by: disposeBag)
    }
    
    func uploadQrCodeData(data: String) {
        LocationProvider.instance.getCurrentLocationSingle().map({ (coreLocation) -> Location in
            return Location(latitude: coreLocation.coordinate.latitude, longitude: coreLocation.coordinate.longitude)
        }).map({ (location) in
            QrCodeUploadRequest(location: location, key: data)
        }).flatMap({ (qrCodeUploadRequest) in
            self.citizenApi.uploadQrCode(qrCodeRequest: qrCodeUploadRequest)
        })
        .subscribe(onNext: { qrCodeStatusResponse in
            
            self.displayModalSuccess(amount: qrCodeStatusResponse.amount)
            print("QR Code has been uploaded")
        }, onError: {   error in
            print(error)

            if let error = error as? HttpErrorBody {
                print(error)
                self.displayModalFailureWindow(imageName: "iconCrossFailure", resultTitle: error.title ?? "", resultDescription: error.message)
            } else { return }
        }).disposed(by: disposeBag)
    }
    
    private func displayModalSuccess(amount: Int) {
        let resultViewController = ResultModalViewController()
        resultViewController.imageName = "iconCheckmarkSuccess"
        resultViewController.resultTitle = "+\(amount) д₽ отправляются на счет"
        resultViewController.resultDescription = "Поздравляем! Так держать!"
        resultViewController.modalTransitionStyle = .crossDissolve
        resultViewController.modalPresentationStyle = .overCurrentContext
        resultViewController.onDismiss = {
            self.qrScannerView?.startScanning()
        }
        present(resultViewController, animated: true, completion: nil)
    }
    
    private func displayModalFailure() {
        let resultViewController = ResultModalViewController()
        resultViewController.imageName = "iconCrossFailure"
        resultViewController.resultTitle = "Ошибка"
        resultViewController.resultDescription = "Код отсканирован неверно. Попробуйте перезагрузить приложение или обратитесь к представителю акции за помощью"
        resultViewController.modalTransitionStyle = .crossDissolve
        resultViewController.modalPresentationStyle = .overCurrentContext
        resultViewController.onDismiss = {
            self.qrScannerView?.startScanning()
        }
        present(resultViewController, animated: true, completion: nil)
    }
    
    private func displayModalFailureWindow(imageName: String, resultTitle: String, resultDescription: String) {
        let resultViewController = ResultModalViewController()
        resultViewController.imageName = imageName
        resultViewController.resultTitle = resultTitle
        resultViewController.resultDescription = resultDescription
        resultViewController.modalTransitionStyle = .crossDissolve
        resultViewController.modalPresentationStyle = .overCurrentContext
        resultViewController.onDismiss = {
            self.qrScannerView?.startScanning()
        }
        present(resultViewController, animated: true, completion: nil)
    }
    
    func qrScanningDidStop() {
        print("did stop scanning")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        openQrCodeScanViewController()
        if AVCaptureDevice.authorizationStatus(for: .video) ==  .authorized {
            getViewQRScan(isViewHidden: true)
            qrScannerView?.startScanning()
        } else {
            AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted: Bool) in
                if granted {
                    DispatchQueue.main.async {
                        self.getViewQRScan(isViewHidden: true)
                        self.qrScannerView?.startScanning()
                    }
                    
                } else {
                    DispatchQueue.main.async {
                        self.presentCameraSettings()
                        self.getViewQRScan(isViewHidden: false)
                    }
                }
            })
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.barStyle = .black
        // Make the navigation bar background clear
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        qrScannerView?.stopScanning()
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    func presentCameraSettings() {
        let alertController = UIAlertController(title: "Ошибка",
                                      message: "Доступ к камере запрещен",
                                      preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Отмена", style: .default))
        alertController.addAction(UIAlertAction(title: "Настройки", style: .cancel) { _ in
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url, options: [:], completionHandler: { _ in
                })
            }
        })

        present(alertController, animated: true)
    }
    
    private func getViewQRScan(isViewHidden: Bool) {
           if isViewHidden {
               addBlurView()
               addDividerLine()
           } else {
               print("isViewHidden false")
           }
           
    }
    func openQrCodeScanViewController() {
    YMMYandexMetrica.reportEvent("Открытие экрана QRCode", onFailure: { (error) in
        print("REPORT ERROR: %@", error.localizedDescription)
        })
    }
}
