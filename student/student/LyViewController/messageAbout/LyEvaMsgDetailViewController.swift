//
//  LyEvaMsgDetailViewController.swift
//  teacher
//
//  Created by MacMini on 2017/1/6.
//  Copyright © 2017年 517xueche. All rights reserved.
//

import UIKit
import SwiftyJSON


protocol LyEvaMsgDetailViewControllerDelegate {
    func evaByEvaMsgDetailViewController(_ aEvaMsgDetailVC: LyEvaMsgDetailViewController) -> LyEvaluationForTeacher!
}


// MARK: - CONSTANT
fileprivate let emdIvAvatarSize = CGFloat(40)

fileprivate var emdLbNameWidth: CGFloat = 0
fileprivate let emdLbNameHeight = CGFloat(20)
fileprivate let emdLbNameFont = LySFont(14)
fileprivate let emdLbTimeFont = LySFont(12)
fileprivate let emdTvContentFont = LySFont(13)

fileprivate let emdLbScoreWidth = CGFloat(50)
fileprivate let emdLbScoreHeight = CGFloat(15)
fileprivate let emdLbScoreFont = LySFont(13)

fileprivate let emdSrScoreHeight: CGFloat = emdLbScoreHeight
fileprivate let emdSrScoreWidth: CGFloat = emdSrScoreHeight * 6

fileprivate let emdIvLevelHeight = emdLbScoreHeight
fileprivate let emdIvLevelWidth = emdIvLevelHeight * 3

fileprivate let emdBtnReplyHeight = LyViewItemHeight

fileprivate let lyEvaMsgDetailReplyTableViewCellReuseIdentifier = "lyEvaMsgDetailReplyTableViewCellReuseIdentifier"

fileprivate enum LyEvaMsgDetailButtonTag: Int {
    case reply = 20
}


class LyEvaMsgDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, LySUtilDelegate, LyReplyViewDelegate {

    var delegate: LyEvaMsgDetailViewControllerDelegate?
    var eva: LyEvaluationForTeacher!
    var arrRep = [LyReply]()
    
    
    
    var viewHeader: UIView!
    var ivAvatar: UIImageView!
    var lbName: UILabel!
    var lbTime: UILabel!
    var tvContent: UITextView!
    var ivLevel: UIImageView!
    var srScore: TQStarRatingView!
    var lbScore: UILabel!
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
        eva = delegate?.evaByEvaMsgDetailViewController(self)
        
        guard nil != eva else {
            _ = self.navigationController?.popViewController(animated: true)
            return
        }
        
        reloadData_header()
        
        if arrRep.isEmpty {
            load()
        }
        
    }
    
    func initSubviews() {
        emdLbNameWidth = SCREEN_WIDTH - horizontalSpace * 3 - emdIvAvatarSize
        
        self.title = "评价详情"
        self.view.backgroundColor = LyWhiteLightgrayColor
        self.automaticallyAdjustsScrollViewInsets = false
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .done, target: nil, action: nil)
        
        
        viewHeader = UIView()
        viewHeader.backgroundColor = UIColor.white
        
        ivAvatar = UIImageView(frame: CGRect(x: horizontalSpace, y: verticalSpace, width: emdIvAvatarSize, height: emdIvAvatarSize))
        ivAvatar.contentMode = .scaleAspectFill
        ivAvatar.layer.cornerRadius = emdIvAvatarSize / 2.0
        ivAvatar.clipsToBounds = true
        
        lbName = UILabel(frame: CGRect(x: horizontalSpace * 2 + emdIvAvatarSize, y: verticalSpace, width: emdLbNameWidth, height: emdLbNameHeight))
        lbName.font = emdLbNameFont
        lbName.textColor = LyBlackColor
        
        lbTime = UILabel(frame: CGRect(x: horizontalSpace * 2 + emdIvAvatarSize,
                                       y: verticalSpace + emdLbNameHeight,
                                       width: emdLbNameWidth,
                                       height: emdLbNameHeight))
        lbTime.font = emdLbTimeFont
        lbTime.textColor = UIColor.gray
        
        tvContent = UITextView()
        tvContent.font = emdTvContentFont
        tvContent.textColor = UIColor.darkGray
        tvContent.isEditable = false
        tvContent.isScrollEnabled = false
        
        lbScore = UILabel()
        lbScore.font = emdLbScoreFont
        lbScore.textColor = Ly517ThemeColor
        lbScore.textAlignment = .center
        
        srScore = TQStarRatingView(frame: CGRect(x: 0, y: 0, width: emdSrScoreWidth, height: emdSrScoreHeight), numberOfStar: 5)
        srScore.isUserInteractionEnabled = false
        
        ivLevel = UIImageView()
        
        line = UIView()
        line.backgroundColor = LyWhiteLightgrayColor
        
        viewHeader.addSubview(ivAvatar)
        viewHeader.addSubview(lbName)
        viewHeader.addSubview(lbTime)
        viewHeader.addSubview(tvContent)
        viewHeader.addSubview(lbScore)
        viewHeader.addSubview(srScore)
        viewHeader.addSubview(ivLevel)
        viewHeader.addSubview(line)
        
        
        tableView = UITableView(frame: CGRect(x: 0, y: STATUSBAR_NAVIGATIONBAR_HEIGHT, width: SCREEN_WIDTH, height: APPLICATION_HEIGHT - emdBtnReplyHeight),
                                style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = LyWhiteLightgrayColor
        tableView.separatorStyle = .none
        
        
        refreshControl = LyUtil.refreshControl(withTitle: nil, target: self, action: #selector(refresh))
        
        tableView.addSubview(refreshControl)
        
        
        btnReply = UIButton(frame: CGRect(x: 0, y: SCREEN_HEIGHT - emdBtnReplyHeight, width: SCREEN_WIDTH, height: emdBtnReplyHeight))
        btnReply.tag = LyEvaMsgDetailButtonTag.reply.rawValue
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
        
        arrRep = LyUtil.uniquifyAndSort(arrRep, keyUniquify: "oId", keySort: "time", asc: true) as! [LyReply]
        
        tableView.reloadData()
    }
    
    func reloadData_header() {
        let master = LyUserManager.sharedInstance().getUserWithUserId(eva.masterId)
        if let avatar = master?.userAvatar {
            ivAvatar.image = avatar
        } else {
            ivAvatar.sd_setImage(with: LyUtil.getUserAvatarUrl(withUserId: eva.masterId),
                                 placeholderImage: LyUtil.defaultAvatarForStudent(),
                                 options: .retryFailed,
                                 completed: { [weak ivAvatar, weak eva] (image, _, _, _) in
                                    if nil != image {
                                        master?.userAvatar = image
                                    } else {
                                        ivAvatar?.sd_setImage(with: LyUtil.getUserAvatarUrl(withUserId: eva?.masterId),
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
        
        lbTime.text = LyUtil.translateTime(eva.time)
        
        tvContent.text = eva.content
        let fHeightTvContent = tvContent.sizeThatFits(CGSize(width: SCREEN_WIDTH - horizontalSpace * 2, height: CGFloat.greatestFiniteMagnitude)).height
        tvContent.frame = CGRect(x: horizontalSpace, y: ivAvatar.frame.origin.y + ivAvatar.frame.size.height, width: SCREEN_WIDTH - horizontalSpace * 2, height: fHeightTvContent)
        
        lbScore.frame = CGRect(x: SCREEN_WIDTH - horizontalSpace - emdLbScoreWidth, y: tvContent.frame.origin.y + fHeightTvContent + verticalSpace, width: emdLbScoreWidth, height: emdLbScoreHeight)
        lbScore.text = String(format: "%.1f", eva.score) + "分"
        
        srScore.frame = CGRect(x: lbScore.frame.origin.x - horizontalSpace - emdSrScoreWidth, y: lbScore.frame.origin.y, width: emdSrScoreWidth, height: emdSrScoreHeight)
        srScore.setScore(eva.score / 5.0, withAnimation: false)
        
        
        ivLevel.frame = CGRect(x: srScore.frame.origin.x - horizontalSpace - emdIvLevelWidth, y: srScore.frame.origin.y, width: emdIvLevelWidth, height: emdIvLevelHeight)
        ivLevel.image = {
            var sImageName = ""
            switch eva.level {
            case .good:
                sImageName = "evaLevel_good"
            case .middle:
                sImageName = "evaLevel_middle"
            case .bad:
                sImageName = "evaLevel_bad"
            }
            return LyUtil.image(forImageName: sImageName, needCache: false)
        }()
        
        
        line.frame = CGRect(x: 0, y: lbScore.frame.origin.y + lbScore.frame.size.height + verticalSpace, width: SCREEN_WIDTH, height: verticalSpace)
        
        viewHeader.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: line.frame.origin.y + line.frame.size.height)
        
        
        tableView.tableHeaderView = viewHeader
    }
    
    func showViewError() {
        if nil == viewError {
            viewError = UIView(frame: CGRect(x: 0, y: viewHeader.frame.origin.y + viewHeader.frame.size.height, width: SCREEN_WIDTH, height: LyViewErrorHeight))
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
            viewNull = UIView(frame: CGRect(x: 0, y: viewHeader.frame.origin.y + viewHeader.frame.size.height, width: SCREEN_WIDTH, height: LyViewNullHeight))
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
    
    
    func refresh() {
        load()
    }

    
    func actionForButton(_ btn: UIButton) {
        let btnTag: LyEvaMsgDetailButtonTag = LyEvaMsgDetailButtonTag(rawValue: btn.tag)!
        switch btnTag {
        case .reply:
            LyReplyView(delegate: self).show()
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
extension LyEvaMsgDetailViewController {
    func load() {
        indicator.startAnimation()
        
        LyHttpRequest.start(evaDetail_url,
                            body: [idKey: eva.oId,
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
                                
                                let iCode = json[codeKey].intValue
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
                                                            objectingId: self.eva.oId,
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
        
        LyHttpRequest.start(replyEva_url,
                            body: [contentKey: text,
                                   evaluationIdKey: eva.oId,
                                   objectIdKey: eva.objectId,
                                   masterIdKey: LyCurrentUser.cur().userId,
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
                                
                                let iCode = json[codeKey].intValue
                                switch iCode {
                                case 0:
                                    let dicResult: Dictionary! = json[resultKey].dictionaryValue
                                    guard !dicResult.isEmpty else {
                                        self.indicator_oper.stopAnimation()
                                        return
                                    }
                                    
                                    let sId = dicResult[idKey]?.stringValue
                                    var sTime = dicResult[timeKey]?.stringValue
                                    
                                    sTime = LyUtil.fixDateTime(sTime)
                                    
                                    let reply = LyReply(id: sId,
                                                        masterId: LyCurrentUser.cur().userId,
                                                        objectId: self.eva.masterId,
                                                        objectingId: self.eva.oId,
                                                        content: text,
                                                        time: sTime,
                                                        objectRpId: nil)
                                    
                                    if let rep = reply {
                                        self.arrRep.append(rep)
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
extension LyEvaMsgDetailViewController {
    func handleHttpFailed(_ needRemind: Bool) {
        if indicator.isAnimating() {
            indicator.stopAnimation()
            refreshControl?.endRefreshing()
            
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
extension LyEvaMsgDetailViewController {
    func sendByReplyView(_ aReplyView: LyReplyView, text: String) {
        aReplyView.hide()
        
//        _ = perform(#selector(reply), with: text, afterDelay: LyDelayTime)
        _ = perform(#selector(LyEvaMsgDetailViewController.reply(_:)), with: text, afterDelay: LyDelayTime)
    }
}



// MARK: - UITableViewDelegate
extension LyEvaMsgDetailViewController {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let reply = arrRep[indexPath.row]
        if LyChatCellHeightMin > reply.height || reply.height > LyChatCellHeightMax {
            var cell: LyReplyTableViewCell! = tableView.dequeueReusableCell(withIdentifier: lyEvaMsgDetailReplyTableViewCellReuseIdentifier) as! LyReplyTableViewCell!
            if nil == cell {
                cell = LyReplyTableViewCell(style: .default, reuseIdentifier: lyEvaMsgDetailReplyTableViewCellReuseIdentifier)
            }

            cell.reply = reply
        }
        
        return reply.height
    }
}


// MARK: - UITableViewDataSource
extension LyEvaMsgDetailViewController {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrRep.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: LyReplyTableViewCell! = tableView.dequeueReusableCell(withIdentifier: lyEvaMsgDetailReplyTableViewCellReuseIdentifier) as! LyReplyTableViewCell!
        if nil == cell {
            cell = LyReplyTableViewCell(style: .default, reuseIdentifier: lyEvaMsgDetailReplyTableViewCellReuseIdentifier)
        }
        
        cell.reply = arrRep[indexPath.row]
        
        return cell
    }
}


