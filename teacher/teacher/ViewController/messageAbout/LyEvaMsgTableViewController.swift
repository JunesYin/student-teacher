//
//  LyEvaMsgTableViewController.swift
//  teacher
//
//  Created by MacMini on 2017/1/3.
//  Copyright © 2017年 517xueche. All rights reserved.
//

import UIKit
import SwiftyJSON


fileprivate let lyEvaMsgTableViewCellReuseIdentifier = "lyEvaMsgTableViewCellReuseIdentifier"

class LyEvaMsgTableViewController: UITableViewController, LySUtilDelegate, LyTableViewFooterViewDelegate, LyEvaMsgTableViewCellDelegate, LyReplyViewDelegate, LyEvaMsgDetailViewControllerDelegate {

    
    
    var arrEvaMsg = [AnyObject]()
    
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
        super.viewWillAppear(animated)
        
        if arrEvaMsg.isEmpty {
            load()
        }
    }
    
    private func initSubviews() {
        self.title = LySLocalize("评价消息")
        self.view.backgroundColor = LyWhiteLightgrayColor
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .done, target: nil, action: nil)
        
        
        tvFooter = LyTableViewFooterView(delegate: self)
        
        self.refreshControl = LyUtil.refreshControl(withTitle: "", target: self, action: #selector(refresh))
        
        self.tableView.tableFooterView = tvFooter
        
        arrEvaMsg = []
    }
    
    func reloadData() {
        arrEvaMsg = LyUtil.uniquifyAndSort(arrEvaMsg, keyUniquify: "oId", keySort: "time", asc: false) as [AnyObject]
        
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


// MARK: - HttpRequest
extension LyEvaMsgTableViewController {
    func load() {
        indicator.startAnimation()
        
        LyHttpRequest.start(evaMsg_url,
                            body: [startKey: 0,
                                   masterKey: objectingIdKey,
                                   objectIdKey: LyCurrentUser.cur().userId,
                                   userTypeKey: LyCurrentUser.cur().userTypeByString(),
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
                                
                                let iCode = json[codeKey].intValue
                                switch iCode {
                                case 0:
                                    let arrResult: Array! = json[resultKey].arrayValue
                                    guard !arrResult.isEmpty else {
                                        self.indicator.stopAnimation()
                                        self.refreshControl?.endRefreshing()
                                        self.tvFooter.stopAnimation()
                                        
                                        self.tvFooter.status = .disable
                                        return
                                    }
                                    
                                    for itemEvaMsg in arrResult {
                                        let dicEvaMsg = itemEvaMsg.dictionaryValue
                                        guard !dicEvaMsg.isEmpty else {
                                            continue
                                        }
                                        
                                        let sTmpRepId = dicEvaMsg[idKey]?.string
                                        if nil == sTmpRepId {
                                            // evaluation
                                            let sEvaId = dicEvaMsg[evaluationIdKey]?.stringValue
                                            var sEvaTime = dicEvaMsg[timeKey]?.stringValue
                                            let sEvaMasterId = dicEvaMsg[masterIdKey]?.stringValue
//                                            let sEvaObjectId = dicEvaMsg[objectIdKey]?.stringValue
                                            let sEvaContent = dicEvaMsg[contentKey]?.stringValue
                                            let fScore = dicEvaMsg[scoreKey]?.floatValue
                                            let iLevel = dicEvaMsg[evaluationLevelKey]?.intValue
                                            
                                            var student = LyUserManager.sharedInstance().getUserWithUserId(sEvaMasterId)
                                            if nil == student {
                                                var sNickName = dicEvaMsg[nickNameKey]?.stringValue
                                                if !LyUtil.validateString(sNickName) {
                                                    sNickName = LyUtil.getUserName(withUserId: sEvaMasterId)
                                                }
                                                
                                                student = LyUser(id: sEvaMasterId, userName: sNickName)
                                                LyUserManager.sharedInstance().add(student)
                                            }
                                            
                                            sEvaTime = LyUtil.fixDateTime(sEvaTime)
                                            let eLevel = LyEvaluationLevel(rawValue: iLevel!) ?? .good
                                            
                                            let eva = LyEvaluationForTeacher(id: sEvaId,
                                                                             content: sEvaContent,
                                                                             time: sEvaTime,
                                                                             masterId: sEvaMasterId,
                                                                             objectId: LyCurrentUser.cur().userId,
                                                                             score: fScore ?? 5,
                                                                             level: eLevel)
                                            
                                            if let evaluation = eva {
                                                self.arrEvaMsg.append(evaluation)
                                            }
                                            
                                        } else {
                                            // reply
                                            let sRepId = sTmpRepId!
                                            let sEvaId = dicEvaMsg[evaluationIdKey]?.stringValue
                                            var sRepTime = dicEvaMsg[timeKey]?.stringValue
                                            let sRepMasterId = dicEvaMsg[masterIdKey]?.stringValue
//                                            let sRepObjectId = dicEvaMsg[objectIdKey]?.stringValue
                                            let sRepContent = dicEvaMsg[contentKey]?.stringValue
                                            
                                            var eva = LyEvaluationForTeacherManager.sharedInstance().getEvaluatoinWithEvaId(sEvaId)
                                            if nil == eva {
                                                let dicEva: Dictionary! = dicEvaMsg[evaluatingKey]?.dictionaryValue
                                                guard nil != dicEva && !dicEva.isEmpty else {
                                                    continue
                                                }
                                                
                                                var sEvaTime = dicEva[timeKey]?.stringValue
//                                                let sEvaMasterId = dicEva[masterIdKey]?.stringValue
//                                                let sEvaObjectId = dicEva[objectIdKey]?.stringValue
                                                let sEvaContent = dicEva[contentKey]?.stringValue
                                                let fScore = dicEva[scoreKey]?.floatValue
                                                let iLevel = dicEva[evaluationLevelKey]?.intValue
                                                
                                                var student = LyUserManager.sharedInstance().getUserWithUserId(sRepMasterId)
                                                if nil == student {
                                                    var sNickName = dicEva[nickNameKey]?.stringValue
                                                    if !LyUtil.validateString(sNickName) {
                                                        sNickName = LyUtil.getUserName(withUserId: sRepMasterId)
                                                    }
                                                    
                                                    student = LyUser(id: sRepMasterId, userName: sNickName)
                                                    LyUserManager.sharedInstance().add(student)
                                                }
                                                
                                                sEvaTime = LyUtil.fixDateTime(sEvaTime)
                                                let eLevel = LyEvaluationLevel(rawValue: iLevel!) ?? .good
                                                
                                                eva = LyEvaluationForTeacher(id: sEvaId,
                                                                             content: sEvaContent,
                                                                             time: sEvaTime,
                                                                             masterId: sRepMasterId,
                                                                             objectId: LyCurrentUser.cur().userId,
                                                                             score: fScore ?? 5,
                                                                             level: eLevel)
                                                
                                                LyEvaluationForTeacherManager.sharedInstance().addEvalution(eva)
                                                
                                            }
                                            
                                            
                                            sRepTime = LyUtil.fixDateTime(sRepTime)
                                            
                                            let rep = LyReply(id: sRepId,
                                                              masterId: sRepMasterId,
                                                              objectId: LyCurrentUser.cur().userId,
                                                              objectingId: sEvaId,
                                                              content: sRepContent,
                                                              time: sRepTime,
                                                              objectRpId: nil)
                                            
                                            if let reply = rep {
                                                self.arrEvaMsg.append(reply)
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
        
        LyHttpRequest.start(evaMsg_url,
                            body: [startKey: arrEvaMsg.count,
                                   masterKey: objectingIdKey,
                                   objectIdKey: LyCurrentUser.cur().userId,
                                   userTypeKey: LyCurrentUser.cur().userTypeByString(),
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
                                
                                let iCode = json[codeKey].intValue
                                switch iCode {
                                case 0:
                                    let arrResult: Array! = json[resultKey].arrayValue
                                    guard !arrResult.isEmpty else {
                                        self.indicator.stopAnimation()
                                        self.refreshControl?.endRefreshing()
                                        self.tvFooter.stopAnimation()
                                        
                                        self.tvFooter.status = .disable
                                        return
                                    }
                                    
                                    for itemEvaMsg in arrResult {
                                        let dicEvaMsg = itemEvaMsg.dictionaryValue
                                        guard !dicEvaMsg.isEmpty else {
                                            continue
                                        }
                                        
                                        let sTmpEvaId = dicEvaMsg["tid"]?.string
                                        if nil == sTmpEvaId {
                                            // evaluation
                                            let sEvaId = dicEvaMsg[idKey]?.stringValue
                                            var sEvaTime = dicEvaMsg[timeKey]?.stringValue
                                            let sEvaMasterId = dicEvaMsg[masterIdKey]?.stringValue
                                            //                                            let sEvaObjectId = dicEvaMsg[objectIdKey]?.stringValue
                                            let sEvaContent = dicEvaMsg[contentKey]?.stringValue
                                            let fScore = dicEvaMsg[scoreKey]?.floatValue
                                            let iLevel = dicEvaMsg[evaluationLevelKey]?.intValue
                                            
                                            var student = LyUserManager.sharedInstance().getUserWithUserId(sEvaMasterId)
                                            if nil == student {
                                                var sNickName = dicEvaMsg[nickNameKey]?.stringValue
                                                if !LyUtil.validateString(sNickName) {
                                                    sNickName = LyUtil.getUserName(withUserId: sEvaMasterId)
                                                }
                                                
                                                student = LyUser(id: sEvaMasterId, userName: sNickName)
                                                LyUserManager.sharedInstance().add(student)
                                            }
                                            
                                            sEvaTime = LyUtil.fixDateTime(sEvaTime)
                                            let eLevel = LyEvaluationLevel(rawValue: iLevel!) ?? .good
                                            
                                            let eva = LyEvaluationForTeacher(id: sEvaId,
                                                                             content: sEvaContent,
                                                                             time: sEvaTime,
                                                                             masterId: sEvaMasterId,
                                                                             objectId: LyCurrentUser.cur().userId,
                                                                             score: fScore ?? 5,
                                                                             level: eLevel)
                                            
                                            if let evaluation = eva {
                                                self.arrEvaMsg.append(evaluation)
                                            }
                                            
                                        } else {
                                            // reply
                                            let sRepId = dicEvaMsg[idKey]?.stringValue
                                            let sEvaId = sTmpEvaId!
                                            var sRepTime = dicEvaMsg[timeKey]?.stringValue
                                            let sRepMasterId = dicEvaMsg[masterIdKey]?.stringValue
                                            //                                            let sRepObjectId = dicEvaMsg[objectIdKey]?.stringValue
                                            let sRepContent = dicEvaMsg[contentKey]?.stringValue
                                            
                                            var eva = LyEvaluationForTeacherManager.sharedInstance().getEvaluatoinWithEvaId(sEvaId)
                                            if nil == eva {
                                                let dicEva: Dictionary! = dicEvaMsg[evaluatingKey]?.dictionaryValue
                                                guard nil != dicEva && !dicEva.isEmpty else {
                                                    continue
                                                }
                                                
                                                var sEvaTime = dicEva[timeKey]?.stringValue
                                                //                                                let sEvaMasterId = dicEva[masterIdKey]?.stringValue
                                                //                                                let sEvaObjectId = dicEva[objectIdKey]?.stringValue
                                                let sEvaContent = dicEva[contentKey]?.stringValue
                                                let fScore = dicEva[scoreKey]?.floatValue
                                                let iLevel = dicEva[evaluationLevelKey]?.intValue
                                                
                                                var student = LyUserManager.sharedInstance().getUserWithUserId(sRepMasterId)
                                                if nil == student {
                                                    var sNickName = dicEva[nickNameKey]?.stringValue
                                                    if !LyUtil.validateString(sNickName) {
                                                        sNickName = LyUtil.getUserName(withUserId: sRepMasterId)
                                                    }
                                                    
                                                    student = LyUser(id: sRepMasterId, userName: sNickName)
                                                    LyUserManager.sharedInstance().add(student)
                                                }
                                                
                                                sEvaTime = LyUtil.fixDateTime(sEvaTime)
                                                let eLevel = LyEvaluationLevel(rawValue: iLevel!) ?? .good
                                                
                                                eva = LyEvaluationForTeacher(id: sEvaId,
                                                                             content: sEvaContent,
                                                                             time: sEvaTime,
                                                                             masterId: sRepMasterId,
                                                                             objectId: LyCurrentUser.cur().userId,
                                                                             score: fScore ?? 5,
                                                                             level: eLevel)
                                                
                                                LyEvaluationForTeacherManager.sharedInstance().addEvalution(eva)
                                                
                                            }
                                            
                                            
                                            sRepTime = LyUtil.fixDateTime(sRepTime)
                                            
                                            let rep = LyReply(id: sRepId,
                                                              masterId: sRepMasterId,
                                                              objectId: LyCurrentUser.cur().userId,
                                                              objectingId: sEvaId,
                                                              content: sRepContent,
                                                              time: sRepTime,
                                                              objectRpId: nil)
                                            
                                            if let reply = rep {
                                                self.arrEvaMsg.append(reply)
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
    
    
    func reply(_ text: String) {
        indicator_oper.title = LyIndicatorTitle_reply
        indicator_oper.startAnimation()
        
        let evaMsg = arrEvaMsg[curIdx.row]
        var sEvaId = ""
        if evaMsg is LyEvaluationForTeacher {
            sEvaId = evaMsg.oId
        } else {
            sEvaId = evaMsg.objectingId
        }
        
        LyHttpRequest.start(replyEva_url,
                            body: [contentKey: text,
                                   evaluationIdKey: sEvaId,
                                   objectIdKey: evaMsg.masterId,
                                   masterIdKey: LyCurrentUser.cur().userId,
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
                                
                                let iCode = json[codeKey].intValue
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
extension LyEvaMsgTableViewController {
    func handleHttpFailed(_ needRemind: Bool) {
        if indicator.isAnimating() {
            indicator.stopAnimation()
            self.refreshControl?.endRefreshing()
            tvFooter.stopAnimation()
            
            tvFooter.status = .error
        }
        
        if tvFooter.isAnimating {
            tvFooter.stopAnimation()
            
            tvFooter.status = .error
        }
        
        if indicator_oper.isAnimating() {
            indicator_oper.stopAnimation()
            
            var sTitle = LySLocalize("操作失败")
            if indicator_oper.title == LyIndicatorTitle_reply {
                sTitle = LySLocalize("回复失败")
            }
            
            LyRemindView.remind(with: .fail, withTitle: sTitle).show()
        }
    }
}



// MARK: - LyEvaMsgDetailViewControllerDelegate
extension LyEvaMsgTableViewController {
    func evaByEvaMsgDetailViewController(_ aEvaMsgDetailVC: LyEvaMsgDetailViewController) -> LyEvaluationForTeacher! {
        var eva: LyEvaluationForTeacher! = nil
        
        let evaMsg = arrEvaMsg[curIdx.row]
        if evaMsg is LyEvaluationForTeacher {
            eva = evaMsg as! LyEvaluationForTeacher
        } else {
            eva = LyEvaluationForTeacherManager.sharedInstance().getEvaluatoinWithEvaId(evaMsg.objectingId)
        }
        
        return eva
    }
}


// MARK: - LyReplyViewDelegate
extension LyEvaMsgTableViewController {
    func sendByReplyView(_ aReplyView: LyReplyView, text: String) {
        aReplyView.hide()
        
        _ = self.perform(#selector(reply), with: text, afterDelay: LyDelayTime)
        
    }
}


// MARK: - LyEvaMsgTableViewCellDelegate
extension LyEvaMsgTableViewController {
    func replyByEvaMsgTableViewCell(_ aCell: LyEvaMsgTableViewCell) {
        curIdx = self.tableView.indexPath(for: aCell)
        
        let replyView = LyReplyView(delegate: self)
        replyView.show()
    }
}


// MARK: - LyTableViewFooterViewDelegate
extension LyEvaMsgTableViewController {
    func loadMoreData(_ tableViewFooterView: LyTableViewFooterView!) {
        loadMore()
    }
}


// MARK: - UITableViewDelegate
extension LyEvaMsgTableViewController {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let evaMsg = arrEvaMsg[indexPath.row]
        
        if evaMsg is LyEvaluationForTeacher {
            if LyChatCellHeightMin > evaMsg.height || evaMsg.height > LyChatCellHeightMax {
                var cell: LyEvaMsgTableViewCell! = tableView.dequeueReusableCell(withIdentifier: lyEvaMsgTableViewCellReuseIdentifier) as! LyEvaMsgTableViewCell!
                if nil == cell {
                    cell = LyEvaMsgTableViewCell(style: .default, reuseIdentifier: lyEvaMsgTableViewCellReuseIdentifier)
                }
                
                cell.eva = evaMsg as! LyEvaluationForTeacher
            }
            
            return evaMsg.height
            
        } else {
            if LyChatCellHeightMin > evaMsg.height || evaMsg.height > LyChatCellHeightMax {
                var cell: LyEvaMsgTableViewCell! = tableView.dequeueReusableCell(withIdentifier: lyEvaMsgTableViewCellReuseIdentifier) as! LyEvaMsgTableViewCell!
                if nil == cell {
                    cell = LyEvaMsgTableViewCell(style: .default, reuseIdentifier: lyEvaMsgTableViewCellReuseIdentifier)
                }
                
                cell.reply = evaMsg as! LyReply
            }
            
            return evaMsg.height_m
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        curIdx = indexPath
        
        let evaMsgDetail = LyEvaMsgDetailViewController()
        evaMsgDetail.delegate = self
        self.navigationController?.pushViewController(evaMsgDetail, animated: true)
    }
}


// MARK: - Table view data source
extension LyEvaMsgTableViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrEvaMsg.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: LyEvaMsgTableViewCell! = tableView.dequeueReusableCell(withIdentifier: lyEvaMsgTableViewCellReuseIdentifier) as! LyEvaMsgTableViewCell!
        if nil == cell {
            cell = LyEvaMsgTableViewCell(style: .default, reuseIdentifier: lyEvaMsgTableViewCellReuseIdentifier)
        }
        
        let evaMsg = arrEvaMsg[indexPath.row]
        if evaMsg is LyEvaluationForTeacher {
            cell.eva = evaMsg as! LyEvaluationForTeacher
        } else {
            cell.reply = evaMsg as! LyReply
        }
        cell.delegate = self
        
        return cell
    }
}

