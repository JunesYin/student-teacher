//
//  LyScanQRCodeViewController.swift
//  student
//
//  Created by MacMini on 2017/1/17.
//  Copyright © 2017年 517xueche. All rights reserved.
//

import UIKit
import AVFoundation
import CoreImage


import SwiftyJSON




fileprivate let sqScanPaneSize: CGFloat = 247

fileprivate let sqScanMarginW: CGFloat = 30
fileprivate let sqScanMarginH: CGFloat = 50


fileprivate let sqViewBarHeight: CGFloat = 80
fileprivate let sqBtnCount: CGFloat = 3.0
fileprivate let sqBtnWidth: CGFloat = 100
fileprivate let sqBtnHeight = sqViewBarHeight
fileprivate let sqBtnMarginX = (SCREEN_WIDTH - sqBtnWidth * sqBtnCount) / (sqBtnCount + 1.0)
fileprivate let sqBtnMarginY = (sqViewBarHeight - sqBtnHeight) / 2.0




fileprivate let sqScanGridAnimationKey = "LyScanGrid"
fileprivate let sqScanGridKeyPath = "transform.translation.y"
fileprivate let sqScanAnimationDuration: TimeInterval = 1.5


fileprivate enum LyScanQRCodeButtonTag: Int {
    case myQRCode = 20, album, light
}


@objc(LyScanQRCodeViewController)
class LyScanQRCodeViewController: UIViewController {

    
    var userId: String!
    
    var device: AVCaptureDevice?
    var scanSession: AVCaptureSession?
    lazy var scanPane: UIView = { [unowned self] in
        let view = UIView(frame: CGRect(x: SCREEN_WIDTH/2.0 - sqScanPaneSize/2.0, y: SCREEN_HEIGHT/2.0 - (sqScanPaneSize + verticalSpace * 4 + 50)/2.0, width: sqScanPaneSize, height: sqScanPaneSize))
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        
        //边框
        let edge: CGFloat = 30
//        let ivTopLeft = UIImageView(frame: CGRect(x: view.ly_x, y: view.ly_y, width: edge, height: edge))
//        let ivTopRight = UIImageView(frame: CGRect(x: view.ly_x + sqScanPaneSize, y: view.ly_y, width: edge, height: edge))
//        let ivBottomLeft = UIImageView(frame: CGRect(x: view.ly_x, y: view.ly_y + sqScanPaneSize, width: edge, height: edge))
//        let ivBottomRight = UIImageView(frame: CGRect(x: view.ly_x + sqScanPaneSize, y: view.ly_y + sqScanPaneSize, width: edge, height: edge))
        let ivTopLeft = UIImageView(frame: CGRect(x: 0, y: 0, width: edge, height: edge))
        let ivTopRight = UIImageView(frame: CGRect(x: sqScanPaneSize - edge, y: 0, width: edge, height: edge))
        let ivBottomLeft = UIImageView(frame: CGRect(x: 0, y: sqScanPaneSize - edge, width: edge, height: edge))
        let ivBottomRight = UIImageView(frame: CGRect(x: sqScanPaneSize - edge, y: sqScanPaneSize - edge, width: edge, height: edge))
        ivTopLeft.image = LyUtil.image(forImageName: "scan_1", needCache: false)
        ivTopRight.image = LyUtil.image(forImageName: "scan_2", needCache: false)
        ivBottomLeft.image = LyUtil.image(forImageName: "scan_3", needCache: false)
        ivBottomRight.image = LyUtil.image(forImageName: "scan_4", needCache: false)
        
        view.addSubview(ivTopLeft)
        view.addSubview(ivTopRight)
        view.addSubview(ivBottomLeft)
        view.addSubview(ivBottomRight)
        
        //阴影
        self.view.addSubview({ [unowned view] in
            let viewMaskSize = (SCREEN_HEIGHT - view.ly_centerY) * 2
            let viewMask = UIView(frame: CGRect(x: 0, y: 0, width: viewMaskSize, height: viewMaskSize))
            viewMask.center = view.center
            viewMask.backgroundColor = .clear
            viewMask.layer.borderWidth = (viewMaskSize - sqScanPaneSize)/2.0
            viewMask.layer.borderColor = LyMaskColor.cgColor
            return viewMask
        }())
        
        return view
    }()
    lazy var scanGrid: UIImageView = { [unowned self] in
        let iv = UIImageView(image: LyUtil.image(forImageName: "scan_net", needCache: false))
        iv.ly_size = self.scanPane.ly_size
        return iv
    }()
    
    lazy var lbRemind: UILabel = { [unowned self] in
        let lb = UILabel(frame: CGRect(x: horizontalSpace, y: self.scanPane.ly_y + sqScanPaneSize + verticalSpace * 4, width: SCREEN_WIDTH - horizontalSpace * 2, height: 50))
        lb.font = LySFont(14)
        lb.textColor = .white
        lb.textAlignment = .center
        lb.numberOfLines = 0
        lb.text = "将二维码放入取景框内\n即可自动扫描"
        return lb
    }()
    
    lazy var viewBar: UIView = { [unowned self] in
        let view = UIView(frame: CGRect(x: 0, y: SCREEN_HEIGHT - sqViewBarHeight, width: SCREEN_WIDTH, height: sqViewBarHeight))
        view.backgroundColor = UIColor(white: 25.0/255.0, alpha: 0.9)
        view.addSubview(self.btnMyQRCode)
        view.addSubview(self.btnAlbum)
        view.addSubview(self.btnLight)
        
        return view
    }()
    lazy var btnMyQRCode: UIButton = { [unowned self] in
        self.button(with: .myQRCode)
    }()
    lazy var btnAlbum: UIButton = { [unowned self] in
        self.button(with: .album)
    }()
    lazy var btnLight: UIButton = { [unowned self] in
        self.button(with: .light)
    }()
    
    
    lazy var indicator: LyIndicator = {
        LyIndicator(title: nil)
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        initSubviews()
        
    }
    
    func initSubviews() {
        self.title = "扫一扫"
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .done, target: nil, action: nil)
        
        
        scanPane.addSubview(scanGrid)
        
        view.addSubview(scanPane)
        view.addSubview(lbRemind)
        view.addSubview(viewBar)
        
        setupScanSession()
    }
    
    private func button(with tag: LyScanQRCodeButtonTag) -> UIButton {
        let tag_real = tag.rawValue
        let btn = UIButton(frame: CGRect(x: sqBtnMarginX * CGFloat(tag_real - LyScanQRCodeButtonTag.myQRCode.rawValue + 1) + sqBtnWidth * CGFloat(tag_real - LyScanQRCodeButtonTag.myQRCode.rawValue) , y: sqBtnMarginY, width: sqBtnWidth, height: sqBtnHeight))
        btn.tag = tag_real
        btn.addTarget(self, action: #selector(actionForButton(_:)), for: .touchUpInside)
        switch tag {
        case .myQRCode:
            btn.setImage(LyUtil.image(forImageName: "sweep_btn_0", needCache: false), for: .normal)
        case .album:
            btn.setImage(LyUtil.image(forImageName: "sweep_btn_1", needCache: false), for: .normal)
        case .light:
            btn.setImage(LyUtil.image(forImageName: "sweep_btn_2_n", needCache: false), for: .normal)
            btn.setImage(LyUtil.image(forImageName: "sweep_btn_2_h", needCache: false), for: .selected)
        }
        
        return btn
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupScanSession() {
        do {
            // set capture device
            device = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
            // set device input
            let input = try AVCaptureDeviceInput(device: device!)
            // set device output 
            let output = AVCaptureMetadataOutput()
            output.setMetadataObjectsDelegate(self, queue: .main)
            
            // set session
            let scanSession = AVCaptureSession()
            scanSession.canSetSessionPreset(AVCaptureSessionPresetHigh)
            
            if scanSession.canAddInput(input) {
                scanSession.addInput(input)
            }
            
            if scanSession.canAddOutput(output) {
                scanSession.addOutput(output)
            }
            
            // set scan metadata type --
            output.metadataObjectTypes = [AVMetadataObjectTypeQRCode,
                                          AVMetadataObjectTypeCode39Code,
                                          AVMetadataObjectTypeCode128Code,
                                          AVMetadataObjectTypeCode39Mod43Code,
                                          AVMetadataObjectTypeEAN13Code,
                                          AVMetadataObjectTypeEAN8Code,
                                          AVMetadataObjectTypeCode93Code]
            
            // preview layer
            let scanPreviewLayer = AVCaptureVideoPreviewLayer(session: scanSession)
            scanPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
            scanPreviewLayer?.frame = view.layer.bounds
            
            if let scanPreviewLayer = scanPreviewLayer {
                view.layer.insertSublayer(scanPreviewLayer, at: 0)
            }
            
            // set scan area
            NotificationCenter.default.addObserver(forName: NSNotification.Name.AVCaptureInputPortFormatDescriptionDidChange, object: nil, queue: nil, using: { [weak output] (notificatoin) in
                output?.rectOfInterest = (scanPreviewLayer?.metadataOutputRectOfInterest(for: self.scanPane.frame))!
            })
            
            
            // save session
            self.scanSession = scanSession
            
        } catch {
            LySPrint("setupScanSession--摄像头不可用")
            
            
            
            return
        }
    }
    
    
    func startScan() {
        scanGrid.layer.add(scanAnimation(), forKey: sqScanGridAnimationKey)
        
        guard nil != scanSession else {
            return
        }
        
        scanSession?.startRunning()
    }
    
    
    func scanAnimation() -> CAAnimation {
        var animation: CABasicAnimation? = scanGrid.layer.animation(forKey: sqScanGridAnimationKey) as! CABasicAnimation?
        if nil == animation {
            
            animation = CABasicAnimation(keyPath: sqScanGridKeyPath)
            animation?.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
            animation?.fromValue = -sqScanPaneSize
            animation?.toValue = 0
            animation?.duration = sqScanAnimationDuration
            animation?.repeatCount = MAXFLOAT
            
        }
        
        return animation!
    }
    
    
    func switchLight() {
        do {
            try device?.lockForConfiguration()
            device?.torchMode = (btnLight.isSelected) ? .on : .off
            device?.unlockForConfiguration()
        } catch {
            LySPrint("switchLight失败")
        }
        
    }

    func actionForButton(_ btn: UIButton) {
        let tag = LyScanQRCodeButtonTag(rawValue: btn.tag)!
        switch tag {
        case .myQRCode:
            let myQRCode = LyMyQRCodeViewController()
            self.navigationController?.pushViewController(myQRCode, animated: true)
        case .album:
            LyJurisdictionUtil.shared.choosePhoto(self, editor: false, options: [.photoLibrary]) { [unowned self] (image) -> Swift.Void in
                self.discernQRCode(image)
            }
        case .light:
            btn.isSelected = !btn.isSelected
            switchLight()
        }
    }
    
    func discernQRCode(_ image: UIImage) {
        let detector = CIDetector(ofType: CIDetectorTypeQRCode, context: nil, options: [CIDetectorAccuracy: CIDetectorAccuracyHigh])
        let features = detector?.features(in: CoreImage.CIImage(cgImage: image.cgImage!))
        guard (features?.count)! > 0 else {
            handleQRCodeContent(nil)
            return
        }
        
        let feature = features?.first as? CIQRCodeFeature
        
        handleQRCodeContent(feature?.messageString)
    }
    
    func handleQRCodeContent(_ content: String?) {
        guard nil != content else {
            LyJurisdictionUtil.confirmAlert(target: self, title: nil, message: "当前二维码无有效数据") { [unowned self] (_) -> Swift.Void in
                self.startScan()
            }
            
            return
        }
        
        if let url = URL(string: content!) {
            if LyJurisdictionUtil.openUrl(url) {
                return
            }
        }
        
        
        judgeUserId(content!)
        
    }
    
    
    func displayContent(_ content: String) {
        LyJurisdictionUtil.confirmAlert(target: self, title: nil, message: content) { [unowned self] (_) in
            self.startScan()
        }
    }
    
    
    func judgeUserId(_ content: String) {
        guard "" != content else {
            return
        }
        
        userId = content
        
        indicator.title = "正在处理"
        indicator.startAnimation()
        
        LyHttpRequest.start(issetUserId_url,
                            body: [userIdKey: content],
                            type: .asynPost,
                            timeOut: 0) { [unowned self, weak indicator] (_, resData, _) in
                                guard nil != resData else {
                                    self.handleHttpFailed(true)
                                    return
                                }
                                
                                let json: JSON! = analysisHttpResult(resData!, delegate: self)
                                guard nil != json && .dictionary == json.type else {
                                    self.handleHttpFailed(true)
                                    return
                                }
                                
                                let iCode = json[codeKey].intValue
                                switch iCode {
                                case 0:
                                    
                                    indicator?.stopAnimation()
                                    
                                    let userDetail = LyUserDetailViewController()
                                    userDetail.delegate = self
                                    
                                    if LyCurrentUser.cur().isLogined {
                                        self.navigationController?.pushViewController(userDetail, animated: true)
                                    } else {
                                        LyUtil.showLoginVc(self, nextVC: userDetail, show: .push)
                                    }
                                    
                                default:
                                    self.handleHttpFailed(true)
                                }
        }
    }
    
    
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}



// MARK: - Life Cycle
extension LyScanQRCodeViewController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        indicator.title = ""
        indicator.startAnimation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let videoStatus = AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo)
        if videoStatus == .restricted || videoStatus == .denied {
            let alert = UIAlertController.init(title: "请打开相机权限", message: "请前往系统【设置】>【稳私】>【相机】允许“我要去学车”访问相机", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "取消", style: .cancel) { [unowned self] (_) -> Swift.Void in
                _ = self.navigationController?.popViewController(animated: true)
            })
            
            alert.addAction(UIAlertAction(title: "设置", style: .default) { (_) -> Swift.Void in
                _ = LyJurisdictionUtil.openUrl(NSURL(string: UIApplicationOpenSettingsURLString) as! URL)
            })
            
            self.present(alert, animated: true) { [unowned self] in
                self.indicator.stopAnimation()
            }
            
            return
        }
        
        startScan()
        
        indicator.stopAnimation()
    }
    
}



// MARK:  - LySUtilDelegate
extension LyScanQRCodeViewController: LySUtilDelegate {
    func handleHttpFailed(_ needRemind: Bool) {
        indicator.stopAnimation()
        
        displayContent(userId)
    }
}



// MARK: - AVCaptureMetadataOutputObjectsDelegate
extension LyScanQRCodeViewController: AVCaptureMetadataOutputObjectsDelegate {
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        scanGrid.layer.removeAllAnimations()
        scanSession?.stopRunning()
        
        if metadataObjects.count > 0 {
            if let result = metadataObjects.first as? AVMetadataMachineReadableCodeObject {
                handleQRCodeContent(result.stringValue)
            }
        }
    }
}


// MARK: - LyUserDetailViewControllerDelegate
extension LyScanQRCodeViewController: LyUserDetailDelegate {
    func obtainUserId() -> String! {
        return userId
    }
}
