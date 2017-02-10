
//  LyConMsgTableViewController.swift
//  teacher
//
//  Created by MacMini on 2017/1/3.
//  Copyright © 2017年 517xueche. All rights reserved.
//

import UIKit
import SwiftyJSON



fileprivate let lyConMsgTableViewCellReuseIdentifier = "lyConMsgTableViewCellReuseIdentifier"


class LyConMsgTableViewController: UITableViewController, LySUtilDelegate, LyTableViewFooterViewDelegate, LyConMsgTableViewCellDelegate, LyReplyViewDelegate, LyConMsgDetailViewControllerDelegate {
    
    var arrRep = [LyReply]()
    
    var curIdx: IndexPath!
    
    let indicator = LyIndicator(title: "")
    let indicator_oper = LyIndicator(title: "")
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
        if arrRep.isEmpty {
            load()
        }
    }

    private func initSubviews() {
        self.title = "咨询消息"
        self.view.backgroundColor = LyWhiteLightgrayColor
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .done, target: nil, action: nil)
        
        
        tvFooter = LyTableViewFooterView(delegate: self)
        
        self.refreshControl = LyUtil.refreshControl(withTitle: nil, target: self, action: #selector(refresh))
        
        self.tableView.tableFooterView = tvFooter
        
        arrRep = []
    }
    
    func reloadData() {
        arrRep = LyUtil.uniquifyAndSort(arrRep, keyUniquify: "oId", keySort: "time", asc: false) as! [LyReply]
        
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
                                   masterKey: masterIdKey,
                                   objectIdKey: LyCurrentUser.cur().userId,
                                   userTypeKey: LyCurrentUser.cur().userTypeByString(),
                                   sessionIdKey: LyUtil.httpSessionId()],
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
                                    
                                    for itemRep in arrResult {
                                        let dicRep = itemRep.dictionaryValue
                                        guard !dicRep.isEmpty else {
                                            continue
                                        }
                                        
                                        let sId = dicRep[idKey]?.stringValue
                                        let sConId = dicRep[consultIdKey]?.stringValue
                                        var sTime = dicRep[timeKey]?.stringValue
                                        let sMasterId = dicRep[masterIdKey]?.stringValue
//                                        let sObjectId = dicRep[objectIdKey]?.stringValue
                                        let sContent = dicRep[contentKey]?.stringValue

                                        var con = LyConsultManager.sharedInstance().getConsultWithConId(sConId)
                                        if nil == con {
                                            let dicCon: Dictionary! = dicRep[consultKey]?.dictionary
                                            guard nil != dicCon && !dicCon.isEmpty else {
                                                continue
                                            }
                                            
                                            var sConTime = dicCon[timeKey]?.stringValue
//                                            let sConMasterId = dicCon[masterIdKey]?.stringValue
//                                            let sConObjectId = dicCon[objectIdKey]?.stringValue
                                            let sConContent = dicCon[contentKey]?.stringValue
                                            let sUserType = dicCon[userTypeKey]?.stringValue
                                            
                                            let userType = LyUtil.userType(from: sUserType)
                                            
                                            var teacher = LyUserManager.sharedInstance().getUserWithUserId(sMasterId)
                                            if nil == teacher || userType != teacher?.userType {
                                                var sNickName = dicCon[nickNameKey]?.stringValue
                                                if !LyUtil.validateString(sNickName) {
                                                    sNickName = LyUtil.getUserName(withUserId: sMasterId)
                                                }
                                                
                                                switch userType {
                                                case .normal:
                                                    break
                                                case .school:
//                                                    teacher = LyDriveSchool(idNoAvatar: sMasterId, userName: sNickName)
                                                    teacher = LyDriveSchool(id: sMasterId, userName: sNickName)
                                                case .coach:
                                                    //                                                    teacher = LyCoach(idNoAvatar: sMasterId, name: sNickName)
                                                    teacher = LyCoach(id: sMasterId, userName: sNickName)
                                                case .guider:
                                                    //                                                    teacher = LyGuider(idNoAvatar: sMasterId, userName: sNickName)
                                                    teacher = LyGuider(id: sMasterId, userName: sNickName)
                                                }
                                                
                                                LyUserManager.sharedInstance().add(teacher)
                                            }
                                            
                                            sConTime = LyUtil.fixDateTime(sConTime)
                                            
                                            
                                            con = LyConsult(id: sConId,
                                                            time: sConTime,
                                                            masterId: LyCurrentUser.cur().userId,
                                                            objectId: sMasterId,
                                                            content: sConContent)
                                            
                                            if let consult = con {
                                                LyConsultManager.sharedInstance().add(consult)
                                            }
                                        }
                                        
                                        sTime = LyUtil.fixDateTime(sTime)
                                        
                                        let rep = LyReply(id: sId,
                                                          masterId: sMasterId,
                                                          objectId: LyCurrentUser.cur().userId,
                                                          objectingId: sConId,
                                                          content: sContent,
                                                          time: sTime,
                                                          objectRpId: nil)
                                        
                                        if let reply = rep {
                                            self.arrRep.append(reply)
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
                            body: [startKey: arrRep.count,
                                   masterKey: masterIdKey,
                                   objectIdKey: LyCurrentUser.cur().userId,
                                   userTypeKey: LyCurrentUser.cur().userTypeByString(),
                                   sessionIdKey: LyUtil.httpSessionId()],
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
                                    
                                    for itemRep in arrResult {
                                        let dicRep = itemRep.dictionaryValue
                                        guard !dicRep.isEmpty else {
                                            continue
                                        }
                                        
                                        let sId = dicRep[idKey]?.stringValue
                                        let sConId = dicRep[consultIdKey]?.stringValue
                                        var sTime = dicRep[timeKey]?.stringValue
                                        let sMasterId = dicRep[masterIdKey]?.stringValue
                                        //                                        let sObjectId = dicRep[objectIdKey]?.stringValue
                                        let sContent = dicRep[contentKey]?.stringValue
                                        
                                        var con = LyConsultManager.sharedInstance().getConsultWithConId(sConId)
                                        if nil == con {
                                            let dicCon: Dictionary! = dicRep[consultKey]?.dictionary
                                            guard nil != dicCon && !dicCon.isEmpty else {
                                                continue
                                            }
                                            
                                            var sConTime = dicCon[timeKey]?.stringValue
//                                            let sConMasterId = dicCon[masterIdKey]?.stringValue
//                                            let sConObjectId = dicCon[objectIdKey]?.stringValue
                                            let sConContent = dicCon[contentKey]?.stringValue
                                            let sUserType = dicCon[userTypeKey]?.stringValue
                                            
                                            let userType = LyUtil.userType(from: sUserType)
                                            
                                            var teacher = LyUserManager.sharedInstance().getUserWithUserId(sMasterId)
                                            if nil == teacher || userType != teacher?.userType {
                                                var sNickName = dicCon[nickNameKey]?.stringValue
                                                if !LyUtil.validateString(sNickName) {
                                                    sNickName = LyUtil.getUserName(withUserId: sMasterId)
                                                }
                                                
                                                switch userType {
                                                case .normal:
                                                    break
                                                case .school:
                                                    //                                                    teacher = LyDriveSchool(idNoAvatar: sMasterId, userName: sNickName)
                                                    teacher = LyDriveSchool(id: sMasterId, userName: sNickName)
                                                case .coach:
                                                    //                                                    teacher = LyCoach(idNoAvatar: sMasterId, name: sNickName)
                                                    teacher = LyCoach(id: sMasterId, userName: sNickName)
                                                case .guider:
                                                    //                                                    teacher = LyGuider(idNoAvatar: sMasterId, userName: sNickName)
                                                    teacher = LyGuider(id: sMasterId, userName: sNickName)
                                                }
                                                
                                                LyUserManager.sharedInstance().add(teacher)
                                            }
                                            
                                            sConTime = LyUtil.fixDateTime(sConTime)
                                            
                                            
                                            con = LyConsult(id: sConId,
                                                            time: sConTime,
                                                            masterId: LyCurrentUser.cur().userId,
                                                            objectId: sMasterId,
                                                            content: sConContent)
                                            
                                            if let consult = con {
                                                LyConsultManager.sharedInstance().add(consult)
                                            }
                                        }
                                        
                                        sTime = LyUtil.fixDateTime(sTime)
                                        
                                        let rep = LyReply(id: sId,
                                                          masterId: sMasterId,
                                                          objectId: LyCurrentUser.cur().userId,
                                                          objectingId: sConId,
                                                          content: sContent,
                                                          time: sTime,
                                                          objectRpId: nil)
                                        
                                        if let reply = rep {
                                            self.arrRep.append(reply)
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
        
        let reply = arrRep[curIdx.row]
        
        LyHttpRequest.start(replyCon_url,
                            body: [contentKey: text,
                                   consultIdKey: reply.objectingId,
                                   masterIdKey: LyCurrentUser.cur().userId,
                                   objectIdKey: reply.masterId,
                                   userTypeKey: "jl",
                                   sessionIdKey: LyUtil.httpSessionId()],
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
                                    
                                    LyRemindView.remind(with: .success, withTitle: NSLocalizedString("Reply Done", comment: "Reply Done")).show()
                                default:
                                    self.handleHttpFailed(true)
                                }
        }
        
    }
}


// MARK: - LySUtilDelegate
extension LyConMsgTableViewController {
    func handleHttpFailed(_ needRemind: Bool) {
        if indicator.isAnimating() {
            indicator.stopAnimation()
            self.refreshControl?.endRefreshing()
            
            tvFooter.status = .error
        }
        
        if indicator_oper.isAnimating() {
            indicator_oper.stopAnimation()
            
            var sTitle = "操作失败"
            if indicator_oper.title == LyIndicatorTitle_reply {
                sTitle = "回复失败"
            }
            
            LyRemindView.remind(with: .fail, withTitle: sTitle).show()
        }
        
        if tvFooter.isAnimating {
            tvFooter.stopAnimation()
            tvFooter.status = .error
        }
        
    }
}


// MARK: - LyConMsgDetailViewControllerDelegate
extension LyConMsgTableViewController {
    func consultByConMsgDetailViewController(_ aConMsgDetailVC: LyConMsgDetailViewController) -> LyConsult! {
        return LyConsultManager.sharedInstance().getConsultWithConId(arrRep[curIdx.row].objectingId)
    }
}


// MARK: - LyReplyViewDelegate
extension LyConMsgTableViewController {
    func sendByReplyView(_ aReplyView: LyReplyView, text: String) {
        let sText = text
        aReplyView.hide()
        
        _ = perform(#selector(reply(_:)), with: sText, afterDelay: LyDelayTime)
    }
}


// MARK: - LyConMsgTableViewCellDelegate
extension LyConMsgTableViewController {
    func replyByConMsgTableViewCell(_ aCell: LyConMsgTableViewCell) {
        curIdx = self.tableView.indexPath(for: aCell)
        
        let replyView = LyReplyView(delegate: self)
        replyView.show()
    }
}


// MARK: - LyTableViewFooterViewDelegate
extension LyConMsgTableViewController {
    func loadMoreData(_ tableViewFooterView: LyTableViewFooterView!) {
        loadMore()
    }
}


// MARK: - UITableViewDelegate
extension LyConMsgTableViewController {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let reply = arrRep[indexPath.row]
        if LyChatCellHeightMin > reply.height_m || reply.height_m > LyChatCellHeightMax {
            var cell: LyConMsgTableViewCell! = tableView.dequeueReusableCell(withIdentifier: lyConMsgTableViewCellReuseIdentifier) as! LyConMsgTableViewCell!
            if nil == cell {
                cell = LyConMsgTableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: lyConMsgTableViewCellReuseIdentifier)
            }
            
            cell.reply = reply
        }
    
        return reply.height_m
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
        return arrRep.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: LyConMsgTableViewCell! = tableView.dequeueReusableCell(withIdentifier: lyConMsgTableViewCellReuseIdentifier) as! LyConMsgTableViewCell!
        if nil == cell {
            cell = LyConMsgTableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: lyConMsgTableViewCellReuseIdentifier)
        }
        
        cell.reply = arrRep[indexPath.row]
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

