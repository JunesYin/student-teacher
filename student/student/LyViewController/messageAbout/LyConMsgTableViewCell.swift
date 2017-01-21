//
//  LyConMsgTableViewCell.swift
//  teacher
//
//  Created by MacMini on 2017/1/3.
//  Copyright © 2017年 517xueche. All rights reserved.
//

import UIKit


protocol LyConMsgTableViewCellDelegate {
    func replyByConMsgTableViewCell(_ aCell: LyConMsgTableViewCell)
}


fileprivate let cmIvAvatarSize = CGFloat(40)

fileprivate var cmLbNameWidth: CGFloat = 0
fileprivate let cmLbNameHeight = CGFloat(20)
fileprivate let cmLbNameFont = LySFont(14)
fileprivate let cmLbTimeFont = LySFont(12)

fileprivate let cmBtnReplyWidth = CGFloat(80)
fileprivate let cmBtnReplyHeight = CGFloat(40)

fileprivate let cmTvContentFont = LySFont(13)
fileprivate let cmTvContentWidth = SCREEN_WIDTH - horizontalSpace * 2


fileprivate let lyConMsgReplyTableViewCellReuseIdentifier = "lyConMsgReplyTableViewCellReuseIdentifier"


class LyConMsgTableViewCell: UITableViewCell, UITableViewDelegate, UITableViewDataSource {

    
    
    var delegate: LyConMsgTableViewCellDelegate?
    var idx: IndexPath!
    var reply: LyReply! = nil {
        didSet {
            arrRep.append(reply)
            reloadData()
        }
    }
    var arrRep = [LyReply]()
    
    var height: CGFloat = 0
    
    var bFlagSetHeight = false
    var heightTvReply: CGFloat = 0
    
    
    var ivAvatar: UIImageView!
    var lbName: UILabel!
    var lbTime: UILabel!
    var btnReply: UIButton!
    var tvContent: UITextView!
    var tvReply: UITableView?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override public init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        cmLbNameWidth = SCREEN_WIDTH - cmIvAvatarSize - cmBtnReplyWidth - horizontalSpace * 4
        
        initSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initSubviews() {
        self.selectionStyle = .none
        
        ivAvatar = UIImageView(frame: CGRect(x: horizontalSpace, y: horizontalSpace, width: cmIvAvatarSize, height: cmIvAvatarSize))
        ivAvatar.contentMode = .scaleAspectFill
        ivAvatar.clipsToBounds = true
        ivAvatar.layer.cornerRadius = cmIvAvatarSize / 2.0
        
        lbName = UILabel(frame: CGRect(x: horizontalSpace * 2 + cmIvAvatarSize, y: ivAvatar.ly_y, width: cmLbNameWidth, height: cmLbNameHeight))
        lbName.font = cmLbNameFont
        lbName.textColor = LyBlackColor
        lbName.textAlignment = NSTextAlignment.left
        
        lbTime = UILabel(frame: CGRect(x: horizontalSpace * 2 + cmIvAvatarSize, y: lbName.frame.origin.y + cmLbNameHeight, width: cmLbNameWidth, height: cmLbNameHeight))
        lbTime.font = cmLbTimeFont
        lbTime.textColor = UIColor.darkGray
        lbTime.textAlignment = NSTextAlignment.left
        
        btnReply = UIButton(frame: CGRect(x: SCREEN_WIDTH - cmBtnReplyWidth, y: ivAvatar.ly_y, width: cmBtnReplyWidth, height: cmBtnReplyHeight))
        btnReply.setImage(LyUtil.image(forImageName: "btn_reply", needCache: false), for: UIControlState.normal)
        btnReply.addTarget(self, action: #selector(actionForBtnReply), for: UIControlEvents.touchUpInside)
        
        tvContent = UITextView()
        tvContent.font = cmTvContentFont
        tvContent.textColor = UIColor.darkGray
        tvContent.isEditable = false
        tvContent.textAlignment = NSTextAlignment.left
        tvContent.backgroundColor = LyWhiteLightgrayColor
        tvContent.layer.cornerRadius = 2
        tvContent.clipsToBounds = true
        tvContent.textContainerInset = UIEdgeInsets(top: verticalSpace, left: verticalSpace, bottom: verticalSpace, right: verticalSpace)
        tvContent.isUserInteractionEnabled = false
        
        
        addSubview(ivAvatar)
        addSubview(lbName)
        addSubview(lbTime)
        addSubview(btnReply)
        addSubview(tvContent)
        
        
        arrRep = []
    }

    
    func reloadData() {
        guard nil != reply else {
            return
        }

        arrRep = LyUtil.uniquifyArray(arrRep, key: "oId") as! [LyReply]
        
        heightTvReply = 0
        bFlagSetHeight = false
        
        let con: LyConsult! = LyConsultManager.sharedInstance().getConsultWithConId(reply.objectingId)
        let teacher = LyUserManager.sharedInstance().getUserWithUserId(reply.masterId!)
        if let avatar = teacher?.userAvatar {
            ivAvatar.image = avatar
        } else {
            ivAvatar.sd_setImage(with: LyUtil.getUserAvatarUrl(withUserId: teacher?.userId),
                                 placeholderImage: LyUtil.defaultAvatarForTeacher(),
                                 options: .retryFailed,
                                 completed: { [weak ivAvatar, weak teacher] (image, error, type, url) in
                                    if nil != image {
                                        teacher?.userAvatar = image
                                        
                                    } else {
                                        ivAvatar?.sd_setImage(with: LyUtil.getJpgUserAvatarUrl(withUserId: teacher?.userId),
                                                              placeholderImage: LyUtil.defaultAvatarForTeacher(),
                                                              options: .retryFailed,
                                                              completed: { (image, error, type, url) in
                                                                if nil != image {
                                                                    teacher?.userAvatar = image
                                                                }
                                        })
                                    }
            })
            
        }
        
        let sTeacherName = (teacher?.userName)!
        let sMyName = LyCurrentUser.cur().userName!
        
        lbName.text = sTeacherName + " 回复了我"
        
        lbTime.text = LyUtil.translateTime(reply.time)
        
        let sTvContent_tmp: String = sMyName + "：" + con.content!
        let sTvContent = NSMutableAttributedString(string: sTvContent_tmp)
        sTvContent.addAttributes([NSForegroundColorAttributeName: Ly517ThemeColor], range: LyUtil.range(of: sTvContent_tmp, subStr: sMyName))
        tvContent.attributedText = sTvContent
        let fHeightTvContent = tvContent.sizeThatFits(CGSize(width: cmTvContentWidth, height: CGFloat.greatestFiniteMagnitude)).height
        tvContent.frame = CGRect(x: ivAvatar.frame.origin.x, y: ivAvatar.frame.origin.y + cmIvAvatarSize + verticalSpace, width: cmTvContentWidth, height: fHeightTvContent)
        
        
        if arrRep.isEmpty {
            tvReply?.removeFromSuperview()
            
            height = tvContent.frame.origin.y + fHeightTvContent + horizontalSpace
        } else {
            if nil == tvReply {
                tvReply = UITableView(frame: CGRect(x: 0, y: tvContent.frame.origin.y + fHeightTvContent + verticalSpace, width: SCREEN_WIDTH, height: 10),
                                      style: UITableViewStyle.plain)
                tvReply?.delegate = self
                tvReply?.dataSource = self
                tvReply?.isScrollEnabled = false
                tvReply?.separatorStyle = .none
                tvReply?.isUserInteractionEnabled = false
            } else {
                tvReply?.frame = CGRect(x: 0, y: tvContent.frame.origin.y + fHeightTvContent + verticalSpace, width: SCREEN_WIDTH, height: 10)
            }
            
            addSubview(tvReply!)
            tvReply?.reloadData()
            
            height = (tvReply?.frame.origin.y)! + (tvReply?.frame.size.height)! + horizontalSpace
            
        }
        
        reply.height_m = height
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func actionForBtnReply() {
        delegate?.replyByConMsgTableViewCell(self)
    }
    
    
}


// MARK - UITableViewDelegate
extension LyConMsgTableViewCell {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var fHeight: CGFloat = 0
        
        let rep = arrRep[indexPath.row]
        if LyChatCellHeightMin > rep.height || rep.height > LyChatCellHeightMax {
            var cell: LyReplyTableViewCell! = tableView.dequeueReusableCell(withIdentifier: lyConMsgReplyTableViewCellReuseIdentifier) as! LyReplyTableViewCell!
            if nil == cell {
                cell = LyReplyTableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: lyConMsgReplyTableViewCellReuseIdentifier)
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
                tvReply?.frame = CGRect(x: 0, y: tvContent.frame.origin.y + tvContent.frame.size.height + verticalSpace, width: SCREEN_WIDTH, height: heightTvReply)
                
                height = (tvReply?.frame.origin.y)! + fHeight + horizontalSpace
                reply.height_m = height
            }
            
        }
        
        return fHeight
        
    }

}


 // MARK - UITableViewDataSource
extension LyConMsgTableViewCell {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrRep.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: LyReplyTableViewCell! = tableView.dequeueReusableCell(withIdentifier: lyConMsgReplyTableViewCellReuseIdentifier) as! LyReplyTableViewCell!
        if nil == cell {
            cell = LyReplyTableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: lyConMsgReplyTableViewCellReuseIdentifier)
        }
        cell.reply = arrRep[indexPath.row]
        
        return cell
    }
}


