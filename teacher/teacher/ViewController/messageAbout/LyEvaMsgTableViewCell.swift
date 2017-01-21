//
//  LyEvaMsgTableViewCell.swift
//  teacher
//
//  Created by MacMini on 2017/1/5.
//  Copyright © 2017年 517xueche. All rights reserved.
//

import UIKit

protocol LyEvaMsgTableViewCellDelegate {
    func replyByEvaMsgTableViewCell(_ aCell: LyEvaMsgTableViewCell)
}


fileprivate let emIvAvatarSize = CGFloat(40)

fileprivate var emLbTitleWidth: CGFloat = 0
fileprivate let emLbTitleHeight = CGFloat(20)
fileprivate let emLbTitleFont = LySFont(14)
fileprivate let emLbTimeFont = LySFont(12)

fileprivate let emBtnReplyWidth = CGFloat(80)
fileprivate let emBtnReplyHeight = CGFloat(40)

fileprivate let emViewEvaWidth = SCREEN_WIDTH - horizontalSpace * 2
fileprivate let emTvContentFont = LySFont(13)

fileprivate let emLbScoreWidth = CGFloat(50)
fileprivate let emLbScoreHeight = CGFloat(15)
fileprivate let emLbScoreFont = LySFont(13)

fileprivate let emSrScoreHeight: CGFloat = emLbScoreHeight
fileprivate let emSrScoreWidth: CGFloat = emSrScoreHeight * 6

fileprivate let emIvLevelHeight = emLbScoreHeight
fileprivate let emIvLevelWidth = emIvLevelHeight * 3


fileprivate let lyEvaMsgReplyTableViewCellReuseIdentifier = "lyEvaMsgReplyTableViewCellReuseIdentifier"


class LyEvaMsgTableViewCell: UITableViewCell, UITableViewDelegate, UITableViewDataSource {

    
    var delegate: LyEvaMsgTableViewCellDelegate?
    var eva: LyEvaluationForTeacher! = nil {
        didSet {
            arrRep = []
            if nil != eva.arrReply && eva.arrReply.count > 0 {
                for rep in eva.arrReply {
                    if rep is LyReply && nil != (rep as! LyReply).oId {
                        arrRep.append(rep as! LyReply)
                    }
                }
            }
            reloadData()
        }
    }
    var reply: LyReply! = nil {
        didSet {
            arrRep = []
            arrRep.append(reply)
            reloadData()
        }
    }
    var arrRep = [LyReply]()
    
    var height: CGFloat = 0
    
    var bFlagSetHeight = false
    var heightTvReply: CGFloat = 0
    
    
    
    
    var ivAvatar: UIImageView!
    var lbTitle: UILabel!
    var lbTime: UILabel!
    var btnReply: UIButton!
    
    var viewEva: UIView!
    var tvContent: UITextView!
    var ivLevel: UIImageView!
    var srScore: TQStarRatingView!
    var lbScore: UILabel!

    var tvReply: UITableView?
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override public init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        emLbTitleWidth = SCREEN_WIDTH - emIvAvatarSize - emBtnReplyWidth - horizontalSpace * 4
        
        initSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initSubviews() {
        self.selectionStyle = .none
        
        ivAvatar = UIImageView(frame: CGRect(x: horizontalSpace, y: horizontalSpace, width: emIvAvatarSize, height: emIvAvatarSize))
        ivAvatar.contentMode = .scaleAspectFill
        ivAvatar.clipsToBounds = true
        ivAvatar.layer.cornerRadius = emIvAvatarSize / 2.0
        
        lbTitle = UILabel(frame: CGRect(x: horizontalSpace * 2 + emIvAvatarSize, y: ivAvatar.ly_y, width: emLbTitleWidth, height: emLbTitleHeight))
        lbTitle.font = emLbTitleFont
        lbTitle.textColor = LyBlackColor
        lbTitle.textAlignment = NSTextAlignment.left
        
        lbTime = UILabel(frame: CGRect(x: horizontalSpace * 2 + emIvAvatarSize, y: lbTitle.ly_y + emLbTitleHeight, width: emLbTitleWidth, height: emLbTitleHeight))
        lbTime.font = emLbTimeFont
        lbTime.textColor = UIColor.darkGray
        lbTime.textAlignment = NSTextAlignment.left
        
        btnReply = UIButton(frame: CGRect(x: SCREEN_WIDTH - horizontalSpace - emBtnReplyWidth, y: ivAvatar.ly_y, width: emBtnReplyWidth, height: emBtnReplyHeight))
        btnReply.setImage(LyUtil.image(forImageName: "btn_reply", needCache: false), for: UIControlState.normal)
        btnReply.addTarget(self, action: #selector(actionForBtnReply), for: UIControlEvents.touchUpInside)
        
        
        viewEva = UIView()
        viewEva.backgroundColor = LyWhiteLightgrayColor
        viewEva.layer.cornerRadius = 2
        viewEva.clipsToBounds = true
        
        tvContent = UITextView()
        tvContent.font = emTvContentFont
        tvContent.textColor = UIColor.darkGray
        tvContent.isEditable = false
        tvContent.textAlignment = NSTextAlignment.left
        tvContent.layer.cornerRadius = 2
        tvContent.clipsToBounds = true
        tvContent.backgroundColor = LyWhiteLightgrayColor
        tvContent.textContainerInset = UIEdgeInsets(top: verticalSpace, left: 0, bottom: verticalSpace, right: 0)
        tvContent.isUserInteractionEnabled = false
        
        ivLevel = UIImageView()
        
        srScore = TQStarRatingView(frame: CGRect(x: 0, y: 0, width: emSrScoreWidth, height: emSrScoreHeight), numberOfStar: 5)
        srScore.isUserInteractionEnabled = false
        
        lbScore = UILabel()
        lbScore.font = emLbScoreFont
        lbScore.textColor = Ly517ThemeColor
        lbScore.textAlignment = .center

        viewEva.addSubview(tvContent)
        viewEva.addSubview(ivLevel)
        viewEva.addSubview(srScore)
        viewEva.addSubview(lbScore)
        
        
        
        addSubview(ivAvatar)
        addSubview(lbTitle)
        addSubview(lbTime)
        addSubview(btnReply)
        addSubview(viewEva)
        
        
        arrRep = []
    }
    
    
    func reloadData() {
        guard nil != eva || nil != reply else {
            return
        }
        
        heightTvReply = 0
        bFlagSetHeight = false
        
        var sStudentId = ""
        var evaluation: LyEvaluationForTeacher! = nil
        if nil != eva {
            sStudentId = eva.masterId
            evaluation = eva
        } else {
            sStudentId = reply.masterId
            evaluation = LyEvaluationForTeacherManager.sharedInstance().getEvaluatoinWithEvaId(reply.objectingId)
        }
        
        
        let student = LyUserManager.sharedInstance().getUserWithUserId(sStudentId)
        if let avatar = student?.userAvatar {
            ivAvatar.image = avatar
        } else {
            ivAvatar.sd_setImage(with: LyUtil.getUserAvatarUrl(withUserId: student?.userId),
                                 placeholderImage: LyUtil.defaultAvatarForStudent(),
                                 options: .retryFailed,
                                 completed: { [weak ivAvatar, weak student] (image, error, type, url) in
                                    if nil != image {
                                        student?.userAvatar = image
                                        
                                    } else {
                                        ivAvatar?.sd_setImage(with: LyUtil.getJpgUserAvatarUrl(withUserId: student?.userId),
                                                              placeholderImage: LyUtil.defaultAvatarForStudent(),
                                                              options: .retryFailed,
                                                              completed: { (image, error, type, url) in
                                                                if nil != image {
                                                                    student?.userAvatar = image
                                                                }
                                        })
                                    }
            })
            
        }
        
        let sStudentName = (student?.userName)!
//        let sMyName = LyCurrentUser.cur().userName!
        
        let sTvContent_tmp = sStudentName + "：" + evaluation.content
        let sTvContent = NSMutableAttributedString(string: sTvContent_tmp)
        sTvContent.addAttributes([NSForegroundColorAttributeName: Ly517ThemeColor], range: LyUtil.range(of: sTvContent_tmp, subStr: sStudentName))
        tvContent.attributedText = sTvContent
        let fHeightTvContent = tvContent.sizeThatFits(CGSize(width: emViewEvaWidth, height: CGFloat(MAXFLOAT))).height
        tvContent.frame = CGRect(x: 0, y: 0, width: emViewEvaWidth, height: fHeightTvContent)
        
        lbScore.frame = CGRect(x: emViewEvaWidth - emLbScoreWidth, y: tvContent.frame.origin.y + fHeightTvContent + verticalSpace, width: emLbScoreWidth, height: emLbScoreHeight)
        lbScore.text = String(format: "%.1f", evaluation.score) + "分"
        
        srScore.frame = CGRect(x: lbScore.ly_x - horizontalSpace - emSrScoreWidth, y: lbScore.ly_y, width: emSrScoreWidth, height: emSrScoreHeight)
        srScore.setScore(evaluation.score / 5.0, withAnimation: false)
        
        ivLevel.frame = CGRect(x: srScore.ly_x - horizontalSpace - emIvLevelWidth, y: srScore.ly_y, width: emIvLevelWidth, height: emIvLevelHeight)
        ivLevel.image = {
            var sImageName = ""
            switch evaluation.level {
            case .good:
                sImageName = "evaLevel_good"
            case .middle:
                sImageName = "evaLevel_middle"
            case .bad:
                sImageName = "evaLevel_bad"
            }
            return LyUtil.image(forImageName: sImageName, needCache: false)
        }()
        
        viewEva.frame = CGRect(x: horizontalSpace, y: ivAvatar.ly_y + emIvAvatarSize + verticalSpace, width: emViewEvaWidth, height: lbScore.ly_y + lbScore.ly_height + verticalSpace)
        
        
        if arrRep.isEmpty {
            tvReply?.removeFromSuperview()
            
            height = viewEva.ly_y + viewEva.frame.size.height + horizontalSpace
            
        } else {
            if nil == tvReply {
                tvReply = UITableView(frame: CGRect(x: 0, y: viewEva.ly_y + viewEva.frame.size.height + verticalSpace, width: SCREEN_WIDTH, height: 10),
                                      style: UITableViewStyle.plain)
                tvReply?.delegate = self
                tvReply?.dataSource = self
                tvReply?.isScrollEnabled = false
                tvReply?.separatorStyle = .none
                tvReply?.isUserInteractionEnabled = false
            } else {
                tvReply?.frame = CGRect(x: 0, y: viewEva.ly_y + viewEva.frame.size.height + verticalSpace, width: SCREEN_WIDTH, height: 10)
            }
            
            addSubview(tvReply!)
            tvReply?.reloadData()
            
            height = (tvReply?.ly_y)! + (tvReply?.frame.size.height)! + horizontalSpace
        }
        
        
        if nil != eva {
            lbTitle.text = sStudentName + " " + LySLocalize("评价了我")
            lbTime.text = LyUtil.translateTime(evaluation.time)
            
            eva.height = height
            
        } else {
            lbTitle.text = sStudentName + " " + LySLocalize("回复了我")
            lbTime.text = LyUtil.translateTime(reply.time)
            
            reply.height_m = height
        }
        
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func actionForBtnReply() {
        delegate?.replyByEvaMsgTableViewCell(self)
    }
    
    
    
}


// MARK - UITableViewDelegate
extension LyEvaMsgTableViewCell {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var fHeight: CGFloat = 0
        
        let rep: LyReply = arrRep[indexPath.row] as! LyReply
        if LyChatCellHeightMin > reply.height || reply.height > LyChatCellHeightMax {
            var cell: LyReplyTableViewCell! = tableView.dequeueReusableCell(withIdentifier: lyEvaMsgReplyTableViewCellReuseIdentifier) as! LyReplyTableViewCell!
            if nil == cell {
                cell = LyReplyTableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: lyEvaMsgReplyTableViewCellReuseIdentifier)
            }
            cell.reply = rep
        }
        
        fHeight = rep.height
        if !bFlagSetHeight {
            if arrRep.count > indexPath.row + 1 {
                heightTvReply += fHeight
            } else {
                bFlagSetHeight = true
                heightTvReply += fHeight
                tvReply?.frame = CGRect(x: 0, y: viewEva.ly_y + viewEva.frame.size.height + verticalSpace, width: SCREEN_WIDTH, height: heightTvReply)
                
                height = (tvReply?.ly_y)! + fHeight + horizontalSpace
                
                if nil != eva {
                    eva.height = height
                } else {
                    reply.height_m = height
                }
            }
            
        }
        
        return fHeight
        
    }
}


// MARK - UITableViewDataSource
extension LyEvaMsgTableViewCell {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrRep.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: LyReplyTableViewCell! = tableView.dequeueReusableCell(withIdentifier: lyEvaMsgReplyTableViewCellReuseIdentifier) as! LyReplyTableViewCell!
        if nil == cell {
            cell = LyReplyTableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: lyEvaMsgReplyTableViewCellReuseIdentifier)
        }
        
        cell.reply = arrRep[indexPath.row]
        
        return cell
    }
}


