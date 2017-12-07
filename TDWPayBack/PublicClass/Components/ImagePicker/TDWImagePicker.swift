//
//  TDWImagePicker.swift
//  TuanDaiV4
//
//  Created by John on 2017/10/18.
//  Copyright © 2017年 Dee. All rights reserved.
//

import Foundation
import LocalAuthentication
import AVFoundation
import Photos

class TDWImagePicker: NSObject {

    typealias completed = (UIImage?) -> Void
    typealias cancel = () -> Void

    var completed: completed?
    var cancel: cancel?

    func showActionSheet(_ inViewController: UIViewController, completed: completed?, cancel: cancel?) {
        self.completed = completed
        self.cancel = cancel
        let alertViewController = UIAlertController(title: "请选择上传类型", message: nil, preferredStyle: .actionSheet)
        let firstAction = UIAlertAction(title: "从手机相册选择", style: .default) { (action) in
            //打开手机相册
            if self.checkALAssetsLibraryAuthorized() {
                let imagePicker = UIImagePickerController()
                imagePicker.sourceType = .savedPhotosAlbum
                imagePicker.allowsEditing = true
                imagePicker.delegate = self
                inViewController.navigationController?.present(imagePicker, animated: true, completion: nil)
            }else {
                let guideVC = TDWPhotoAlbumGuideViewController(false)
                inViewController.navigationController?.pushViewController(guideVC, animated: true)
            }
        }
        let secondAction = UIAlertAction(title: "拍照", style: .default) { (action) in
            //拍照
            if !UIImagePickerController.isSourceTypeAvailable(.camera){
                UIAlertView(title: nil, message: "设备不支持照相功能", delegate: nil, cancelButtonTitle: "确定").show()
                return
            }

            if self.checkAVCaptureDeviceAuthorized() {
                let imagePicker = UIImagePickerController()
                imagePicker.sourceType = .camera
                imagePicker.allowsEditing = true
                imagePicker.delegate = self
                inViewController.navigationController?.present(imagePicker, animated: true, completion: nil)
            }else {
                let guideVC = TDWPhotoAlbumGuideViewController(true)
                inViewController.navigationController?.pushViewController(guideVC, animated: true)
            }
        }
        let cancleAction = UIAlertAction(title: "取消", style: .cancel) {[weak self] (action) in
            self?.cancel?()
        }
        alertViewController.addAction(firstAction)
        alertViewController.addAction(secondAction)
        alertViewController.addAction(cancleAction)
        inViewController.present(alertViewController, animated: true, completion: nil)
    }

    /// 检测相机是否授权访问
    func checkAVCaptureDeviceAuthorized() -> Bool {
        let  status = AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo)
        switch status {
        case .notDetermined, .authorized:
            return true
        default:
            return false
        }
    }

    /// 检测相册是否授权访问
    func checkALAssetsLibraryAuthorized() -> Bool {
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .notDetermined, .authorized:
            return true
        default:
            return false
        }
    }
}
extension TDWImagePicker: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true) { [weak self] in
            self?.cancel?()
        }
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let editedImage = info[UIImagePickerControllerEditedImage] as? UIImage
        picker.dismiss(animated: true) { [weak self] in
            self?.completed?(editedImage)
        }
    }
}
