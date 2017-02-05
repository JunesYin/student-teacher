//
//  LyFeedbackViewController.swift
//  student
//
//  Created by MacMini on 2017/1/10.
//  Copyright © 2017年 517xueche. All rights reserved.
//

import UIKit
import SwiftyJSON


fileprivate let fbTvContentHeight: CGFloat = 177
fileprivate let fbTvContentFont = LySFont(14)

fileprivate let fbBtnCommitWidth = SCREEN_WIDTH / 2.0
fileprivate let fbBtnCommitHeight: CGFloat = 40


class LyFeedbackViewController: UIViewController {
    
    var tvContent: UITextView!
    var btnCommit: UIButton!
    
    let indicator = LyIndicator(title: "")

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        initSubviews()
    }
    
    func initSubviews() {
        self.title = "意见反馈"
        self.view.backgroundColor = LyWhiteLightgrayColor
        self.automaticallyAdjustsScrollViewInsets = false
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .done, target: nil, action: nil)
        
        
        
        tvContent = UITextView(frame: CGRect(x: 0, y: STATUSBAR_NAVIGATIONBAR_HEIGHT + horizontalSpace, width: SCREEN_WIDTH, height: fbTvContentHeight))
        tvContent.font = LySFont(14)
        tvContent.textAlignment = .left
        tvContent.textColor = LyBlackColor
        tvContent.backgroundColor = .white
        tvContent.textContainerInset = UIEdgeInsetsMake(verticalSpace, horizontalSpace, verticalSpace, horizontalSpace)
        tvContent.placeholder = "请输入你宝贵的意见或建议"
        tvContent.textCount = LyEvaluationLengthMax
        tvContent.delegate = self
        tvContent.returnKeyType = .send
        
        
        btnCommit = UIButton(frame: CGRect(x: SCREEN_WIDTH/2.0 - fbBtnCommitWidth/2.0, y: tvContent.frame.origin.y + fbTvContentHeight + 30, width: fbBtnCommitWidth, height: fbBtnCommitHeight))
        btnCommit.setTitle("提交", for: .normal)
        btnCommit.setTitleColor(.white, for: .normal)
        btnCommit.backgroundColor = Ly517ThemeColor
        btnCommit.layer.cornerRadius = btnCornerRadius
        btnCommit.clipsToBounds = true
        btnCommit.addTarget(self, action: #selector(actionForButton(_:)), for: .touchUpInside)
        
        
        self.view.addSubview(tvContent)
        self.view.addSubview(btnCommit)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        allConResignFirstResponder()
    }
    
    func allConResignFirstResponder() {
        tvContent.resignFirstResponder()
    }
    
    
    func actionForButton(_ btn: UIButton) {
        if "" == tvContent.text {
            LyRemindView.remind(with: .warn, withTitle: "还没有内容").show()
            return
        }
        
        if !LyCurrentUser.cur().isLogined {
            let alert = UIAlertController(title: "请登录", message: "感谢你提交宝贵的意见和建议，请登录", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "登录", style: .default) { [unowned self] (UIAlertAction) -> Swift.Void in
                self.commit()
            })
            alert.addAction(UIAlertAction(title: "直接提交", style: .cancel) { [unowned self] (UIAlertAction) -> Swift.Void in
//                LyUtil.showLoginVc(self)
                LyUtil.showLoginVc(self, action: #selector(self.actionForButton(_:)), object: btn)
            })
            
        } else {
            commit()
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


// MARK: - HttpRequest
extension LyFeedbackViewController {
    func commit() {
        indicator.startAnimation()
        
        _ = perform(#selector(commit_genuine), with: nil, afterDelay: LyDelayTime)
    }
    
    func commit_genuine() {
        if !tvContent.text.validateSensitiveWord() {
            indicator.stopAnimation()
            
            LyRemindView.remind(with: .warn, withTitle: LyRemindTitle_sensitiveWord).show()
            return
        }
        
        var para = [contentKey: tvContent.text]
        if LyCurrentUser.cur().isLogined {
            para[userIdKey] = LyCurrentUser.cur().userId
            para[sessionIdKey] = LyUtil.httpSessionId()
        }
        
        LyHttpRequest.start(feedback_url,
                            body: para,
                            type: .asynPost,
                            timeOut: 0) { [unowned self] (resStr, resData, error) in
                                guard nil != resData else {
                                    self.handleHttpFailed(true)
                                    return
                                }
                                
                                let json: JSON! = analysisHttpResult(resData!, delegate: self)
                                guard nil != json && .null != json.type else {
                                    self.handleHttpFailed(true)
                                    return
                                }
                                
                                let iCode = json[codeKey].intValue
                                switch iCode {
                                case 0:
                                    self.indicator.stopAnimation()
                                    
                                    let remind = LyRemindView.remind(with: .success, withTitle: "提交成功")
                                    remind?.delegate = self
                                    remind?.show()
                                    
                                default:
                                    self.handleHttpFailed(true)
                                }
        }
    }
}


// MARK: - LySUtilDelegate
extension LyFeedbackViewController: LySUtilDelegate {
    func handleHttpFailed(_ needRemind: Bool) {
        if indicator.isAnimating() {
            indicator.stopAnimation()
            
            LyRemindView.remind(with: .fail, withTitle: "提交失败").show()
        }
    }
}


// MARK: - LyRemindViewDelegate
extension LyFeedbackViewController: LyRemindViewDelegate {
    func remindViewDidHide(_ aRemind: LyRemindView!) {
        _ = self.navigationController?.popViewController(animated: true)
    }
}


// MARK: - UITextViewDelegate
extension LyFeedbackViewController: UITextViewDelegate {
//    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
//        textView.resignFirstResponder()
//        
//        actionForButton(btnCommit)
//        return true
//    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if "\n" == text {
            textView.resignFirstResponder()
            
            actionForButton(btnCommit)
            return false
        }
        
        return true
    }
    
    
}
