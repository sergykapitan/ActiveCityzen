//
//  QRDescriptionModalViewController.swift
//  ActiveCitizen
//
//  Created by Sergey on 23.02.2021.
//  Copyright © 2021 Novotorica. All rights reserved.
//

import UIKit

class QRDescriptionModalViewController: UIViewController {

    let qrcodeView = QRDescriptionModalViewControllerCode()
    
    var albums = [String]()
    
    //MARK: - LifeCicle
    override func loadView() {
        super.loadView()
        view = qrcodeView
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.definesPresentationContext = true
        view.backgroundColor = .clear
        actionButton()
        setupMainView()
       
    }
    private func setupMainView() {
        qrcodeView.viewQRCode.collectionView.delegate = self
        qrcodeView.viewQRCode.collectionView.dataSource = self

    }

    // MARK: - Metods
    func actionButton() {
        qrcodeView.viewQRCode.closeButton.addTarget(self, action: #selector(dissmisView), for: .touchUpInside)
    }
    //MARK: - Selectors
    @objc func dissmisView() {
        self.dismiss(animated: true, completion: nil)
    }
}


extension QRDescriptionModalViewController: UICollectionViewDataSource {
    

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return albums.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.reuseID, for: indexPath) as? CollectionQRCodeImage else { return CollectionQRCodeImage()}
        let album = albums[indexPath.row]
        cell.configureCell(url: album)
        return cell
    }
}
extension QRDescriptionModalViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            
        let album = albums[indexPath.row]
                
     }
}
extension QRDescriptionModalViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

      return CGSize(width: collectionView.bounds.width * 0.95,
                    height: collectionView.bounds.width * 0.95)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
      return CGSize.zero
    }
}
