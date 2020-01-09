//
//  ViewController.swift
//  albelliTest
//
//  Created by Alex Yaroshyn on 08/01/2020.
//  Copyright © 2020 albelli BV. All rights reserved.
//

import UIKit
import Photos

class MainViewController: UIViewController {
    private let cellReuseIdentifier = "cell"
    private var collectionView: UICollectionView!

    private var photosFetchResult = PHFetchResult<PHAsset>()

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView = UICollectionView(
            frame: view.bounds,
            collectionViewLayout: {
                let layout = UICollectionViewFlowLayout()
                layout.minimumInteritemSpacing = 0
                layout.minimumLineSpacing = 0
                return layout
            }()
        )
        collectionView.backgroundColor = .white
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(CollectionViewImageCell.self, forCellWithReuseIdentifier: cellReuseIdentifier)
        view.addSubview(collectionView)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getAllPhotos()
    }

    private func getAllPhotos() {
        PHPhotoLibrary.requestAuthorization { [weak self] status in
            guard case .authorized = status else { return assertionFailure("not handled for the sake of simplicity") }
            self?.photosFetchResult = PHAsset.fetchAssets(with: .image, options: PHFetchOptions())
            DispatchQueue.main.async { self?.collectionView.reloadData() }
        }
    }
}

extension MainViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photosFetchResult.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: cellReuseIdentifier,
            for: indexPath
        ) as! CollectionViewImageCell
        cell.image = nil // TODO: pass in the image
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.bounds.size.width / 2, height: view.bounds.size.width / 2)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let imageViewController = ImageViewController(imageId: "") // TODO: init with asset image id
        navigationController?.pushViewController(imageViewController, animated: true)
    }
}
