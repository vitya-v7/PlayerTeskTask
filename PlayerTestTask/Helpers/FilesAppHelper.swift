//
//  FilesAppHelper.swift
//  PlayerTestTask
//
//  Created by Admin on 06.12.2022.
//

import Foundation
import MediaPlayer

protocol FilesAppHelperDelegate: AnyObject {
    func appFilesHelper(_ appFilesHelper: FilesAppHelper,
                        itemsHasBeenChanged items: [TrackModel])
}

class FilesAppHelper: RootPickerHelper {
    
    weak var delegate: FilesAppHelperDelegate?
    
    internal override func getRequestAccess(inViewController viewController: UIViewController,
                                            access: @escaping (Bool) -> Void) {
        access(true)
    }
    
}

extension FilesAppHelper: UIDocumentPickerDelegate {
    
    func documentPicker(_ controller: UIDocumentPickerViewController,
                        didPickDocumentAt url: URL) {
        url.startAccessingSecurityScopedResource()
        let tracks = DataManager.shared.getTracks(byUrl: [url])
        guard let track = tracks.first else {
            return
        }
        self.copyItemToTemporaryFolder(track) { track in
            self.delegate?.appFilesHelper(self,
                                          itemsHasBeenChanged: [track])
            DispatchQueue.main.async {
                controller.dismiss(animated: true)
            }
        }
        url.stopAccessingSecurityScopedResource()
        
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        DispatchQueue.main.async {
            controller.dismiss(animated: true)
        }
    }
}
