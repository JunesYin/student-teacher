//
//  LyAboutUsViewController.swift
//  student
//
//  Created by MacMini on 2017/1/9.
//  Copyright © 2017年 517xueche. All rights reserved.
//

import UIKit


fileprivate let auViewLogoHeight: CGFloat = 170;
fileprivate let auIvLogoSize: CGFloat = 90;

fileprivate let auLbVersionHeight: CGFloat = 40;
fileprivate let auLbVersionFont = LySFont(14)

fileprivate let auTableViewHeightMax: CGFloat = SCREEN_HEIGHT - STATUSBAR_NAVIGATIONBAR_HEIGHT - auViewLogoHeight - auLbCopyRightHeight

fileprivate let auLbCopyRightHeight: CGFloat = 50;
fileprivate let auLbCopyRightFont = LySFont(12)


fileprivate let lyAboutUsTableViewCellReuseIdentifier = "lyAboutUsTableViewCellReuseIdentifier";

@objc(LyAboutUsViewController)
class LyAboutUsViewController: UIViewController{

    
    let arrTitle = ["常见问题",
                   "联系我们",
                   "意见反馈",
                   "用户评分",
                   "分享应用"];
    let arrDetail = ["",
                     phoneNum_517,
                     "",
                     "用得如何呢？给点意见呗",
                     "邀请朋友们一起来学车吧"];
    
    var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        initSubviews()
    }

    func initSubviews() {
        self.title = "关于我们"
        self.view.backgroundColor = LyWhiteLightgrayColor
        self.automaticallyAdjustsScrollViewInsets = false
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .done, target: nil, action: nil)
        
        let viewLogo = UIView(frame: CGRect(x: 0, y: STATUSBAR_NAVIGATIONBAR_HEIGHT, width: SCREEN_WIDTH, height: auViewLogoHeight))
        viewLogo.backgroundColor = LyWhiteLightgrayColor
        
        let ivLogo = UIImageView(frame: CGRect(x: SCREEN_WIDTH/2.0 - auIvLogoSize/2.0, y: auViewLogoHeight/2.0 - auIvLogoSize/2.0, width: auIvLogoSize, height: auIvLogoSize))
        ivLogo.layer.cornerRadius = 20
        ivLogo.image = LyUtil.image(forImageName: "aboutUs_logo", needCache: false)
        ivLogo.clipsToBounds = true
        
        let lbVersion = UILabel(frame: CGRect(x: horizontalSpace, y: ivLogo.frame.origin.y + auIvLogoSize, width: SCREEN_WIDTH - horizontalSpace * 2, height: auLbVersionHeight))
        lbVersion.font = auLbVersionFont
        lbVersion.textColor = .gray
        lbVersion.textAlignment = .center
        lbVersion.text = "我要去学车 v" + LyUtil.getApplicationVersion()
        
        viewLogo.addSubview(ivLogo)
        viewLogo.addSubview(lbVersion)
        
        
        var fHeight: CGFloat = lmstcellHeight * CGFloat(arrTitle.count)
        let flag = fHeight > auTableViewHeightMax
        if flag {
            fHeight = auTableViewHeightMax
        }
        
        tableView = UITableView(frame: CGRect(x: 0, y: STATUSBAR_NAVIGATIONBAR_HEIGHT + auViewLogoHeight, width: SCREEN_WIDTH, height: fHeight), style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isScrollEnabled = flag
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.register(LyLeftMenuSettingTableViewCell.self, forCellReuseIdentifier: lyAboutUsTableViewCellReuseIdentifier)
        
        
        let lbCopyRight = UILabel(frame: CGRect(x: 0, y: SCREEN_HEIGHT-auLbCopyRightHeight, width: SCREEN_WIDTH, height: auLbCopyRightHeight))
        lbCopyRight.font = auLbCopyRightFont
        lbCopyRight.textColor = .gray
        lbCopyRight.textAlignment = .center
        lbCopyRight.numberOfLines = 0
        lbCopyRight.text = "我要去学车 版权所有\nCopyright © 2013-2017 517xueche.All Rights Reserved."
        
        
        self.view.addSubview(viewLogo)
        self.view.addSubview(tableView)
        self.view.addSubview(lbCopyRight)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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



// MARK: - LyShareViewDelegate
extension LyAboutUsViewController: LyShareViewDelegate {
    func onClickButtonClose(_ aShareView: LyShareView!) {
        aShareView.hide()
    }
    
    func onShared(byQQFriend aShareView: LyShareView!) {
        aShareView.hide()
        
        LyShareManager.share(.subTypeQQFriend,
                             alertTitle: "分享到QQ好友",
                             content: shareContent,
                             images: [LyUtil.image(forImageName: "icon_517", needCache: false)!],
                             title: shareTitle,
                             url: URL(string: share_url)!,
                             viewController: self)
    }
    
    func onShared(byQQZone aShareView: LyShareView!) {
        aShareView.hide()
        
        LyShareManager.share(.subTypeQZone,
                             alertTitle: "分享到QQ空间",
                             content: shareContent,
                             images: [LyUtil.image(forImageName: "icon_517", needCache: false)!],
                             title: shareTitle,
                             url: URL(string: share_url)!,
                             viewController: self)
    }
    
    func onShared(byWeiBo aShareView: LyShareView!) {
        aShareView.hide()
        
        LyShareManager.share(.typeSinaWeibo,
                             alertTitle: "分享到新浪微博",
                             content: shareContent_sinaWeibo,
                             images: [LyUtil.image(forImageName: "icon_517", needCache: false)!],
                             title: shareTitle,
                             url: URL(string: share_url)!,
                             viewController: self)
    }
    
    func onShared(byWeChatFriend aShareView: LyShareView!) {
        aShareView.hide()
        
        LyShareManager.share(.subTypeWechatSession,
                             alertTitle: "分享到QQ好友",
                             content: shareContent,
                             images: [LyUtil.image(forImageName: "icon_517", needCache: false)!],
                             title: shareTitle,
                             url: URL(string: share_url)!,
                             viewController: self)
    }
    
    func onShared(byWeChatMoments aShareView: LyShareView!) {
        aShareView.hide()
        
        LyShareManager.share(.subTypeWechatTimeline,
                             alertTitle: "分享到QQ好友",
                             content: shareContent,
                             images: [LyUtil.image(forImageName: "icon_517", needCache: false)!],
                             title: shareTitle,
                             url: URL(string: share_url)!,
                             viewController: self)
    }
}



// MARK: - UITableViewDelegate
extension LyAboutUsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return lmstcellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.row {
        case 0:
            LyUtil.showWebViewController(.FAQ, target: self)
            break
        case 1:
            LyUtil.call(phoneNum_517)
        case 2:
            let feedback = LyFeedbackViewController()
            self.navigationController?.pushViewController(feedback, animated: true)
        case 3:
            LyUtil.open(URL(string: appStore_url))
        case 4:
            let shareView = LyShareView()
            shareView.delegate = self
            shareView.show()
        default:
            break
        }
    }
}


// MARK: - UITableViewDataSource
extension LyAboutUsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrTitle.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: LyLeftMenuSettingTableViewCell! = tableView.dequeueReusableCell(withIdentifier: lyAboutUsTableViewCellReuseIdentifier, for: indexPath) as! LyLeftMenuSettingTableViewCell
        if nil == cell {
            cell = LyLeftMenuSettingTableViewCell(style: .default, reuseIdentifier: lyAboutUsTableViewCellReuseIdentifier)
        }
        
        cell.setCellInfo(LyUtil.image(forImageName: "aboutUs_item_\(indexPath.row)", needCache: false), title: arrTitle[indexPath.row], detail: arrDetail[indexPath.row])
        
        return cell
    }
}


