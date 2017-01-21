//
//  LySUtil.swift
//  student
//
//  Created by MacMini on 2016/12/30.
//  Copyright © 2016年 517xueche. All rights reserved.
//

import Foundation
import UIKit

import SwiftyJSON



let Ly517ThemeColor = UIColor(red: 255/255.0, green: 90/255.0, blue: 0/255.0, alpha: 1)
let LyWhiteLightgrayColor = UIColor(red: 239/255.0, green: 239/255.0, blue: 245/255.0, alpha: 1)
let LyBlackColor = UIColor(red: 50/255.0, green: 50/255.0, blue: 50/255.0, alpha: 1)


let SCREEN_BOUNDS = UIScreen.main.bounds
let SCREEN_WIDTH = UIScreen.main.bounds.size.width
let SCREEN_HEIGHT = UIScreen.main.bounds.size.height
let APPLICATION_HEIGHT = SCREEN_HEIGHT - STATUSBAR_NAVIGATIONBAR_HEIGHT

let STATUSBAR_HEIGHT: CGFloat = 20.0
let NAVIGATIONBAR_HEIGHT: CGFloat = 44.0
let STATUSBAR_NAVIGATIONBAR_HEIGHT: CGFloat = 64.0


// MARK: - LySFont(size)
func LySFont(_ size: CGFloat) -> UIFont {
    return UIFont.systemFont(ofSize: size)
}


// MARK: - LySPrint(size)
func LySPrint(_ items: Any..., separator: String = " ", terminator: String = "\n") {
    #if SDEBUG
        print(items, separator: separator, terminator: terminator)
    #endif
}


// MARK: - LySLocalize(key, comment)
func LySLocalize(_ key: String, _ comment: String? = nil) -> String {
    if let comment = comment {
        return NSLocalizedString(key, comment: comment)
    } else {
        return NSLocalizedString(key, comment: key)
    }
}




// MARK: - LySUtilDelegate
protocol LySUtilDelegate {
    func handleHttpFailed(_ needRemind: Bool)
}


func analysisHttpResult(_ resData: Data, delegate: LySUtilDelegate) -> JSON! {
    let json: JSON = JSON(data: resData)
    guard Type.dictionary == json.type else {
        return nil
    }
    
    let iCode: Int? = json[codeKey].int
    guard nil != iCode else {
        return nil
    }
    
    guard codeTimeOut != iCode! else {
        delegate.handleHttpFailed(false)
        LyUtil.sessionTimeOut()
        return nil
    }
    
    guard codeMaintaining != iCode! else {
        delegate.handleHttpFailed(false)
        LyUtil.serverMaintaining()
        return nil
    }
    
    return json
}


func analysisHttpResult(_ resStr: String, delegate: LySUtilDelegate) -> JSON! {
    let json: JSON = JSON(parseJSON: resStr)
    guard Type.dictionary == json.type else {
        return nil
    }
    
    let iCode: Int? = json[codeKey].int
    guard nil != iCode else {
        return nil
    }
    
    guard codeTimeOut != iCode! else {
        delegate.handleHttpFailed(false)
        LyUtil.sessionTimeOut()
        return nil
    }
    
    guard codeMaintaining != iCode! else {
        delegate.handleHttpFailed(false)
        LyUtil.serverMaintaining()
        return nil
    }
    
    return json
}
