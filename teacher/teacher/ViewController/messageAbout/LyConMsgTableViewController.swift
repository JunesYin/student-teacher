
//  LyConMsgTableViewController.swift
//  teacher
//
//  Created by MacMini on 2017/1/3.
//  Copyright © 2017年 517xueche. All rights reserved.
//

import UIKit
import SwiftyJSON



fileprivate let lyConMsgTableViewCellReuseIdentifier = "lyConMsgTableViewCellReuseIdentifier"


class LyConMsgTableViewController: UITableViewController {
    
    var arrConMsg = [AnyObject]()
    
    var curIdx: IndexPath!
    
    let indicator = LyIndicator(title: "")
    let indicator_oper = LyIndicator(title: nil)
    var tvFooter: LyTableViewFooterView! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        initSubviews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if arrConMsg.isEmpty {
            load()
        }
    }

    private func initSubviews() {
        self.title = LySLocalize("咨询消息")
        self.view.backgroundColor = LyWhiteLightgrayColor
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .done, target: nil, action: nil)
        
        tvFooter = LyTableViewFooterView(delegate: self)
        
        self.refreshControl = LyUtil.refreshControl(withTitle: nil, target: self, action: #selector(refresh))
        self.tableView.tableFooterView = tvFooter
        
        arrConMsg = []
    }
    
    func reloadData() {
        arrConMsg = LyUtil.uniquifyAndSort(arrConMsg, keyUniquify: "oId", keySort: "time", asc: false) as [AnyObject]
        
        self.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func refresh() {
        load()
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


// MARK:- operation
extension LyConMsgTableViewController {
    func load() {
        indicator.startAnimation()
        
        LyHttpRequest.start(conMsg_url,
                            body: [startKey: 0,
                                   masterKey: objectIdKey,
                                   objectIdKey: LyCurrentUser.cur().userId,
                                   userTypeKey: LyCurrentUser.cur().userTypeByString(),
                                   sessionIdKey: LyUtil.httpSessionId() ?? ""],
                            type: .asynPost,
                            timeOut: 0) { [unowned self] (resStr, resData, eror) in
                                guard nil != resData else {
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
                                    let arrResult: [JSON] = json[resultKey].arrayValue
                                    guard !arrResult.isEmpty else {
                                        self.indicator.stopAnimation()
                                        self.refreshControl?.endRefreshing()
                                        self.tvFooter.stopAnimation()
                                        
                                        self.tvFooter.status = .disable
                                        return
                                    }
                                    
                                    for itemConMsg in arrResult {
                                        let dicConMsg = itemConMsg.dictionaryValue
                                        guard !dicConMsg.isEmpty else {
                                            continue
                                        }
                                        
                                        let sTmpRepId = dicConMsg[idKey]?.string
                                        if nil == sTmpRepId {
                                            // consult
                                            let sConId = dicConMsg[consultIdKey]?.stringValue
                                            var sConTime = dicConMsg[timeKey]?.stringValue
                                            let sConMasterId = dicConMsg[masterIdKey]?.stringValue
//                                            let sConObjectId = dicConMsg[objectIdKey]?.stringValue
                                            let sConContent = dicConMsg[contentKey]?.stringValue
                                            
                                            var student = LyUserManager.sharedInstance().getUserWithUserId(sConMasterId)
                                            if nil == student {
                                                var sNickName = dicConMsg[nickNameKey]?.stringValue
                                                if !LyUtil.validateString(sNickName) {
                                                    sNickName = LyUtil.getUserName(withUserId: sConMasterId)
                                                }
                                                
                                                student = LyUser(id: sConMasterId, userName: sNickName)
                                                LyUserManager.sharedInstance().add(student)
                                            }
                                            
                                            sConTime = LyUtil.fixDateTime(sConTime)
                                            
                                            let con: LyConsult! = LyConsult(id: sConId,
                                                                            time: sConTime,
                                                                            masterId: sConMasterId,
                                                                            objectId: LyCurrentUser.cur().userId,
                                                                            content: sConContent)
                                            if let consult = con {
                                                self.arrConMsg.append(consult)
                                            }
                                            
                                        } else {
                                            // reply
                                            let sRepId = sTmpRepId!
                                            let sConId = dicConMsg[consultIdKey]?.stringValue
                                            var sRepTime = dicConMsg[timeKey]?.stringValue
                                            let sRepMasterId = dicConMsg[masterIdKey]?.stringValue
//                                            let sRepObjectId = dicConMsg[objectIdKey]?.stringValue
                                            let sRepContent = dicConMsg[contentKey]?.stringValue
                                            
                                            var con = LyConsultManager.sharedInstance().getConsultWithConId(sConId)
                                            if nil == con {
                                                let dicCon: Dictionary! = dicConMsg[consultKey]?.dictionary
                                                guard nil != dicCon && !dicCon.isEmpty else {
                                                    continue
                                                }
                                                
                                                var sConTime = dicCon[timeKey]?.stringValue
//                                                let sConMasterId = dicCon[masterIdKey]?.stringValue
//                                                let sConObjectId = dicCon[objectIdKey]?.stringValue
                                                let sConContent = dicCon[contentKey]?.stringValue
                                                
                                                var student = LyUserManager.sharedInstance().getUserWithUserId(sRepMasterId)
                                                if nil == student {
                                                    var sNickName = dicCon[nickNameKey]?.stringValue
                                                    if !LyUtil.validateString(sNickName) {
                                                        sNickName = LyUtil.getUserName(withUserId: sRepMasterId)
                                                    }
                                                    
                                                    student = LyUser(id: sRepMasterId, userName: sNickName)
                                                    LyUserManager.sharedInstance().add(student)
                                                }
                                                
                                                sConTime = LyUtil.fixDateTime(sConTime)
                                                
                                                con = LyConsult(id: sConId,
                                                                time: sConTime,
                                                                masterId: sRepMasterId,
                                                                objectId: LyCurrentUser.cur().userId,
                                                                content: sConContent)
                                                
                                                if let consult = con {
                                                    LyConsultManager.sharedInstance().add(consult)
                                                }
                                            }
                                            
                                            sRepTime = LyUtil.fixDateTime(sRepTime)
                                            
                                            let rep = LyReply(id: sRepId,
                                                              masterId: sRepMasterId,
                                                              objectId: LyCurrentUser.cur().userId,
                                                              objectingId: sConId,
                                                              content: sRepContent,
                                                              time: sRepTime,
                                                              objectRpId: nil)
                                            
                                            if let reply = rep {
                                                self.arrConMsg.append(reply)
                                            }
                                            
                                        }
                                        
                                    }
                                    
                                    self.reloadData()
                                    
                                    self.indicator.stopAnimation()
                                    self.refreshControl?.endRefreshing()
                                    self.tvFooter.stopAnimation()
                                    self.tvFooter.status = .normal
                                    
                                default:
                                    self.handleHttpFailed(true)
                                }
                                
        }
    }
    
    func loadMore() {
        tvFooter.startAnimation()
        
        LyHttpRequest.start(conMsg_url,
                            body: [startKey: arrConMsg.count,
                                   masterKey: objectIdKey,
                                   objectIdKey: LyCurrentUser.cur().userId,
                                   userTypeKey: LyCurrentUser.cur().userTypeByString(),
                                   sessionIdKey: LyUtil.httpSessionId() ?? ""],
                            type: .asynPost,
                            timeOut: 0) { [unowned self] (resStr, resData, eror) in
                                guard nil != resData else {
                                    self.handleHttpFailed(true)
                                    return
                                }
                                
                                let json: JSON! = analysisHttpResult(resData!, delegate: self)
                                guard nil != json else {
                                    self.handleHttpFailed(true)
                                    return
                                }
                                
                                let iCode: Int = json[codeKey].int!
                                switch iCode {
                                case 0:
                                    let arrResult: [JSON] = json[resultKey].arrayValue
                                    guard !arrResult.isEmpty else {
                                        self.indicator.stopAnimation()
                                        self.refreshControl?.endRefreshing()
                                        self.tvFooter.stopAnimation()
                                        
                                        self.tvFooter.status = .disable
                                        return
                                    }
                                    
                                    for itemConMsg in arrResult {
                                        let dicConMsg = itemConMsg.dictionaryValue
                                        guard !dicConMsg.isEmpty else {
                                            continue
                                        }
                                        
                                        let sTmpRepId = dicConMsg[idKey]?.string
                                        if nil == sTmpRepId {
                                            // consult
                                            let sConId = dicConMsg[consultIdKey]?.stringValue
                                            var sConTime = dicConMsg[timeKey]?.stringValue
                                            let sConMasterId = dicConMsg[masterIdKey]?.stringValue
                                            //                                            let sConObjectId = dicConMsg[objectIdKey]?.stringValue
                                            let sConContent = dicConMsg[contentKey]?.stringValue
                                            
                                            var student = LyUserManager.sharedInstance().getUserWithUserId(sConMasterId)
                                            if nil == student {
                                                var sNickName = dicConMsg[nickNameKey]?.stringValue
                                                if !LyUtil.validateString(sNickName) {
                                                    sNickName = LyUtil.getUserName(withUserId: sConMasterId)
                                                }
                                                
                                                student = LyUser(id: sConMasterId, userName: sNickName)
                                                LyUserManager.sharedInstance().add(student)
                                            }
                                            
                                            sConTime = LyUtil.fixDateTime(sConTime)
                                            
                                            let con = LyConsult(id: sConId,
                                                                time: sConTime,
                                                                masterId: sConMasterId,
                                                                objectId: LyCurrentUser.cur().userId,
                                                                content: sConContent)
                                            if let consult = con {
                                                self.arrConMsg.append(consult)
                                            }
                                            
                                        } else {
                                            // reply
                                            let sRepId = sTmpRepId!
                                            let sConId = dicConMsg[consultIdKey]?.stringValue
                                            var sRepTime = dicConMsg[timeKey]?.stringValue
                                            let sRepMasterId = dicConMsg[masterIdKey]?.stringValue
                                            //                                            let sRepObjectId = dicConMsg[objectIdKey]?.stringValue
                                            let sRepContent = dicConMsg[contentKey]?.stringValue
                                            
                                            var con = LyConsultManager.sharedInstance().getConsultWithConId(sConId)
                                            if nil == con {
                                                let dicCon: Dictionary! = dicConMsg[consultKey]?.dictionary
                                                guard nil != dicCon && !dicCon.isEmpty else {
                                                    continue
                                                }
                                                
                                                var sConTime = dicCon[timeKey]?.stringValue
                                                //                                                let sConMasterId = dicCon[masterIdKey]?.stringValue
                                                //                                                let sConObjectId = dicCon[objectIdKey]?.stringValue
                                                let sConContent = dicCon[contentKey]?.stringValue
                                                
                                                var student = LyUserManager.sharedInstance().getUserWithUserId(sRepMasterId)
                                                if nil == student {
                                                    var sNickName = dicCon[nickNameKey]?.stringValue
                                                    if !LyUtil.validateString(sNickName) {
                                                        sNickName = LyUtil.getUserName(withUserId: sRepMasterId)
                                                    }
                                                    
                                                    student = LyUser(id: sRepMasterId, userName: sNickName)
                                                    LyUserManager.sharedInstance().add(student)
                                                }
                                                
                                                sConTime = LyUtil.fixDateTime(sConTime)
                                                
                                                con = LyConsult(id: sConId,
                                                                time: sConTime,
                                                                masterId: sRepMasterId,
                                                                objectId: LyCurrentUser.cur().userId,
                                                                content: sConContent)
                                                
                                                if let consult = con {
                                                    LyConsultManager.sharedInstance().add(consult)
                                                }
                                            }
                                            
                                            sRepTime = LyUtil.fixDateTime(sRepTime)
                                            
                                            let rep = LyReply(id: sRepId,
                                                              masterId: sRepMasterId,
                                                              objectId: LyCurrentUser.cur().userId,
                                                              objectingId: sConId,
                                                              content: sRepContent,
                                                              time: sRepTime,
                                                              objectRpId: nil)
                                            
                                            if let reply = rep {
                                                self.arrConMsg.append(reply)
                                            }
                                            
                                        }
                                        
                                    }
                                    
                                    self.reloadData()
                                    
                                    self.indicator.stopAnimation()
                                    self.tvFooter.stopAnimation()
                                    self.tvFooter.status = .normal
                                    
                                default:
                                    self.handleHttpFailed(true)
                                }
        }
        
    }
    
    
    
    func reply(_ text: String) {
        indicator_oper.title = LyIndicatorTitle_reply
        indicator_oper.startAnimation()
        
        let conMsg = arrConMsg[curIdx.row]
        var conId = ""
        if conMsg is LyConsult {
            conId = conMsg.oId
        } else {
            conId = conMsg.objectingId
        }
        
        LyHttpRequest.start(replyCon_url,
                            body: [contentKey: text,
                                   consultIdKey: conId,
                                   masterIdKey: LyCurrentUser.cur().userId,
                                   objectIdKey: conMsg.masterId,
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
                                    self.reloadData()
                                    
                                    self.indicator_oper.stopAnimation()
                                    LyRemindView.remind(with: .success, withTitle: LySLocalize("回复完成")).show()
                                    
                                default:
                                    self.handleHttpFailed(true)
                                }
        }
        
    }
}


// MARK: - LySUtilDelegate
extension LyConMsgTableViewController: LySUtilDelegate {
    func handleHttpFailed(_ needRemind: Bool) {
        if indicator.isAnimating() {
            indicator.stopAnimation()
            self.refreshControl?.endRefreshing()
            
            tvFooter.status = .error
        }
        
        if indicator_oper.isAnimating() {
            indicator_oper.stopAnimation()
            
            var sTitle = LySLocalize("操作失败")
            if indicator_oper.title == LyIndicatorTitle_reply {
                sTitle = LySLocalize("回复失败")
            }
            
            LyRemindView.remind(with: .fail, withTitle: sTitle)
        }
        
        if tvFooter.isAnimating {
            tvFooter.stopAnimation()
            tvFooter.status = .error
        }
        
    }
}


// MARK: - LyConMsgDetailViewControllerDelegate
extension LyConMsgTableViewController: LyConMsgDetailViewControllerDelegate {
    func consultByConMsgDetailViewController(_ aConMsgDetailVC: LyConMsgDetailViewController) -> LyConsult! {
        var con: LyConsult? = nil
        
        let conMsg: AnyObject = arrConMsg[curIdx.row]
        if conMsg is LyConsult {
            con = conMsg as? LyConsult
        } else {
            con = LyConsultManager.sharedInstance().getConsultWithConId(conMsg.objectingId)
        }
        
        return con
    }
}


// MARK: - LyReplyViewDelegate
extension LyConMsgTableViewController: LyReplyViewDelegate {
    func sendByReplyView(_ aReplyView: LyReplyView, text: String) {
        aReplyView.hide()
        
        _ = perform(#selector(reply(_:)), with: text, afterDelay: LyDelayTime)
    }
}


// MARK: - LyConMsgTableViewCellDelegate
extension LyConMsgTableViewController: LyConMsgTableViewCellDelegate {
    func replyByConMsgTableViewCell(_ aCell: LyConMsgTableViewCell) {
        curIdx = self.tableView.indexPath(for: aCell)
        
        let replyView = LyReplyView(delegate: self)
        replyView.show()
    }
}


// MARK: - LyTableViewFooterViewDelegate
extension LyConMsgTableViewController: LyTableViewFooterViewDelegate {
    func loadMoreData(_ tableViewFooterView: LyTableViewFooterView!) {
        loadMore()
    }
}


// MARK: - UITableViewDelegate
extension LyConMsgTableViewController {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let conMsg = arrConMsg[indexPath.row]
        
        if conMsg is LyConsult {
            if LyChatCellHeightMin > conMsg.height || conMsg.height > LyChatCellHeightMax{
                var cell: LyConMsgTableViewCell! = tableView.dequeueReusableCell(withIdentifier: lyConMsgTableViewCellReuseIdentifier) as! LyConMsgTableViewCell!
                if nil == cell {
                    cell = LyConMsgTableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: lyConMsgTableViewCellReuseIdentifier)
                }
                
                cell.con = conMsg as! LyConsult
            }
            
            return conMsg.height
            
        } else {
            if LyChatCellHeightMin > conMsg.height_m || conMsg.height_m > LyChatCellHeightMax{
                var cell: LyConMsgTableViewCell! = tableView.dequeueReusableCell(withIdentifier: lyConMsgTableViewCellReuseIdentifier) as! LyConMsgTableViewCell!
                if nil == cell {
                    cell = LyConMsgTableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: lyConMsgTableViewCellReuseIdentifier)
                }
                
                cell.reply = conMsg as! LyReply
            }
         
            return conMsg.height_m
        }

    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        curIdx = indexPath
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let conMsgDetail = LyConMsgDetailViewController()
        conMsgDetail.delegate = self
        self.navigationController?.pushViewController(conMsgDetail, animated: true)
    }
}


// MARK: - UITableViewDataSource
extension LyConMsgTableViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrConMsg.count
//        return arrConMsg.count > 0 ? 1: 0;
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: LyConMsgTableViewCell! = tableView.dequeueReusableCell(withIdentifier: lyConMsgTableViewCellReuseIdentifier) as! LyConMsgTableViewCell!
        if nil == cell {
            cell = LyConMsgTableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: lyConMsgTableViewCellReuseIdentifier)
        }
        
        let conMsg = arrConMsg[indexPath.row]
        if conMsg is LyConsult {
            cell.con = conMsg as! LyConsult
        } else {
            cell.reply = conMsg as! LyReply
        }
        cell.delegate = self
        
        return cell
    }
}


// MARK: - UIScrollViewDelegate
extension LyConMsgTableViewController {
    override func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        if scrollView == self.tableView &&
            scrollView.contentOffset.y + scrollView.frame.size.height > scrollView.contentSize.height + tvFooterViewDefaultHeight &&
            scrollView.contentSize.height > scrollView.frame.size.height
        {
            loadMore()
        }
    }
}

