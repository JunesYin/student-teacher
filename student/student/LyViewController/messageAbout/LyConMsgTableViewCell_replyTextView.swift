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

fileprivate let cmBtnReplyWidth = CGFloat(40)
fileprivate let cmBtnReplyHeight = CGFloat(20)

fileprivate let cmTvConContentFont = LySFont(13)
fileprivate let cmTvConContentWidth = SCREEN_WIDTH - horizontalSpace * 2

fileprivate let cmTvRepContentFont = LySFont(12)
fileprivate let cmTvRepContentWidth = SCREEN_WIDTH - horizontalSpace * 2



fileprivate let lyConMsgReplyTableViewCellReuseIdentifier = "lyConMsgReplyTableViewCellReuseIdentifier"


class LyConMsgTableViewCell: UITableViewCell {

    
    
    var delegate: LyConMsgTableViewCellDelegate?
    var idx: IndexPath!
    var reply: LyReply! = nil {
        didSet {
            reloadData()
        }
    }
    
    var height: CGFloat = 0
    
    var bFlagSetHeight = false
    var heightTvReply: CGFloat = 0
    
    
    var ivAvatar: UIImageView!
    var lbName: UILabel!
    var lbTime: UILabel!
    var btnReply: UIButton!
    
    var tvConContent: UITextView!
    
    var tvRepContent: UITextView!
//    var tvReply: UITableView?
    
    
    
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
        
        ivAvatar = UIImageView(frame: CGRect(x: horizontalSpace, y: verticalSpace, width: cmIvAvatarSize, height: cmIvAvatarSize))
        ivAvatar.contentMode = .scaleAspectFill
        ivAvatar.clipsToBounds = true
        ivAvatar.layer.cornerRadius = btnCornerRadius
        
        lbName = UILabel(frame: CGRect(x: horizontalSpace * 2 + cmIvAvatarSize, y: verticalSpace, width: cmLbNameWidth, height: cmLbNameHeight))
        lbName.font = cmLbNameFont
        lbName.textColor = LyBlackColor
        lbName.textAlignment = NSTextAlignment.left
        
        lbTime = UILabel(frame: CGRect(x: horizontalSpace * 2 + cmIvAvatarSize, y: lbName.frame.origin.y + cmLbNameHeight, width: cmLbNameWidth, height: cmLbNameHeight))
        lbTime.font = cmLbTimeFont
        lbTime.textColor = UIColor.darkGray
        lbTime.textAlignment = NSTextAlignment.left
        
        btnReply = UIButton(frame: CGRect(x: SCREEN_WIDTH - horizontalSpace - cmBtnReplyWidth, y: verticalSpace, width: cmBtnReplyWidth, height: cmBtnReplyHeight))
        btnReply.setImage(LyUtil.image(forImageName: "btn_reply", needCache: false), for: UIControlState.normal)
        btnReply.addTarget(self, action: #selector(actionForBtnReply), for: UIControlEvents.touchUpInside)
        
        tvConContent = UITextView()
        tvConContent.font = cmTvConContentFont
        tvConContent.textColor = UIColor.darkGray
        tvConContent.isEditable = false
        tvConContent.textAlignment = NSTextAlignment.left
        tvConContent.backgroundColor = LyWhiteLightgrayColor
        tvConContent.layer.cornerRadius = 2
        tvConContent.clipsToBounds = true
        tvConContent.textContainerInset = UIEdgeInsets(top: verticalSpace, left: verticalSpace, bottom: verticalSpace, right: verticalSpace)
        tvConContent.isUserInteractionEnabled = false
        
        tvRepContent = UITextView()
        tvRepContent.font = cmTvRepContentFont
        tvRepContent.textColor = LyBlackColor
        tvRepContent.isEditable = false
        tvRepContent.textAlignment = .left
        tvRepContent.isUserInteractionEnabled = false
        
        
        
        addSubview(ivAvatar)
        addSubview(lbName)
        addSubview(lbTime)
        addSubview(btnReply)
        addSubview(tvConContent)
        addSubview(tvRepContent)
        
    }

    
    func reloadData() {
        guard nil != reply else {
            return
        }
        
        let con = LyConsultManager.sharedInstance().getConsultWithConId(reply.rpobjectingId)
        let teacher = LyUserManager.sharedInstance().getUserWithUserId(reply.rpMasterId!)
        if let avatar = teacher?.userAvatar {
            ivAvatar.image = avatar
        } else {
            ivAvatar.sd_setImage(with: LyUtil.getUserAvatarUrl(withUserId: teacher?.userId),
                                 placeholderImage: LyUtil.defaultAvatarForTeacher(),
                                 options: .retryFailed,
                                 completed: { [weak ivAvatar, weak teacher] (image, _, _, _) in
                                    if nil != image {
                                        teacher?.userAvatar = image
                                        
                                    } else {
                                        ivAvatar?.sd_setImage(with: LyUtil.getJpgUserAvatarUrl(withUserId: teacher?.userId),
                                                              placeholderImage: LyUtil.defaultAvatarForTeacher(),
                                                              options: .retryFailed,
                                                              completed: { (image, _, _, _) in
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
        
        lbTime.text = LyUtil.translateTime(reply.rpTime)
        
        let sTvConContent_tmp: String = sMyName + "：" + (con?.conContent)!
        let sTvConContent = NSMutableAttributedString(string: sTvConContent_tmp)
        sTvConContent.addAttributes([NSForegroundColorAttributeName: Ly517ThemeColor], range: LyUtil.range(of: sTvConContent_tmp, subStr: sMyName))
        tvConContent.attributedText = sTvConContent
        let fHeightTvConContent = tvConContent.sizeThatFits(CGSize(width: cmTvConContentWidth, height: CGFloat.greatestFiniteMagnitude)).height
        tvConContent.frame = CGRect(x: ivAvatar.frame.origin.x, y: ivAvatar.frame.origin.y + cmIvAvatarSize + verticalSpace, width: cmTvConContentWidth, height: fHeightTvConContent)
        
        
        let sTvRepContent_tmp: String = sTeacherName + "回复" + sMyName + "：" + reply.rpContent
        let sTvRepContent = NSMutableAttributedString(string: sTvRepContent_tmp)
        sTvRepContent.addAttributes([NSForegroundColorAttributeName: Ly517ThemeColor], range: LyUtil.range(of: sTvRepContent_tmp, subStr: sTeacherName))
        if sTeacherName == sMyName {
            sTvRepContent.addAttributes([NSForegroundColorAttributeName: Ly517ThemeColor], range: LyUtil.range(of: sTvRepContent_tmp, subStr: sMyName, options: .caseInsensitive))
        } else {
            sTvRepContent.addAttributes([NSForegroundColorAttributeName: Ly517ThemeColor], range: LyUtil.range(of: sTvRepContent_tmp, subStr: sMyName))
        }
        tvRepContent.attributedText = sTvRepContent
        let fHeightTvRepContent = tvRepContent.sizeThatFits(CGSize(width: cmTvRepContentWidth, height: CGFloat.greatestFiniteMagnitude)).height
        tvRepContent.frame = CGRect(x: horizontalSpace, y: tvConContent.ly_y + fHeightTvConContent, width: cmTvRepContentWidth, height: fHeightTvRepContent)
        
        height = tvRepContent.ly_y + fHeightTvRepContent + verticalSpace
        
        reply.height = height
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func actionForBtnReply() {
        delegate?.replyByConMsgTableViewCell(self)
    }
    
    
}




/*
// MARK - UITableViewDelegate
extension LyConMsgTableViewCell: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var fHeight: CGFloat = 0
        
        let reply: LyReply = con.conReply[indexPath.row] as! LyReply
        if LyChatCellHeightMin > reply.height || reply.height > LyChatCellHeightMax {
            var cell: LyReplyTableViewCell! = tableView.dequeueReusableCell(withIdentifier: lyConMsgReplyTableViewCellReuseIdentifier) as! LyReplyTableViewCell!
            if nil == cell {
                cell = LyReplyTableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: lyConMsgReplyTableViewCellReuseIdentifier)
            }
            cell.reply = reply
        }
        
        fHeight = reply.height
        if !bFlagSetHeight {
            if con.conReply.count > indexPath.row + 1 {
                heightTvReply += fHeight
            } else {
                bFlagSetHeight = true
                heightTvReply += fHeight
                tvReply?.frame = CGRect(x: 0, y: tvContent.frame.origin.y + tvContent.frame.size.height + verticalSpace, width: SCREEN_WIDTH, height: heightTvReply)
                
                height = (tvReply?.frame.origin.y)! + fHeight
                con.height = height
            }
            
        }
        
        return fHeight
        
    }
    
}


// MARK - UITableViewDataSource
extension LyConMsgTableViewCell: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return con.conReply.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: LyReplyTableViewCell! = tableView.dequeueReusableCell(withIdentifier: lyConMsgReplyTableViewCellReuseIdentifier) as! LyReplyTableViewCell!
        if nil == cell {
            cell = LyReplyTableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: lyConMsgReplyTableViewCellReuseIdentifier)
        }
        let reply = con.conReply[indexPath.row] as! LyReply
        cell.reply = reply
        
        return cell
    }
}
*/
