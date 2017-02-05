//
//  LyAskViewController.swift
//  student
//
//  Created by MacMini on 2016/12/26.
//  Copyright © 2016年 517xueche. All rights reserved.
//

import UIKit
import SwiftyJSON


@objc protocol LyAskViewControllerDelegate {
    func userByAskViewController(_ aAskVC: LyAskViewController) -> LyUser
    
    func askDoneByAskViewController(_ aAskVC: LyAskViewController, con: LyConsult)
}

@objc(LyAskViewController)
class LyAskViewController: UIViewController {

    enum LyAskBarButtonItemTag: Int {
        case ask = 10
    }
    
    enum LyAskTextViewTag: Int {
        case ask = 20
    }
    
    weak var delegate: LyAskViewControllerDelegate?
    var user: LyUser!
    var con: LyConsult!
    
    var bbiAsk: UIBarButtonItem!
    var tvAsk: UITextView!
    
    
    var indicator: LyIndicator? = LyIndicator(title: LyIndicatorTitle_ask)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        initSubviews()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        user = delegate?.userByAskViewController(self)
        guard nil != user else {
            _ = self.navigationController?.popViewController(animated: true)
            return
        }
        
    }
    
    func initSubviews() {
        self.title = "提问"
        self.automaticallyAdjustsScrollViewInsets = false
        self.view.backgroundColor = LyWhiteLightgrayColor
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .done, target: nil, action: nil)
        
        
        bbiAsk = UIBarButtonItem(title: "提问", style: UIBarButtonItemStyle.done, target: self, action: #selector(actionForBarButtonItem(_:)))
        bbiAsk.tag = LyAskBarButtonItemTag.ask.rawValue
        self.navigationItem.rightBarButtonItem = bbiAsk
        
        
        tvAsk = UITextView(frame: CGRect(x: 0, y: STATUSBAR_NAVIGATIONBAR_HEIGHT + 20, width: SCREEN_WIDTH, height: 177))
        tvAsk.tag = LyAskTextViewTag.ask.rawValue
        tvAsk.font = UIFont.systemFont(ofSize: 14)
        tvAsk.textColor = .black
        tvAsk.textAlignment = .left
        tvAsk.layer.cornerRadius = btnCornerRadius
        tvAsk.clipsToBounds = true
        tvAsk.backgroundColor = .white
        tvAsk.returnKeyType = .done
        tvAsk.delegate = self
        tvAsk.placeholder = "问点什么！"
        tvAsk.textCount = LyEvaluationLengthMax
        tvAsk.textContainerInset = UIEdgeInsets(top: verticalSpace, left: horizontalSpace, bottom: verticalSpace, right: horizontalSpace)
        
        self.view.addSubview(tvAsk)
        
        bbiAsk.isEnabled = false
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        allControlResignFirstResponder()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func actionForBarButtonItem(_ bbi: UIBarButtonItem) {
        allControlResignFirstResponder()
        
        let bbiTag = LyAskBarButtonItemTag(rawValue: bbi.tag)!
        switch bbiTag {
        case .ask:
            ask()
        }
    }
    
    func allControlResignFirstResponder() {
        tvAsk.resignFirstResponder()
    }
    
    func validate(_ needRemind: Bool) -> Bool {
        
        bbiAsk.isEnabled = false
        
        guard LyUtil.validateString(tvAsk.text!) else {
            if needRemind {
                LyRemindView.remind(with: LyRemindViewMode.warn, withTitle: "还没有内容").show()
            }
            return false
        }
        
        bbiAsk.isEnabled = true
        
        return true
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



// MARK: - HttpRequest
extension LyAskViewController {
    func ask() {
        guard LyCurrentUser.cur().isLogined else {
//            LyUtil.showLoginVc(self)
            LyUtil.showLoginVc(self, action: #selector(ask), object: nil)
            return
        }
        
        guard validate(true) else {
            return
        }
        
        indicator?.startAnimation()
        
        _ = self .perform(#selector(LyAskViewController.ask_genuine), with: nil, afterDelay: validateSensitiveWordDelayTime)
    }
    
    internal func ask_genuine() {
        guard (tvAsk.text?.validateSensitiveWord())! else {
            indicator?.stopAnimation()
            
            LyRemindView.remind(with: LyRemindViewMode.warn, withTitle: LyRemindTitle_sensitiveWord).show()
            return
        }
        
        
        LyHttpRequest.start(ask_url,
                            body: [contentKey: tvAsk.text!,
                                   objectIdKey: user.userId,
                                   masterIdKey: LyCurrentUser.cur().userId,
                                   sessionIdKey: LyUtil.httpSessionId(),
                                   userTypeKey: user.userTypeByString()],
                            type: .asynPost,
                            timeOut: 0) { [unowned self] (resStr, resData, error) in
                                guard nil == error && nil != resData else {
                                    self.handleHttpFailed(true)
                                    return
                                }
                                
                                let json: JSON! = analysisHttpResult(resData!, delegate: self)
                                guard nil != json && .dictionary == json.type else {
                                    self.handleHttpFailed(true)
                                    return
                                }
                                
                                let iCode: Int = json[codeKey].int!
                                switch iCode {
                                case 0:
                                    let dicResult: Dictionary? = json[resultKey].dictionary
                                    guard nil != dicResult else {
                                        self.handleHttpFailed(true)
                                        return
                                    }
                                    
                                    let sId = dicResult?[idKey]?.stringValue
                                    var sTime = dicResult?[timeKey]?.stringValue
                                    sTime = LyUtil.fixDateTime(sTime!)
                                    
                                    self.con = LyConsult(id: sId,
                                                         time: sTime,
                                                         masterId: LyCurrentUser.cur().userId,
                                                         objectId: self.user.userId,
                                                         content: self.tvAsk.text!)
                                    
                                    self.indicator?.stopAnimation()
                                    
                                    let remind = LyRemindView.remind(with: LyRemindViewMode.success, withTitle: "提问成功")
                                    remind?.delegate = self
                                    remind?.show()
                                    
                                    break
                                default:
                                    self.handleHttpFailed(true)
                                    break
                                }
                                
        }
    }
}



// MARK: - LySUtilDelegate
extension LyAskViewController: LySUtilDelegate {
    func handleHttpFailed(_ needRemind: Bool) {
        if (indicator?.isAnimating())! {
            indicator?.stopAnimation()
            
            LyRemindView.remind(with: LyRemindViewMode.fail, withTitle: "提问失败").show()
        }
    }
}


// MARK: - LyRemindViewDelegate
extension LyAskViewController: LyRemindViewDelegate {
    func remindViewDidHide(_ aRemind: LyRemindView!) {
        delegate?.askDoneByAskViewController(self, con: con)
    }
}


// MARK: - UITextViewDelegate
extension LyAskViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        _ = validate(false)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let tvTag = LyAskTextViewTag(rawValue: textView.tag)!
        switch tvTag {
        case .ask:
            if text == "\n" {
                tvAsk.resignFirstResponder()
                return false
            }
        }


        return true
    }
    
}



