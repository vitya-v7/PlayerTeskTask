//
//  GalleryHelper.swift
//  PlayerTestTask
//
//  Created by Admin on 06.12.2022.
//

import Foundation
import Photos
import UIKit

protocol GalleryHelperDelegate: AnyObject {
    func galleryHelper(_ galleryHelper: GalleryHelper,
                       itemsHasBeenChanged items: [TrackModel])
}

public typealias GalleryDelegate = UIImagePickerControllerDelegate & UINavigationControllerDelegate

class GalleryHelper: RootPickerHelper {
    
    weak var delegate: GalleryHelperDelegate?
    
    internal override func getRequestAccess(inViewController viewController: UIViewController,
                                                            access: @escaping (Bool) -> Void) {
        let accessStatus = PHPhotoLibrary.authorizationStatus()
        switch accessStatus {
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization({ status in
                if status == .authorized {
                    access(true)
                    return
                } else {
                    access(false)
                }
            })
        case .restricted, .denied:
            self.requestDeniedWithText("You have denied access to Photos. To allow access, please go to Settings.",
                                       inViewController: viewController)
            access(false)
        case .authorized:
            access(true)
        default:
            access(false)
        }
    }
}

extension GalleryHelper: GalleryDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let videoURL = info[.mediaURL] as? URL else {
            return
        }
       
        let tracks = DataManager.shared.getTracks(byUrl: [videoURL])
        guard let track = tracks.first else {
            self.showErrorAlert(inViewController: picker)
            DispatchQueue.main.async {
                picker.dismiss(animated: true, completion: nil)
            }
            return
        }
        self.exportSessionHelper.exportVideoItem(track) { track in
            self.delegate?.galleryHelper(self,
                                         itemsHasBeenChanged: [track])
            DispatchQueue.main.async {
                picker.dismiss(animated: true, completion: nil)
            }
        } errorCompletion: { errorDescription in
            if let errorDescription = errorDescription {
                self.showErrorAlert(withErrorDescription: errorDescription,
                                    inViewController: picker)
            } else {
                self.showErrorAlert(inViewController: picker)
            }
            DispatchQueue.main.async {
                picker.dismiss(animated: true, completion: nil)
            }
        }
    }
}
