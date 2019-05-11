//
//  PhotoPicker.swift
//  ZamzamKit iOS
//
//  Created by Basem Emara on 2019-05-08.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

import AVFoundation
import UIKit

public protocol PhotoPickerType {
    func makeViewController() -> UIViewController?
}

public protocol PhotoPickerDelegate: class {
    func photoPicker(didFinishPicking image: UIImage)
    func photoPickerDidFailPermission()
}

open class PhotoPicker: NSObject, PhotoPickerType {
    private weak var delegate: (PhotoPickerDelegate & UIViewController)?
    
    public init(delegate: (PhotoPickerDelegate & UIViewController)?) {
        self.delegate = delegate
    }
}

extension PhotoPicker {
    
    open func makeViewController() -> UIViewController? {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            actionSheet.addAction(
                UIAlertAction(title: "Camera") { [weak self] in
                    guard AVCaptureDevice.authorizationStatus(for: .video) != .denied else {
                        self?.delegate?.photoPickerDidFailPermission()
                        return
                    }
                    
                    self?.openCamera()
                }
            )
        }
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            actionSheet.addAction(
                UIAlertAction(title: "Photos") { [weak self] in
                    self?.openPhotoLibrary()
                }
            )
        }
        
        actionSheet.addAction(
            UIAlertAction(title: .localized(.cancel), style: .cancel, handler: nil)
        )
        
        return actionSheet
    }
}

// MARK: - Delegates

extension PhotoPicker: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        
        picker.dismiss {
            self.delegate?.photoPicker(didFinishPicking: image)
        }
    }
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss()
    }
}

// MARK: - Helpers

private extension PhotoPicker {
    
    func openCamera() {
        delegate?.present(
            UIImagePickerController().with {
                $0.delegate = self
                $0.sourceType = .camera
                $0.allowsEditing = true
            },
            animated: true
        )
    }
    
    func openPhotoLibrary() {
        delegate?.present(
            UIImagePickerController().with {
                $0.delegate = self
                $0.sourceType = .photoLibrary
                $0.allowsEditing = true
            },
            animated: true
        )
    }
}
