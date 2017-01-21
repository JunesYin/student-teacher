//
//  LyJurisdictionUtil.swift
//  student
//
//  Created by MacMini on 2017/1/17.
//  Copyright © 2017年 517xueche. All rights reserved.
//

import UIKit
import AudioToolbox


struct PhotoSource: OptionSet {
    let rawValue: Int
    
    static let camera = PhotoSource(rawValue: 1 << 0)
    static let photoLibrary = PhotoSource(rawValue: 1 << 1)
}



typealias imageFinished = (_ image: UIImage) -> ()


class LyJurisdictionUtil: NSObject {

    static let util = LyJurisdictionUtil()
    
    private override init() {}
    
    var imageFinished: imageFinished?
    var isEditor = false
    
    
    class func playSound(_ soundName: String?) {
        var name = soundName
        if nil == name {
            name = "noticeMusic.caf"
        }
        
        guard let path = LyUtil.filePath(forFileName: name) else {
            return
        }
        
        guard let url = NSURL(string: path) else {
            return
        }
        
        var id: SystemSoundID = 0
        AudioServicesCreateSystemSoundID(url, &id)
        AudioServicesPlaySystemSound(id)
    }
    
    
    
    
    class func showAlertSingleFunc(target: UIViewController, title: String?, message: String?, funcTitle: String?, funcStyle: UIAlertActionStyle = .default, preferredStyle: UIAlertControllerStyle = .alert, handler: ( (UIAlertAction) -> Swift.Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        alert.addAction( UIAlertAction(title: NSLocalizedString("ok", comment: "ok"), style: .cancel, handler: nil))
        if let funcTitle = funcTitle {
            alert.addAction( UIAlertAction(title: funcTitle, style: funcStyle, handler: handler))
        }
        
        target.present(alert, animated: true, completion: nil)
    }
    
    class func confirmAlert(target: UIViewController, title: String?, message: String?, handler: ( (UIAlertAction) -> Swift.Void)? = nil) {
        showAlertSingleFunc(target: target, title: title, message: message, funcTitle: nil, funcStyle: .default, preferredStyle: .alert, handler: handler)
    }
    
    
    
    
    
    open func choosePhoto(_ target: UIViewController, editor: Bool = false, options: PhotoSource = [.camera, .photoLibrary], finished: @escaping imageFinished) {
        
        self.imageFinished = finished
        self.isEditor = editor
        
        if options.contains(.camera) && options.contains(.photoLibrary) {
            let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                actionSheet.addAction( UIAlertAction(title: NSLocalizedString("Take Photo", comment: "Take Photo"), style: .default) { [unowned self] (_) -> Swift.Void in
                    self.openCamera(target, editor: editor)
                })
            }
            
            actionSheet.addAction( UIAlertAction(title: NSLocalizedString("Choose from Album", comment: "Choose From Album"), style: .default) { [unowned self] (_) -> Swift.Void in
                self.openPhotoLibrary(target, editor: editor)
            })
            
            actionSheet.addAction( UIAlertAction(title: NSLocalizedString("cancel", comment: "cancel"), style: .cancel, handler: nil))
            
            target.present(actionSheet, animated: true, completion: nil)
            
            
        } else if options.contains(.camera) {
            openCamera(target, editor: editor)
            
        } else if options.contains(.photoLibrary) {
            openPhotoLibrary(target, editor: editor)
            
        }
    }
    
    open func openCamera(_ target: UIViewController, editor: Bool = false) {
        
//        let authStatus = AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo)
//        if .restricted == authStatus || .denied == authStatus {
//            LyJurisdictionUtil.showAlertSingleFunc(target: target, title: "", message: <#T##String?#>, funcTitle: <#T##String?#>, funcStyle: <#T##UIAlertActionStyle#>, preferredStyle: <#T##UIAlertControllerStyle#>, handler: <#T##((UIAlertAction) -> Void)?##((UIAlertAction) -> Void)?##(UIAlertAction) -> Void#>)
//        }
        
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = editor
        
        target.present(imagePicker, animated: true, completion: nil)
    }
    
    open func openPhotoLibrary(_ target: UIViewController, editor: Bool = false) {
        
        
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = editor
        
        target.present(imagePicker, animated: true, completion: nil)
    }
    
    
    
    
    
    
    
    
    
}



// MARK: - UIImagePickerControllerDelegate
// MARK: - UINavigationControllerDelegate
extension LyJurisdictionUtil: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        picker.dismiss(animated: true) { [unowned self] () -> Swift.Void in
            guard let image = info[self.isEditor ? UIImagePickerControllerEditedImage : UIImagePickerControllerOriginalImage] as? UIImage else {
                return
            }
            
            guard let imgFinished = self.imageFinished else {
                return
            }
            
            imgFinished(image)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}




