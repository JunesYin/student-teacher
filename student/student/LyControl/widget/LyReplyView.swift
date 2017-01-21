//
//  LyReplyView.swift
//  teacher
//
//  Created by MacMini on 2017/1/4.
//  Copyright © 2017年 517xueche. All rights reserved.
//

import UIKit


@objc protocol LyReplyViewDelegate {
    func sendByReplyView(_ aReplyView: LyReplyView, text: String)
}


fileprivate let repViewContentHeight = CGFloat(70)
fileprivate let repTvCOntentFont = LySFont(14)


@objc(LyReplyView)
class LyReplyView: UIView, UITextViewDelegate {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    
    var btnMask: UIButton!
    
    var viewContent: UIView!
    var tvContent: UITextView!
    

    var vcCenter: CGPoint!
    var delegate: LyReplyViewDelegate?
    
    
    convenience init(delegate: LyReplyViewDelegate) {
        self.init(frame: SCREEN_BOUNDS)
        
        self.delegate = delegate
    }
    
    override init(frame: CGRect) {
        super.init(frame: SCREEN_BOUNDS)
        
        initSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initSubviews() {
        
        btnMask = UIButton(frame: SCREEN_BOUNDS)
        btnMask.backgroundColor = UIColor.clear
        btnMask.addTarget(self, action: #selector(actionForButton), for: .touchUpInside)
        
        viewContent = UIView(frame: CGRect(x: 0, y: SCREEN_HEIGHT - repViewContentHeight, width: SCREEN_WIDTH, height: repViewContentHeight))
        viewContent.backgroundColor = LyWhiteLightgrayColor
        vcCenter = viewContent.center
        
        tvContent = UITextView(frame: CGRect(x: horizontalSpace, y : verticalSpace, width: SCREEN_WIDTH - horizontalSpace * 2, height: repViewContentHeight - verticalSpace * 2))
        tvContent.font = repTvCOntentFont
        tvContent.textColor = LyBlackColor
        tvContent.layer.borderWidth = 1
        tvContent.layer.borderColor = UIColor.gray.cgColor
        tvContent.layer.cornerRadius = 2
        tvContent.clipsToBounds = true
        tvContent.textCount = LyReplyLengthMax
        tvContent.returnKeyType = UIReturnKeyType.send
        tvContent.delegate = self
        
        viewContent.addSubview(tvContent)
        
        addSubview(btnMask)
        addSubview(viewContent)
    }
    
    
    public func showInView(_ view: UIView) {
        
        addObserverForKeyboard()
        
        view.addSubview(self)
        
        LyUtil.startAnimation(with: viewContent,
                              animationDuration: LyAnimationDuration,
                              initialPoint: CGPoint(x: vcCenter.x, y: vcCenter.y + repViewContentHeight),
                              destinationPoint: CGPoint(x: vcCenter.x, y: vcCenter.y),
                              completion: nil)
        
        LyUtil.startAnimation(with: btnMask,
                              animationDuration: LyAnimationDuration,
                              initAlpha: 0,
                              destinationAplhas: 1,
                              completion: nil)
        
        tvContent?.perform(#selector(becomeFirstResponder), with: nil, afterDelay: LyAnimationDuration - 0.2)
    }
    
    
    public func show() {
        showInView(UIApplication.shared.keyWindow!)
    }
    
    public func hide() {
        tvContent.resignFirstResponder()
        
        removeObserverForKeyboard()
        
        LyUtil.startAnimation(with: viewContent,
                              animationDuration: LyAnimationDuration,
                              initialPoint: CGPoint(x: vcCenter.x, y: vcCenter.y),
                              destinationPoint: CGPoint(x: vcCenter.x, y: vcCenter.y + repViewContentHeight),
                              completion: nil)
        
        LyUtil.startAnimation(with: btnMask,
                              animationDuration: LyAnimationDuration,
                              initAlpha: 1,
                              destinationAplhas: 0) { (isFinished) in
                                self.removeFromSuperview()
        }

    }
    
    
    public func send() {
        if Int(tvContent.text.characters.count) > Int(LyReplyLengthMax) {
            LyRemindView.remind(with: .warn, withTitle: "内容太长").show()
        } else {
            delegate?.sendByReplyView(self, text: tvContent.text)
        }
    }
    
    
    internal func addObserverForKeyboard() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(actionForKeyboardWillShow(_:)),
                                               name: NSNotification.Name.UIKeyboardWillShow,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(actionForKeyboardWillHide(_:)),
                                               name: NSNotification.Name.UIKeyboardWillHide,
                                               object: nil)
    }
    
    internal func removeObserverForKeyboard() {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    
    internal func actionForButton() {
        hide()
    }

    
    
    // MARK： - UIKeyboardWillShow
    internal func actionForKeyboardWillShow(_ notification: Notification) {
        let fHeight_kb = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.size.height
        
        viewContent.frame = CGRect(x: 0, y: SCREEN_HEIGHT - fHeight_kb - repViewContentHeight, width: SCREEN_WIDTH, height: repViewContentHeight)
    }
    
    // MARK: - UIKeyboardWillHide
    internal func actionForKeyboardWillHide(_ notification: Notification) {
        hide()
    }
    
    
    
    // MARK: - UITextViewDelegate
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "" {
            return true
        }
        
        if text == "\n" {
            if "" != textView.text {
                send()
            } else {
                hide()
            }
            return false
        }
        
        return true
    }
    
}
