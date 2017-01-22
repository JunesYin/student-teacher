//
//  LyWebViewController.swift
//  student
//
//  Created by MacMini on 2017/1/10.
//  Copyright © 2017年 517xueche. All rights reserved.
//

import UIKit
import WebKit


fileprivate let webMinFont: CGFloat = 14

fileprivate let progressKey = "estimatedProgress"


fileprivate enum LyWebBarButtonItemTag: Int {
    case close = 10, refresh
}

@objc(LyWebViewController)
class LyWebViewController: UIViewController {

    public var mode: LyWebMode = .userProtocol {
        didSet {
            reloadData_url()
        }
    }
    var urlStr: String?
    
    var bbiSpace: UIBarButtonItem!
    var bbiClose: UIBarButtonItem!
    var bbiRefresh: UIBarButtonItem!
    
    var webView: WKWebView!
    var progressView: UIProgressView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initSubviews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        addObserver()
        load()
        
        update()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        removeObserver()
    }
    
    func initSubviews() {
        self.view.backgroundColor = LyWhiteLightgrayColor
        self.automaticallyAdjustsScrollViewInsets = false
        self.navigationItem.leftItemsSupplementBackButton = true
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .done, target: nil, action: nil)
        
        
        bbiSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
            
        bbiClose = UIBarButtonItem(title: "关闭", style: .done, target: self, action: #selector(actionForBarButtonItem(_:)))
        bbiClose.tag = LyWebBarButtonItemTag.close.rawValue
        
        bbiRefresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(actionForBarButtonItem(_:)))
        bbiRefresh.tag = LyWebBarButtonItemTag.refresh.rawValue
        
        self.navigationItem.rightBarButtonItem = bbiRefresh
        
        
        let config = WKWebViewConfiguration()
        config.preferences = WKPreferences()
        config.preferences.minimumFontSize = webMinFont
        config.preferences.javaScriptEnabled = true
        config.preferences.javaScriptCanOpenWindowsAutomatically = true
        
        webView = WKWebView(frame: CGRect(x: 0, y: STATUSBAR_NAVIGATIONBAR_HEIGHT, width: SCREEN_WIDTH, height: APPLICATION_HEIGHT), configuration: config)
        webView.navigationDelegate = self
        webView.uiDelegate = self
        webView.allowsBackForwardNavigationGestures = true
        
        progressView = UIProgressView(frame: CGRect(x: 0, y: STATUSBAR_NAVIGATIONBAR_HEIGHT, width: SCREEN_WIDTH, height: verticalSpace))
        progressView.trackTintColor = .white
        progressView.progressTintColor = Ly517ThemeColor
        
        
        
        self.view.addSubview(webView)
        self.view.addSubview(progressView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func actionForBarButtonItem(_ bbi: UIBarButtonItem) {
        let bbiTag = LyWebBarButtonItemTag(rawValue: bbi.tag)!
        switch bbiTag {
        case .close:
//            self.dismiss(animated: true, completion: nil)
            _ = self.navigationController?.popViewController(animated: true)
        case .refresh:
            webView.reload()
        }
    }
    
    
    func update() {
        if webView.canGoBack {
            self.navigationItem.leftBarButtonItem = bbiClose
        } else {
            self.navigationItem.leftBarButtonItem = nil
        }
    }
    
    
    func addObserver() {
        webView.addObserver(self, forKeyPath: progressKey, options: [.new], context: nil)
        webView.addObserver(self, forKeyPath: "URL", options: [.new], context: nil)
    }
    
    func removeObserver() {
        webView.removeObserver(self, forKeyPath: progressKey)
        webView.removeObserver(self, forKeyPath: "URL")
    }
    
    func reloadData_url() {
        switch mode {
        case .userProtocol:
            self.title = "517协议"
            urlStr = userProtocol_url
            
        case .FAQ:
            self.title = "常见问题"
            urlStr = FAQ_url
            
        case .studyFlow:
            self.title = "学车流程"
            urlStr = guide_studyFlow_url
        case .outline:
            self.title = "学车大纲"
            urlStr = guide_outline_url
        case .selectionGuide:
            self.title = "择校指南"
            urlStr = guide_selectionGuide_url
        case .applyNote:
            self.title = "报名须知"
            urlStr = guide_applyNote_url
        case .physicalExam:
            self.title = "体检事项"
            urlStr = guide_physicalExam_url
        case .studyFee:
            self.title = "学车费用"
            urlStr = guide_studyFee_url
        case .cheating:
            self.title = "修弊处理"
            urlStr = guide_cheating_url
        case .deformedMan:
            self.title = "残疾人学车"
            urlStr = guide_deformedMan_url
            
        case .studySelf:
            self.title = "自学直考"
            urlStr = selfStudy_url
        case .studyCost:
            self.title = "学车成本"
            urlStr = studyCost_url
            
            
        case .schoolProtocol:
            self.title = "517协议"
            urlStr = schoolProtocol_url
        case .coaInsProtocol:
            self.title = "517协议"
            urlStr = coaInsProtocol_url
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
extension LyWebViewController {
    func load() {
        guard nil != urlStr else {
            return
        }
        
        let url = URL(string: urlStr!)
        guard nil != url else {
            return
        }
        
        let request = URLRequest(url: url!)
        webView.load(request)
    }
}



// MARK: - KVO
extension LyWebViewController {
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if progressKey == keyPath {
            progressView.progress = Float(self.webView.estimatedProgress)
            
            if self.webView.estimatedProgress >= 1.0 {
                UIView.animate(withDuration: LyAnimationDuration, animations: {
                    self.progressView.alpha = 0
                    self.progressView.progress = 0
                })
                
            } else {
                self.progressView.alpha = 1
            }
            
        }
        
    }
}


// MARK: - backButtonHandler
extension LyWebViewController {
    override func navigationShouldPopOnBackButton() -> Bool {
        if webView.canGoBack {
            webView.goBack()
            return false
        }
        
        return true
    }
}



// MARK: - WKNavigationDelegate
extension LyWebViewController: WKNavigationDelegate{
    // 单独处理。但是，对于Safari是允许跨域的，不用这么处理。
    // 这个是决定是否Request
    @available(iOS 8.0, *)
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Swift.Void) {
        if nil == navigationAction.targetFrame {
            webView.load(navigationAction.request)
        }
        
        decisionHandler(.allow)
    }
    
    // 决定是否接收响应
    // 这个是决定是否接收response
    // 要获取response，通过WKNavigationResponse对象获取
    @available(iOS 8.0, *)
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Swift.Void) {
        decisionHandler(.allow)
    }
    
    // 页面开始加载时调用
    @available(iOS 8.0, *)
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        
    }
    
    // 接收到服务器跳转请求之后调用 //接收到服务重定向时，会回调此方法
    @available(iOS 8.0, *)
    func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        
    }
    
    // 页面开始加载数据失败时，会回调
    @available(iOS 8.0, *)
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        
    }
    
    // 当内容开始返回时调用
    @available(iOS 8.0, *)
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        
    }
    
    // 页面加载完成之后调用
    @available(iOS 8.0, *)
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        update()
    }
    
    // 当main frame最后下载数据失败时，会回调
    @available(iOS 8.0, *)
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        
    }
    
    // 需要验证证书时调用
    @available(iOS 8.0, *)
    func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Swift.Void) {
//        completionHandler()
        
        let cred = URLCredential(trust: challenge.protectionSpace.serverTrust!)
        completionHandler(.useCredential, cred)
    }
    
    // 当web content处理完成时，会回调
    @available(iOS 9.0, *)
    func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
        
    }
}



// MARK: - WKUIDelegate
extension LyWebViewController: WKUIDelegate {
    // WKWebView创建初始化加载的一些配置
    @available(iOS 8.0, *)
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        return nil
    }
    
    //处理WKWebView关闭的事件
    @available(iOS 9.0, *)
    func webViewDidClose(_ webView: WKWebView) {
        
    }
    
    // 处理网页js中的提示框,若不使用该方法,则提示框无效
    @available(iOS 8.0, *)
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Swift.Void) {
        
    }
    
    // 处理网页js中的确认框,若不使用该方法,则确认框无效
    @available(iOS 8.0, *)
    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Swift.Void) {
        
    }
    
    // 处理网页js中的文本输入
    @available(iOS 8.0, *)
    func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (String?) -> Swift.Void) {
        
    }
    
    // 是否允许预览 -- 3D Touch
    @available(iOS 10.0, *)
    func webView(_ webView: WKWebView, shouldPreviewElement elementInfo: WKPreviewElementInfo) -> Bool {
        return false
    }
    
    // 预览ViweContoller -- 3D Touch
    @available(iOS 10.0, *)
    func webView(_ webView: WKWebView, previewingViewControllerForElement elementInfo: WKPreviewElementInfo, defaultActions previewActions: [WKPreviewActionItem]) -> UIViewController? {
        return nil
    }
    
    // 提交预览ViewController -- 3D Touch
    @available(iOS 10.0, *)
    func webView(_ webView: WKWebView, commitPreviewingViewController previewingViewController: UIViewController) {
        
    }
    
}





