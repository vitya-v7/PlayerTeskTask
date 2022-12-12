//
//  MusicFilesHelper.swift
//  PlayerTestTask
//
//  Created by Admin on 06.12.2022.
//

import MediaPlayer

protocol MusicFilesHelperDelegate: AnyObject {
    func itunesHelper(_ itunesHelper: MusicFilesHelper,
                      itemsHasBeenChanged items: [TrackModel])
}

class MusicFilesHelper: RootPickerHelper {
    
    weak var delegate: MusicFilesHelperDelegate?
    internal override func getRequestAccess(inViewController viewController: UIViewController,
                                                            access: @escaping (Bool) -> Void) {
        MPMediaLibrary.requestAuthorization { (status) in
            switch status {
            case .denied, .restricted:
                self.requestDeniedWithText("You have denied access to Music. To allow access, please go to Settings.",
                                           inViewController: viewController)
                self.isLogged = false
                access(false)
            case .authorized:
                self.isLogged = true
                access(true)
            default:
                self.isLogged = nil
            }
        }
    }
    
}

extension MusicFilesHelper: MPMediaPickerControllerDelegate {
    func mediaPicker(_ mediaPicker: MPMediaPickerController,
                     didPickMediaItems mediaItemCollection: MPMediaItemCollection) {
        DispatchQueue.main.async {
            mediaPicker.dismiss(animated: true)
        }
        guard let mediaTrack = mediaItemCollection.items.first,
        let itemUrl = mediaTrack.assetURL,
        let track = DataManager.shared.getTracks(byUrl: [itemUrl]).first else {
            return
        }
        self.exportSessionHelper.exportAudioItem(track) { track in
            self.delegate?.itunesHelper(self,
                                        itemsHasBeenChanged: [track])
            DispatchQueue.main.async {
                mediaPicker.dismiss(animated: true, completion: nil)
            }
        } errorCompletion: { errorDescription in
            if let errorDescription = errorDescription {
                self.showErrorAlert(withErrorDescription: errorDescription,
                inViewController: mediaPicker)
            } else {
                self.showErrorAlert(inViewController: mediaPicker)
            }
            DispatchQueue.main.async {
                mediaPicker.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    func mediaPickerDidCancel(_ mediaPicker: MPMediaPickerController) {
        DispatchQueue.main.async {
            mediaPicker.dismiss(animated: true)
        }
        print("\nNo selected tracks\n")
    }
}
