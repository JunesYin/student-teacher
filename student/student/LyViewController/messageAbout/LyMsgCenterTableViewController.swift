//
//  LyMsgCenterTableViewController.swift
//  teacher
//
//  Created by MacMini on 2016/12/30.
//  Copyright © 2016年 517xueche. All rights reserved.
//

import UIKit
import SwiftyJSON

fileprivate let lyMsgCenterTableViewCellReuseIdentifier = "lyMsgCenterTableViewCellReuseIdentifier"

@objc(LyMsgCenterTableViewController)
class LyMsgCenterTableViewController: UITableViewController, LySUtilDelegate {
    
    
    var iEvaCount = 0
    var iConCount = 0
    
    var bFlagLoad = false
    
    
    let indicator: LyIndicator? = LyIndicator(title: "")
    var viewError: UIView?
    

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
        
        if !bFlagLoad {
            self.load()
        }
    }
    
    func initSubviews() {
        self.title = "消息中心"
        self.view.backgroundColor = LyWhiteLightgrayColor
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .done, target: nil, action: nil)
        
        
        self.refreshControl = LyUtil.refreshControl(withTitle: "", target: self, action: #selector(refresh))
        
        self.tableView.register(LyNotificationTableViewCell.self, forCellReuseIdentifier: lyMsgCenterTableViewCellReuseIdentifier)
        self.tableView.tableFooterView = UIView()
    }
    
    func reloadData() {
        bFlagLoad = true
        
        removeViewError()
        
        self.tableView.reloadData()
    }
    
    func showViewError() {
        if nil == viewError {
            viewError = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: LyViewErrorHeight))
            viewError?.backgroundColor = LyWhiteLightgrayColor
            
            viewError?.addSubview(LyUtil.lbError(withMode: 0))
        }
        
        self.tableView.addSubview(viewError!)
    }
    
    func removeViewError() {
        viewError?.removeFromSuperview()
        viewError = nil
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
extension LyMsgCenterTableViewController {
    func load() {
        
        indicator?.startAnimation()
        
        let para: [String: String] = [
            userIdKey: LyCurrentUser.cur().userId,
            sessionIdKey: LyUtil.httpSessionId()
        ]
        
        
        LyHttpRequest.start(msgCenter_url,
                            body: para,
                            type: .asynPost,
                            timeOut: 0) { [unowned self] (resStr, resData, error) in
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
                                    let dicResult: Dictionary? = json[resultKey].dictionary
                                    guard nil != dicResult else {
                                        self.handleHttpFailed(true)
                                        return
                                    }
                                    
                                    let iEvaCount = dicResult?[evaMsgCountKey]?.intValue
                                    let iConCount = dicResult?[conMsgCountKey]?.intValue
                                    
                                    if let iCount = iEvaCount {
                                        self.iEvaCount = iCount
                                    }
                                    if let iCount = iConCount {
                                        self.iConCount = iCount
                                    }
                                    
                                    self.reloadData()
                                    
                                    self.indicator?.stopAnimation()
                                    self.refreshControl?.endRefreshing()
                                    
                                default:
                                    self.handleHttpFailed(true)
                                }
                                
        }
    }
}


// MARK -LySUtilDelegate
extension LyMsgCenterTableViewController {
    internal func handleHttpFailed(_ needRemind: Bool) {
        if (indicator?.isAnimating())! {
            indicator?.stopAnimation()
            refreshControl?.endRefreshing()
            
            showViewError()
        }
    }
}


// MARK: -UITableViewDelegate
extension LyMsgCenterTableViewController {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return ncellHeight
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            let evaMsg = LyEvaMsgTableViewController()
            self.iEvaCount = 0
            self.navigationController?.pushViewController(evaMsg, animated: true)
        case 1:
            let conMsg = LyConMsgTableViewController()
            self.iConCount = 0
            self.navigationController?.pushViewController(conMsg, animated: true)
        default:
            break;
        }
    }
}


// MARK: - UITableViewDataSource
extension LyMsgCenterTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 2
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: LyNotificationTableViewCell = tableView.dequeueReusableCell(withIdentifier: lyMsgCenterTableViewCellReuseIdentifier, for: indexPath) as! LyNotificationTableViewCell
        
        var iIcon: UIImage? = nil
        var sTitle: String? = nil
        var sDetail: String? = nil
        var iCount = 0
        
        switch indexPath.row {
        case 0:
            iIcon = LyUtil.image(forImageName: "msgCenter_eva", needCache: false)
            sTitle = "评价消息"
            sDetail = "有\(iEvaCount)条评价消息"
            iCount = iEvaCount
        case 1:
            iIcon = LyUtil.image(forImageName: "msgCenter_con", needCache: false)
            sTitle = "咨询消息"
            sDetail = "有\(iConCount)条咨询消息"
            iCount = iConCount
        default:
            iIcon = nil
            sTitle = ""
            sDetail = ""
            iCount = 0
        }
        
        cell.setCellInfo(iIcon, title: sTitle, detail: sDetail, count: iCount)
        
        return cell
    }
}


