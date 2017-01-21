//
//  LyUserInfoTableViewController.swift
//  student
//
//  Created by MacMini on 2017/1/11.
//  Copyright © 2017年 517xueche. All rights reserved.
//

import UIKit
import SwiftyJSON
import AssetsLibrary
import AVFoundation

fileprivate let uiViewHeaderHeight: CGFloat = 200
fileprivate let uiIvAvatarSize: CGFloat = 70

fileprivate let uiTfNameHeight: CGFloat = 30
fileprivate let uiTfNameFont = LySFont(16)
fileprivate let uiBtnModifySize: CGFloat = 20


enum LyUserInfoModifyMode: Int {
    case avatar = 100, sex, birthday, address, driveLicense, signature
}


fileprivate let lyUserInfoTableViewCellReuseIdentifier = "lyUserInfoTableViewCellReuseIdentifier"
fileprivate let countSection_0 = 4
fileprivate let countSection_1 = 1
fileprivate let countSection_2 = 2


@objc(LyUserInfoTableViewController)
class LyUserInfoTableViewController: UITableViewController {

    let arrTitle = ["性别",
                    "生日",
                    "手机号",
                    "地址",
                    
                    "驾照类型",
                    
                    "我的签名",
                    "我的二维码"]
    var curIdx: IndexPath!
    var nextAvatar: UIImage!
    
    var viewError: UIView?
    
    var viewHeader: UIView!
    var ivBack: UIImageView!
    var ivAvatar: UIImageView!
    var tfName: UITextField!
    var btnModify: UIButton!
    
    let indicator = LyIndicator(title: "")
    let indicator_oper = LyIndicator(title: "")
    
    
    override init(style: UITableViewStyle) {
        super.init(style: .grouped)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        initSubviews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.setBackgroundImage(LyUtil.image(forImageName: "uci_navigatinBar", needCache: false), for: .default)
        self.navigationController?.navigationBar.shadowImage = LyUtil.image(forImageName: "uci_navigatinBar", needCache: false)
        UIApplication.shared.statusBarStyle = .lightContent
        
        reloadData_header()
        
        if LyUtil.flagForGetUserInfo() {
            self.reloadData()
        } else {
            load(false)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        self.navigationController?.navigationBar.shadowImage = nil
        UIApplication.shared.statusBarStyle = .default
    }
    
    func initSubviews() {
        self.automaticallyAdjustsScrollViewInsets = false
        self.view.backgroundColor = LyWhiteLightgrayColor
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .done, target: nil, action: nil)
        
        
        
        viewHeader = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: uiViewHeaderHeight))
        
        ivBack = UIImageView(frame: viewHeader.bounds)
        ivBack.contentMode = .scaleAspectFill
        ivBack.image = LyUtil.image(forImageName: "viewInfo_background_s", needCache: false)
        
        ivAvatar = UIImageView(frame: CGRect(x: SCREEN_WIDTH/2.0 - uiIvAvatarSize/2.0, y: uiViewHeaderHeight - (uiIvAvatarSize + verticalSpace + uiTfNameHeight) - horizontalSpace, width: uiIvAvatarSize, height: uiIvAvatarSize))
        ivAvatar.contentMode = .scaleAspectFill
        ivAvatar.layer.cornerRadius = uiIvAvatarSize / 2.0
        ivAvatar.clipsToBounds = true
        ivAvatar.isUserInteractionEnabled = true
        ivAvatar.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(actionForTapGestureFromIvAvatar)))
        
        tfName = UITextField(frame: CGRect(x: 0, y: ivAvatar.ly_y + uiIvAvatarSize + verticalSpace, width: SCREEN_WIDTH, height: uiTfNameHeight))
        tfName.delegate = self
        tfName.font = uiTfNameFont
        tfName.textColor = .white
        tfName.backgroundColor = .clear
        tfName.textAlignment = .center
        
        btnModify = UIButton(frame: CGRect(x: 0, y: uiTfNameHeight/2.0 - uiBtnModifySize/2.0, width: uiBtnModifySize, height: uiBtnModifySize))
        btnModify.setBackgroundImage(LyUtil.image(forImageName: "ui_btn_pen", needCache: false), for: .normal)
        btnModify.addTarget(self, action: #selector(actionForButton(_:)), for: .touchUpInside)
        
        tfName.leftView = UIView(frame: CGRect(x: 0, y: 0, width: uiBtnModifySize, height: uiBtnModifySize))
        tfName.rightView = btnModify
        tfName.leftViewMode = .always
        tfName.rightViewMode = .always
        
        viewHeader.addSubview(ivBack)
        viewHeader.addSubview(ivAvatar)
        viewHeader.addSubview(tfName)
        
        self.tableView.tableHeaderView = viewHeader
        self.tableView.register(LyUserInfoTableViewCell.self, forCellReuseIdentifier: lyUserInfoTableViewCellReuseIdentifier)
        self.tableView.rowHeight = ucicHeight
        self.tableView.sectionHeaderHeight = 0
        self.tableView.sectionFooterHeight = horizontalSpace * 2
        
        self.refreshControl = LyUtil.refreshControl(withTitle: "", target: self, action: #selector(refresh))
        
    }
    
    func reloadData() {
        removeViewError()
        
        LyUtil.setFinishGetUserIfo(true)
        
        reloadData_header()

        self.tableView.reloadData()
    }
    
    func reloadData_header() {
        if let avatar = LyCurrentUser.cur().userAvatar {
            ivAvatar.image = avatar
        } else {
            
            ivAvatar.sd_setImage(with: LyUtil.getUserAvatarUrl(withUserId: LyCurrentUser.cur().userId),
                                 placeholderImage: LyUtil.defaultAvatarForStudent(),
                                 options: .retryFailed,
                                 completed: { [weak ivAvatar] (image, _, _, _) in
                                    if nil != image {
                                        LyCurrentUser.cur().userAvatar = image
                                    } else {
                                        ivAvatar?.sd_setImage(with: LyUtil.getJpgUserAvatarUrl(withUserId: LyCurrentUser.cur().userId),
                                                              placeholderImage: LyUtil.defaultAvatarForStudent(),
                                                              options: .retryFailed,
                                                              completed: { (image, _, _, _) in
                                                                if nil != image {
                                                                    LyCurrentUser.cur().userAvatar = image
                                                                }
                                        })
                                    }
            })
        }
        
        setUserName(LyCurrentUser.cur().userName!)
        
    }
    
    func setUserName(_ userName: String) {
        let rect = userName.boundingRect(with: CGSize(width: SCREEN_WIDTH - uiBtnModifySize * 2, height: uiTfNameHeight),
                                         options: NSStringDrawingOptions.usesLineFragmentOrigin,
                                         attributes: [NSFontAttributeName: tfName.font!],
                                         context: nil)
        let fWidth = rect.width + uiBtnModifySize * 2 + horizontalSpace
        
        tfName.frame = CGRect(x: SCREEN_WIDTH/2.0 - fWidth/2.0, y: tfName.ly_y, width: fWidth, height: uiTfNameHeight)
        tfName.text = userName
    }
    
    func reloadTableViewCellWithMode(_ mode: LyUserInfoModifyMode) {
        self.tableView.reloadRows(at: [curIdx], with: .left)
    }
    
    func showViewError() {
        if nil == viewError {
            viewError = UIView(frame: CGRect(x: 0, y: viewHeader.ly_y + uiViewHeaderHeight, width: SCREEN_WIDTH, height: APPLICATION_HEIGHT))
            viewError?.backgroundColor = LyWhiteLightgrayColor
            
            viewError?.addSubview(LyUtil.lbError(withMode: 0))
        }
        
        self.tableView.addSubview(viewError!)
    }
    
    func removeViewError() {
        viewError?.removeFromSuperview()
        viewError = nil
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func actionForButton(_ btn: UIButton) {
        let modifyName = LyModifyNameViewController()
        modifyName.delegate = self
        self.navigationController?.pushViewController(modifyName, animated: true)
    }
    
    
    func refresh() {
        load(true)
    }
    
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}



// MARK: - Show
extension LyUserInfoTableViewController {
    
    
    func actionForTapGestureFromIvAvatar() {
        let action = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        action.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            action.addAction(UIAlertAction(title: "拍照", style: .default) { [unowned self] (_) -> Swift.Void in
                func showImagePickerForCamera() {
                    let authStatus = AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo)
                    if .restricted == authStatus || .denied == authStatus {
                        let alert  = UIAlertController(title: alertTitleForCamera, message: alertMessageForCamera, preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
                        alert.addAction(UIAlertAction(title: "设置", style: .default) { [unowned self] (_) -> Swift.Void in
                            let url = URL(string: UIApplicationOpenSettingsURLString)
                            if nil != url && UIApplication.shared.canOpenURL(url!) {
                                LyUtil.open(url!)
                            } else {
                                LyUtil.showAlert(.camera, vc: self)
                            }
                            }
)
                        
                        self.present(alert, animated: true, completion: nil)
                    }
                    
                    let imagePicker = UIImagePickerController()
                    imagePicker.delegate = self
                    imagePicker.isEditing = true
                    imagePicker.sourceType = .camera
                    
                    UIApplication.shared.statusBarStyle = .default
                    self.present(imagePicker, animated: true, completion: nil)
                }

                
                showImagePickerForCamera()
            })
        }
        
        action.addAction(UIAlertAction(title: "从相册选择", style: .default) { [unowned self] (_) -> Swift.Void in
            func showImagePickerForAlbum() {
                let authStatus = ALAssetsLibrary.authorizationStatus()
                if .restricted == authStatus || .denied == authStatus {
                    let alert  = UIAlertController(title: alertTitleForAlbum, message: alertMessageForAlbum, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
                    alert.addAction(UIAlertAction(title: "设置", style: .default) { [unowned self] (_) -> Swift.Void in
                        let url = URL(string: UIApplicationOpenSettingsURLString)
                        if nil != url && UIApplication.shared.canOpenURL(url!) {
                            LyUtil.open(url!)
                        } else {
                            LyUtil.showAlert(.album, vc: self)
                        }
                    })
                    
                    self.present(alert, animated: true, completion: nil)
                }
                
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.isEditing = true
                imagePicker.sourceType = .photoLibrary
                
                UIApplication.shared.statusBarStyle = .default
                self.present(imagePicker, animated: true, completion: nil)
            }
            
            showImagePickerForAlbum()
        })
        
        self.present(action, animated: true, completion: nil)
    }
    
    func showActionForSex() {
        let action = UIAlertController(title: "请选择性别", message: nil, preferredStyle: .actionSheet)
        action.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
        action.addAction(UIAlertAction(title: "男", style: .default) { [unowned self] (UIAlertAction) -> Swift.Void in
            self.modify(.sex, para: LySex.male.rawValue)
        })
        action.addAction(UIAlertAction(title: "女", style: .default) { [unowned self] (UIAlertAction) -> Swift.Void in
            self.modify(.sex, para: LySex.female.rawValue)
        })
        
        self.present(action, animated: true, completion: nil)
    }
    
    
    
    
    func startModify() {
        indicator_oper.startAnimation(in: self.view)
    }
    
    func stopModify(_ isSuccessful: Bool) {
        indicator_oper.stopAnimation()
        
        if  isSuccessful {
            LyRemindView.remind(with: .success, withTitle: "修改成功").show()
        } else {
            LyRemindView.remind(with: .fail, withTitle: "修改失败").show()
        }
    }

}



// MARK: - HttpRequest
extension LyUserInfoTableViewController {
    func load(_ isRefresh: Bool) {
        if isRefresh || !LyUtil.flagForGetUserInfo() {
            indicator.startAnimation(in: self.view)
            
            LyHttpRequest.start(userInfo_url,
                                body: [userIdKey: LyCurrentUser.cur().userId,
                                       userTypeKey: userTypeStudentKey,
                                       sessionIdKey: LyUtil.httpSessionId()],
                                type: .asynPost,
                                timeOut: 0) { [unowned self] (resStr, _, error) in
                                    guard nil != resStr else {
                                        self.handleHttpFailed(true)
                                        return
                                    }
                                    
                                    let json: JSON! = analysisHttpResult(resStr!, delegate: self)
                                    guard nil != json && .dictionary == json.type else {
                                        self.handleHttpFailed(true)
                                        return
                                    }
                                    
                                    let iCode = json[codeKey].intValue
                                    switch iCode {
                                    case 0:
                                        let dicResult: Dictionary! = json[resultKey].dictionaryValue
                                        guard nil != dicResult else {
                                            self.handleHttpFailed(true)
                                            return
                                        }
                                        
                                        let sName = dicResult[nickNameKey]?.stringValue
                                        let iSex = dicResult[sexKey]?.intValue
                                        let sLicense = dicResult[driveLicenseKey]?.stringValue
                                        
                                        let sBirthday = dicResult[birthdayKey]?.string
                                        let sSignature = dicResult[signatureKey]?.string
                                        let sAddress = dicResult[addressKey]?.string
                                        
                                        let sex = LySex(rawValue: iSex!)!
                                        let license = LyUtil.driveLicense(from: sLicense)
                                        
                                        LyCurrentUser.cur().userName = sName
                                        LyCurrentUser.cur().userSex = sex
                                        LyCurrentUser.cur().userLicenseType = license
                                        
                                        if nil != sBirthday {
                                            LyCurrentUser.cur().userBirthday = sBirthday!
                                        }
                                        
                                        if nil != sSignature {
                                            LyCurrentUser.cur().userSignature = sSignature!
                                        }
                                        
                                        if nil != sAddress {
                                            LyCurrentUser.cur().userAddress = sAddress!
                                        }
                                        
                                        
                                        self.reloadData()
                                        self.indicator.stopAnimation()
                                        self.refreshControl?.endRefreshing()
                                        
                                    default:
                                        self.handleHttpFailed(true)
                                    }
            }
            
        } else {
            reloadData()
            
            self.refreshControl?.endRefreshing()
        }
    }
    
    
    func modify(_ mode: LyUserInfoModifyMode, para: Any) {
        var sKey = ""
        switch mode {
        case .avatar:
            startModify()
            
            let newAvatar = para as! UIImage
            
            LyHttpRequest.sendAvatar(byHttp: modifyUserInfo_url,
                                     image: newAvatar,
                                     body: [pathKey: pngKey,
                                            userIdKey: LyCurrentUser.cur().userId,
                                            userTypeKey: userTypeStudentKey,
                                            sessionIdKey: LyUtil.httpSessionId()],
                                     completionHandler: { [unowned self] (_, resData, error) in
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
                                            self.ivAvatar.image = newAvatar
                                            LyUtil.save(newAvatar, withUserId: LyCurrentUser.cur().userId, with: .avatar)
                                            
                                            self.stopModify(true)
                                        default:
                                            self.handleHttpFailed(true)
                                        }
            })
            
            return
        case .sex:
            sKey = sexKey
        case .birthday:
            sKey = birthdayKey
        case .address:
            sKey = addressKey
        case .driveLicense:
            sKey = driveLicenseKey
        case .signature:
            return
        }
        
        let sPara = "\(para)"
        
        startModify()
        LyHttpRequest.start(modifyUserInfo_url,
                            body: [sKey: sPara,
                                   userIdKey: LyCurrentUser.cur().userId,
                                   userTypeKey: userTypeStudentKey,
                                   sessionIdKey: LyUtil.httpSessionId()],
                            type: .asynPost,
                            timeOut: 0) { [unowned self] (_, resData, error) in
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
                                    switch mode {
                                    case .avatar:
                                        break
                                    case .sex:
                                        LyCurrentUser.cur().userSex = LySex(rawValue: Int(sPara)!)!
                                    case .birthday:
                                        LyCurrentUser.cur().userBirthday = sPara
                                    case .address:
                                        LyCurrentUser.cur().userAddress = sPara
                                    case .driveLicense:
                                        LyCurrentUser.cur().userLicenseType = LyUtil.driveLicense(from: sPara)
                                    case .signature:
                                        break
                                    }
                                    
                                    self.reloadTableViewCellWithMode(mode)
                                    
                                    self.stopModify(true)
                                    
                                default:
                                    self.handleHttpFailed(true)
                                }
                                
        }
    }
}



// MARK: - LySUtilDelegate
extension LyUserInfoTableViewController: LySUtilDelegate {
    func handleHttpFailed(_ needRemind: Bool) {
        if indicator.isAnimating() {
            indicator.stopAnimation()
            self.refreshControl?.endRefreshing()
            
            showViewError()
        }
        
        if indicator_oper.isAnimating() {
            stopModify(false)
        }
    }
}


// MARK: - UITextFieldDelegate
extension LyUserInfoTableViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return false
    }
}


// MARK: - UIImagePickerDelegate
extension LyUserInfoTableViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true) { [unowned self] in
            var image = info[UIImagePickerControllerOriginalImage] as! UIImage
            image = UIImage.fixOrientation(image)
            let imageEditor = VPImageCropperViewController(image: image,
                                                           cropFrame: CGRect(x: 0, y: 100, width: self.view.ly_width, height: self.view.ly_width),
                                                           limitScaleRatio: 3)
            imageEditor?.delegate = self
            self.present(imageEditor!, animated: true, completion: nil)
        }
    }
}


// MARK: - UINavigationControllerDelegate
extension LyUserInfoTableViewController: UINavigationControllerDelegate { }


// MARK: - VPImageCropperDelegate
extension LyUserInfoTableViewController: VPImageCropperDelegate {
    func imageCropperDidCancel(_ cropperViewController: VPImageCropperViewController!) {
        cropperViewController.dismiss(animated: true, completion: nil)
    }
    
    func imageCropper(_ cropperViewController: VPImageCropperViewController!, didFinished editedImage: UIImage!) {
        cropperViewController.dismiss(animated: true) { [unowned self] in
            if editedImage != LyCurrentUser.cur().userAvatar {
                self.modify(.avatar, para: editedImage)
            }
        }
    }
}


// MARK: - LyModifyNameViewControllerDelegate
extension LyUserInfoTableViewController: LyModifyNameViewControllerDelegate {
    func modifyNameViewController(_ modifyNameVC: LyModifyNameViewController!, modifyDone name: String!) {
        _ = modifyNameVC.navigationController?.popToViewController(self, animated: true)
    }
}


// MARK: - LyDatePickerDelegate
extension LyUserInfoTableViewController: LyDatePickerDelegate {
    func onBtnDoneClick(_ date: Date!, datePicker aDatePicker: LyDatePicker!) {
        let newDate = LyUtil.stringOnlyYMD(fromDate: date)
        
        if newDate! != LyCurrentUser.cur().userBirthday! {
            modify(.birthday, para: newDate!)
        }
    }
}


// MARK: - LyModifyPhoneViewControllerDelegate
extension LyUserInfoTableViewController: LyModifyPhoneViewControllerDelegate {
    func onDone(byModifyPhoneVC aModifyPhoneVC: LyModifyPhoneViewController!) {
        _ = aModifyPhoneVC.navigationController?.popToViewController(self, animated: true)
        
        LyUtil.showLoginVc(self)
    }
}


// MARK: - LyAddressPickerDelegate
extension LyUserInfoTableViewController: LyAddressPickerDelegate {
    func onAddressPickerDone(_ address: String!, addressPicker: LyAddressPicker!) {
        addressPicker.hide()
        
        if address != LyCurrentUser.cur().userAddress {
            modify(.address, para: address)
        }
    }
}


// MARK: - LyDriveLicensePickerDelegate
extension LyUserInfoTableViewController: LyDriveLicensePickerDelegate {
    func onDriveLicensePickerDone(_ picker: LyDriveLicensePicker!, license: LyLicenseType) {
        picker.hide()
        
        if license != LyCurrentUser.cur().userLicenseType {
            modify(.driveLicense, para: LyUtil.driveLicenseString(from: license)!)
        }
    }
}


// MARK: - LyModifySignatureViewControllerDelegate 
extension LyUserInfoTableViewController: LyModifySignatureViewControllerDelegate {
    func modifySignatureViewController(_ aModifySignatureVC: LyModifySignatureViewController!, done signature: String!) {
        _ = aModifySignatureVC.navigationController?.popToViewController(self, animated: true)
        
        reloadTableViewCellWithMode(.signature)
    }
}


// MARK: - UITableViewDelegate
extension LyUserInfoTableViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        curIdx = indexPath
        self.tableView.deselectRow(at: curIdx, animated: true)
        
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                showActionForSex()
            case 1:
                let datePicker = LyDatePicker()
                datePicker.delegate = self
                datePicker.setDateWith(LyCurrentUser.cur().userBirthday)
                datePicker.show()
            case 2:
                let modifyPhone = LyModifyPhoneViewController()
                modifyPhone.delegate = self
                self.navigationController?.pushViewController(modifyPhone, animated: true)
            case 3:
                let addressPicker = LyAddressPicker(mode: .provinceAndCity)
                addressPicker?.delegate = self
                addressPicker?.address = LyCurrentUser.cur().userAddress
                addressPicker?.show()
            default:
                break
            }
        case 1:
            switch indexPath.row {
            case 0:
                let driveLicensePicker = LyDriveLicensePicker()
                driveLicensePicker.delegate = self
                driveLicensePicker.setInitDriveLicense(LyCurrentUser.cur().userLicenseType)
                driveLicensePicker.show()
            default:
                break
            }
        case 2:
            switch indexPath.row {
            case 0:
                let modifySignatrue = LyModifySignatureViewController()
                modifySignatrue.delegate = self
                self.navigationController?.pushViewController(modifySignatrue, animated: true)
            case 1:
                let myQRCode = LyMyQRCodeViewController()
                self.navigationController?.pushViewController(myQRCode, animated: true)
            default:
                break
            }
        default:
            break
        }
    }
}

// MARK: - Table view data source
extension LyUserInfoTableViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        var iCount = 0
        switch section {
        case 0:
            iCount = countSection_0
        case 1:
            iCount = countSection_1
        case 2:
            iCount = countSection_2
        default:
            iCount = 0
        }
        
        return iCount
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: LyUserInfoTableViewCell! = tableView.dequeueReusableCell(withIdentifier: lyUserInfoTableViewCellReuseIdentifier, for: indexPath) as! LyUserInfoTableViewCell
        
        if nil == cell {
            cell = LyUserInfoTableViewCell(style: .default, reuseIdentifier: lyUserInfoTableViewCellReuseIdentifier)
        }
        
        
        var iIdxTitle = 0
        var sDetail: String?
        var bIsQRCode = false
        
        switch indexPath.section {
        case 0:
            iIdxTitle = 0 + indexPath.row
            switch indexPath.row {
            case 0:
                sDetail = LyUtil.sexString(from: LyCurrentUser.cur().userSex)
            case 1:
                sDetail = "\(LyCurrentUser.cur().userAge)岁"
            case 2:
                sDetail = LyUtil.hidePhoneNumber(LyCurrentUser.cur().userPhoneNum)!
            case 3:
                sDetail = LyCurrentUser.cur().userAddress
            default:
                sDetail = nil
            }
        case 1:
            iIdxTitle = countSection_0 + indexPath.row
            switch indexPath.row {
            case 0:
                sDetail = LyCurrentUser.cur().userLicenseTypeByString()
            default:
                sDetail = nil
            }
        case 2:
            iIdxTitle = countSection_0 + countSection_1 + indexPath.row
            switch indexPath.row {
            case 0:
                sDetail = LyCurrentUser.cur().userSignature
            case 1:
                sDetail = nil
                bIsQRCode = true
            default:
                sDetail = nil
            }
        default:
            sDetail = nil
        }
        
        cell.setCellInfo(arrTitle[iIdxTitle], detail: sDetail, isQRCode: bIsQRCode)
        
        return cell
    }

}


// MARK: - UIScrollViewDelegate
extension LyUserInfoTableViewController {
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.ly_offsetY < 0 {
            let newHeight = uiViewHeaderHeight - scrollView.ly_offsetY
            let newWidth = SCREEN_WIDTH * newHeight / uiViewHeaderHeight
            
            let newX = (SCREEN_WIDTH - newWidth) / 2.0
            let newY = scrollView.ly_offsetY
            
            ivBack.frame = CGRect(x: newX, y: newY, width: newWidth, height: newHeight)
        } else {
            ivBack.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: uiViewHeaderHeight)
        }
    }
}

