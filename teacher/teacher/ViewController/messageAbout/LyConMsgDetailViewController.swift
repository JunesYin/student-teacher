//
//  LyConMsgDetailViewController.swift
//  teacher
//
//  Created by MacMini on 2017/1/5.
//  Copyright © 2017年 517xueche. All rights reserved.
//

import UIKit
import SwiftyJSON


protocol LyConMsgDetailViewControllerDelegate {
    func consultByConMsgDetailViewController(_ aConMsgDetailVC: LyConMsgDetailViewController) -> LyConsult!
}


// MARK: - CONSTANT
fileprivate let cmdIvAvatarSize = CGFloat(40)

fileprivate var cmdLbNameWidth: CGFloat = 0
fileprivate let cmdLbNameHeight = CGFloat(20)
fileprivate let cmdLbNameFont = LySFont(14)
fileprivate let cmdLbTimeFont = LySFont(12)
fileprivate let cmdTvContentFont = LySFont(13)

fileprivate let cmdBtnReplyHeight = LyViewItemHeight

fileprivate let lyConMsgDetailTableViewCellReuseIdentifier = "lyConMsgDetailTableViewCellReuseIdentifier"

fileprivate enum LyConMsgDetailButtonTag: Int {
    case reply = 20
}


class LyConMsgDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, LySUtilDelegate, LyReplyViewDelegate {
    
    var delegate: LyConMsgDetailViewControllerDelegate?
    var con: LyConsult!
    var arrRep = [LyReply]()
    
    
    var viewHeader: UIView!
    var ivAvatar: UIImageView!
    var lbName: UILabel!
    var lbTime: UILabel!
    var tvContent: UITextView!
    var line: UIView!
    
    var tableView: UITableView!
    var btnReply: UIButton!
    
    let indicator = LyIndicator(title: "")
    let indicator_oper = LyIndicator(title: "")
    var refreshControl: UIRefreshControl!
    
    var viewError: UIView?
    var viewNull: UIView?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        initSubviews()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        con = delegate?.consultByConMsgDetailViewController(self)
        
        guard nil != con else {
            _ = self.navigationController?.popViewController(animated: true)
            return
        }
        
        reloadData_header()
        
        if arrRep.isEmpty {
            load()
        }
    }
    
    
    func initSubviews() {
        cmdLbNameWidth = SCREEN_WIDTH - horizontalSpace * 3 - cmdIvAvatarSize
        
        self.title = "咨询详情"
        self.view.backgroundColor = LyWhiteLightgrayColor
        self.automaticallyAdjustsScrollViewInsets = false
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .done, target: nil, action: nil)
        
        viewHeader = UIView()
        viewHeader.backgroundColor = UIColor.white
        
        ivAvatar = UIImageView(frame: CGRect(x: horizontalSpace, y: verticalSpace, width: cmdIvAvatarSize, height: cmdIvAvatarSize))
        ivAvatar.contentMode = .scaleAspectFill
        ivAvatar.layer.cornerRadius = cmdIvAvatarSize / 2.0
        ivAvatar.clipsToBounds = true
        
        lbName = UILabel(frame: CGRect(x: horizontalSpace * 2 + cmdIvAvatarSize, y: verticalSpace, width: cmdLbNameWidth, height: cmdLbNameHeight))
        lbName.font = cmdLbNameFont
        lbName.textColor = LyBlackColor
        
        lbTime = UILabel(frame: CGRect(x: horizontalSpace * 2 + cmdIvAvatarSize,
                                       y: verticalSpace + cmdLbNameHeight,
                                       width: cmdLbNameWidth,
                                       height: cmdLbNameHeight))
        lbTime.font = cmdLbTimeFont
        lbTime.textColor = UIColor.gray
        
        tvContent = UITextView()
        tvContent.font = cmdTvContentFont
        tvContent.textColor = UIColor.darkGray
        tvContent.isEditable = false
        tvContent.isScrollEnabled = false
        
        line = UIView()
        line.backgroundColor = LyWhiteLightgrayColor
        
        viewHeader.addSubview(ivAvatar)
        viewHeader.addSubview(lbName)
        viewHeader.addSubview(lbTime)
        viewHeader.addSubview(tvContent)
        viewHeader.addSubview(line)
        
        
        tableView = UITableView(frame: CGRect(x: 0, y: STATUSBAR_NAVIGATIONBAR_HEIGHT, width: SCREEN_WIDTH, height: APPLICATION_HEIGHT - cmdBtnReplyHeight),
                                style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = LyWhiteLightgrayColor
        tableView.separatorStyle = .none
        
        
        refreshControl = LyUtil.refreshControl(withTitle: nil, target: self, action: #selector(refresh))
        
        tableView.addSubview(refreshControl)
        
        
        btnReply = UIButton(frame: CGRect(x: 0, y: SCREEN_HEIGHT - cmdBtnReplyHeight, width: SCREEN_WIDTH, height: cmdBtnReplyHeight))
        btnReply.tag = LyConMsgDetailButtonTag.reply.rawValue
        btnReply.setTitle("回复", for: .normal)
        btnReply.setTitleColor(Ly517ThemeColor, for: .normal)
        btnReply.backgroundColor = .white
        btnReply.addTarget(self, action: #selector(actionForButton(_:)), for: .touchUpInside)
        
        
        self.view.addSubview(tableView)
        self.view.addSubview(btnReply)
        
        
        arrRep = []
    }
    
    
    func reloadData() {
        removeViewError()
        removeViewNull()
        
//        reloadData_header()
        
        arrRep = LyUtil.uniquifyAndSort(arrRep, keyUniquify: "oId", keySort: "time", asc: true) as! [LyReply]
        
        tableView.reloadData()
    }
    
    func reloadData_header() {
        let master = LyUserManager.sharedInstance().getUserWithUserId(con.masterId)
        if let avatar = master?.userAvatar {
            ivAvatar.image = avatar
        } else {
            ivAvatar.sd_setImage(with: LyUtil.getUserAvatarUrl(withUserId: con.masterId),
                                 placeholderImage: LyUtil.defaultAvatarForStudent(),
                                 options: .retryFailed,
                                 completed: { [weak ivAvatar, weak con] (image, _, _, _) in
                                    if nil != image {
                                        master?.userAvatar = image
                                    } else {
                                        ivAvatar?.sd_setImage(with: LyUtil.getUserAvatarUrl(withUserId: con?.masterId),
                                                             placeholderImage: LyUtil.defaultAvatarForStudent(),
                                                             options: .retryFailed,
                                                             completed: { (image, _, _, _) in
                                                                if nil != image {
                                                                    master?.userAvatar = image
                                                                }
                                        })
                                    }
            })
        }
        
        lbName.text = master?.userName
        
        lbTime.text = LyUtil.translateTime(con.time)
        
        tvContent.text = con.content
        let fHeightTvContent = tvContent.sizeThatFits(CGSize(width: SCREEN_WIDTH - horizontalSpace * 2, height: CGFloat.greatestFiniteMagnitude)).height
        tvContent.frame = CGRect(x: horizontalSpace, y: ivAvatar.ly_y + ivAvatar.frame.size.height, width: SCREEN_WIDTH - horizontalSpace * 2, height: fHeightTvContent)
        
        line.frame = CGRect(x: 0, y: tvContent.ly_y + fHeightTvContent + verticalSpace, width: SCREEN_WIDTH, height: verticalSpace)
        
        viewHeader.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: line.ly_y + line.frame.size.height)
        
        
        tableView.tableHeaderView = viewHeader
    }
    
    
    func showViewError() {
        if nil == viewError {
            viewError = UIView(frame: CGRect(x: 0, y: viewHeader.ly_y + viewHeader.frame.size.height, width: SCREEN_WIDTH, height: LyViewErrorHeight))
            viewError?.addSubview(LyUtil.lbError(withMode: 0))
        }
        
        self.tableView.addSubview(viewError!)
    }

    
    func removeViewError() {
        viewError?.removeFromSuperview()
        viewError = nil
    }
    
    
    func showViewNull() {
        if nil == viewNull {
            viewNull = UIView(frame: CGRect(x: 0, y: viewHeader.ly_y + viewHeader.frame.size.height, width: SCREEN_WIDTH, height: LyViewNullHeight))
            viewNull?.addSubview(LyUtil.lbNull(withText: "还没有回复"))
        }
        
        self.tableView.addSubview(viewNull!)
    }
    
    
    func removeViewNull() {
        viewNull?.removeFromSuperview()
        viewNull = nil
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func actionForButton(_ btn: UIButton) {
        let btnTag: LyConMsgDetailButtonTag = LyConMsgDetailButtonTag(rawValue: btn.tag)!
        switch btnTag {
        case .reply:
            LyReplyView(delegate: self).show()
        }
    }
    
    
    func refresh() {
        load()
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
extension LyConMsgDetailViewController {
    func load() {
        indicator.startAnimation()
        
        LyHttpRequest.start(consultDetail_url,
                            body: [idKey: con.oId,
                                   sessionIdKey: LyUtil.httpSessionId() ?? ""],
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
                                
                                let iCode: Int = json[codeKey].int!
                                switch iCode {
                                case 0:
                                    let arrResult: [JSON] = json[resultKey].arrayValue
                                    guard !arrResult.isEmpty else {
                                        self.indicator.stopAnimation()
                                        self.refreshControl.endRefreshing()
                                        
                                        self.showViewNull()
                                        return
                                    }
                                    
                                    for item in arrResult {
                                        let dicRep = item.dictionaryValue
                                        guard !dicRep.isEmpty else {
                                            continue
                                        }
                                        
                                        let sRepId = dicRep[idKey]?.stringValue
                                        var sRepTime = dicRep[timeKey]?.stringValue
                                        let sRepMasterId = dicRep[masterIdKey]?.stringValue
                                        let sRepObjectId = dicRep[objectIdKey]?.stringValue
                                        let sRepContent = dicRep[contentKey]?.stringValue
                                        
                                        sRepTime = LyUtil.fixDateTime(sRepTime)
                                        
                                        let reply = LyReply(id: sRepId,
                                                            masterId: sRepMasterId,
                                                            objectId: sRepObjectId,
                                                            objectingId: self.con.oId,
                                                            content: sRepContent,
                                                            time: sRepTime,
                                                            objectRpId: nil)
                                        if let rep = reply {
                                            self.arrRep.append(rep)
                                        }
                                    }
                                    
                                    self.reloadData()
                                    
                                    self.indicator.stopAnimation()
                                    self.refreshControl.endRefreshing()
                                    
                                default:
                                    self.handleHttpFailed(true)
                                }
                                
        }
    }
    
    
    func reply(_ text: String) {
        indicator_oper.title = LyIndicatorTitle_reply
        indicator_oper.startAnimation()
        
        LyHttpRequest.start(replyCon_url,
                            body: [contentKey: text,
                                   consultIdKey: con.oId,
                                   masterIdKey: LyCurrentUser.cur().userId,
                                   objectIdKey: con.masterId,
                                   userTypeKey: "xy",
                                   sessionIdKey: LyUtil.httpSessionId() ?? ""],
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
                                
                                let iCode: Int = json[codeKey].int!
                                switch iCode {
                                case 0:
                                    let dicResult: Dictionary! = json[resultKey].dictionaryValue
                                    guard !dicResult.isEmpty else {
                                        self.handleHttpFailed(true)
                                        return
                                    }
                                    
                                    let sId = dicResult[idKey]?.string
                                    var sTime = dicResult[timeKey]?.string
                                    
                                    sTime = LyUtil.fixDateTime(sTime)
                                    
                                    if let reply = LyReply(id: sId,
                                                           masterId: LyCurrentUser.cur().userId,
                                                           objectId: self.con.masterId,
                                                           objectingId: self.con.oId,
                                                           content: text,
                                                           time: sTime,
                                                           objectRpId: nil)
                                    {
                                        self.arrRep.append(reply)
                                    }
                                    
                                    self.reloadData()
                                    
                                    self.indicator_oper.stopAnimation()
                                    
                                default:
                                    self.handleHttpFailed(true)
                                }
        }
    }
    
}


// MARK: - LySUtilDelegate
extension LyConMsgDetailViewController {
    func handleHttpFailed(_ needRemind: Bool) {
        if indicator.isAnimating() {
            indicator.stopAnimation()
            refreshControl.endRefreshing()
            
            showViewError()
        }
        
        
        if indicator_oper.isAnimating() {
            indicator_oper.stopAnimation()
            var sTitle = "操作失败"
            if LyIndicatorTitle_reply == indicator_oper.title {
                sTitle = "回复失败"
            }
            
            LyRemindView.remind(with: .fail, withTitle: sTitle).show()
        }
    }
}


// MARK: - LyReplyViewDelegate
extension LyConMsgDetailViewController {
    func sendByReplyView(_ aReplyView: LyReplyView, text: String) {
        aReplyView.hide()
        
        _ = self.perform(#selector(reply(_:)), with: text, afterDelay: LyDelayTime)
    }
}


// MARK: - UITableViweDelegate
extension LyConMsgDetailViewController {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let reply = arrRep[indexPath.row]
        if LyChatCellHeightMin > reply.height || reply.height > LyChatCellHeightMax {
            var cell: LyReplyTableViewCell! = tableView.dequeueReusableCell(withIdentifier: lyConMsgDetailTableViewCellReuseIdentifier) as! LyReplyTableViewCell!
            if nil == cell {
                cell = LyReplyTableViewCell(style: .default, reuseIdentifier: lyConMsgDetailTableViewCellReuseIdentifier)
            }
            
            cell.reply = reply
        }
        
        return reply.height
    }
}


// MARK: - UITableViewDataSource
extension LyConMsgDetailViewController {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrRep.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: LyReplyTableViewCell! = tableView.dequeueReusableCell(withIdentifier: lyConMsgDetailTableViewCellReuseIdentifier) as! LyReplyTableViewCell!
        if nil == cell {
            cell = LyReplyTableViewCell(style: .default, reuseIdentifier: lyConMsgDetailTableViewCellReuseIdentifier)
        }
        
        cell.reply = arrRep[indexPath.row]
        
        return cell
    }
}


