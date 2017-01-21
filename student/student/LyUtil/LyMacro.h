//
//  LyMacro.h
//  LyStudyDrive
//
//  Created by Junes on 16/4/27.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import <UIKit/UIKit.h>

#ifndef LyMacro_h
#define LyMacro_h


//#define __Ly__HTTPS__FLAG__


//
UIKIT_EXTERN NSString *const app_boudleIdentifier;
UIKIT_EXTERN NSString *const appStore_id;
UIKIT_EXTERN NSString *const appStore_url;
UIKIT_EXTERN NSString *const host_url;


UIKIT_EXTERN NSString *const share_url;
UIKIT_EXTERN NSString *const shareTitle;
UIKIT_EXTERN NSString *const shareContent;
UIKIT_EXTERN NSString *const shareContent_sinaWeibo;
#define shareContent_exam(score)  [[NSString alloc] initWithFormat:@"我在“我要去学车”考了%ld分，这么牛逼的学车软件，还有谁！动动手指一起来吧！", score]
#define shareContent_exam_sinaWeibo(score)  [[NSString alloc] initWithFormat:@"我在“我要去学车”考了%ld分，这么牛逼的学车软件，还有谁！动动手指一起来吧！https://www.517xc.com", score]


UIKIT_EXTERN NSString *const appSchmeStudent;

//Apple Pay
UIKIT_EXTERN NSString *const appMerchantIdentifier;


//支付宝相关
UIKIT_EXTERN NSString *const alipayPartner;
UIKIT_EXTERN NSString *const alipayAppId;
UIKIT_EXTERN NSString *const alipaySeller;
UIKIT_EXTERN NSString *const alipayPrivateKey;

//qq相关
UIKIT_EXTERN NSString *const qqAppId;
UIKIT_EXTERN NSString *const qqAppKey;

//新浪微博相关
UIKIT_EXTERN NSString *const sinaWeiBoAppKey;
UIKIT_EXTERN NSString *const sinaWeiBoAppSercet;
UIKIT_EXTERN NSString *const sinaAuth_url;
UIKIT_EXTERN NSString *const cancelSinaAuth_url;

//微信相关
UIKIT_EXTERN NSString *const weChatAppId;
UIKIT_EXTERN NSString *const weChatAppSecret;

//mob相关
UIKIT_EXTERN NSString *const shareSDKAppKey;
UIKIT_EXTERN NSString *const shareSDKAppSecret;

//JPush相关
UIKIT_EXTERN NSString *const JPushAppKey;
UIKIT_EXTERN NSString *const JPushMasterSecret;
UIKIT_EXTERN NSString *const JPushChannel;
UIKIT_EXTERN NSString *const JPushRegistrationID;
UIKIT_EXTERN BOOL JPushIsProduction;

//加密
UIKIT_EXTERN NSString *const aes128key;
UIKIT_EXTERN NSString *const aes128iv;
UIKIT_EXTERN NSString *const aes256key;
UIKIT_EXTERN NSString *const aes256iv;


UIKIT_EXTERN NSString *const userId517Key;
UIKIT_EXTERN NSString *const userAccount517Key;
UIKIT_EXTERN NSString *const userPassword517Key;
UIKIT_EXTERN NSString *const userName517Key;
//UIKIT_EXTERN NSString *const userAutoLoginFlagKey;
#define userAutoLoginFlagKey                            [[NSString alloc] initWithFormat:@"userAutoLoginFlagKey%@__xy", [[NSUserDefaults standardUserDefaults] objectForKey:userId517Key]]




UIKIT_EXTERN CGFloat const avatarSizeMax;
UIKIT_EXTERN NSInteger const codeTimeOut;
UIKIT_EXTERN NSInteger const codeMaintaining;





UIKIT_EXTERN NSString *const model_admin;
UIKIT_EXTERN NSString *const model_upload;
UIKIT_EXTERN NSString *const category_index;
UIKIT_EXTERN NSString *const category_search;
UIKIT_EXTERN NSString *const category_upload;
UIKIT_EXTERN NSString *const category_driving;
UIKIT_EXTERN NSString *const category_coach;
UIKIT_EXTERN NSString *const category_school;
UIKIT_EXTERN NSString *const category_wallet;
UIKIT_EXTERN NSString *const category_theory;
UIKIT_EXTERN NSString *const category_activity;
UIKIT_EXTERN NSString *const category_userdynamic;
UIKIT_EXTERN NSString *const category_dynamic;
UIKIT_EXTERN NSString *const category_banner;

UIKIT_EXTERN NSString *const category_small;
UIKIT_EXTERN NSString *const category_big;




UIKIT_EXTERN NSString *const getListStartKey;
UIKIT_EXTERN NSString *const getListTypeKey;



UIKIT_EXTERN NSString *const nearTeacherModeKey;
UIKIT_EXTERN NSString *const nearTeacherAddressKey;


UIKIT_EXTERN NSString *const latitudeKey;
UIKIT_EXTERN NSString *const longitudeKey;

//培训价格详情


UIKIT_EXTERN NSString *const objectSecondKey;
UIKIT_EXTERN NSString *const objectThirdKey;

UIKIT_EXTERN NSString *const priceDetailIdKey;
UIKIT_EXTERN NSString *const priceDetailWeekdayKey;
UIKIT_EXTERN NSString *const priceDetailTimeBucketKey;
UIKIT_EXTERN NSString *const priceDetailPriceKey;


UIKIT_EXTERN NSString *const aboutKey;
UIKIT_EXTERN NSString *const aboutMeKey;

UIKIT_EXTERN NSString *const aboutMePraiseKey;
UIKIT_EXTERN NSString *const aboutMeTransmitKey;
UIKIT_EXTERN NSString *const aboutMeEvaluateKey;
UIKIT_EXTERN NSString *const aboutMeReplyKey;


UIKIT_EXTERN NSString *const aboutMeObjectAmIdKey;


UIKIT_EXTERN NSString *const modeKey;




UIKIT_EXTERN NSString *const sessionIdKey;

UIKIT_EXTERN NSString *const pathKey;
UIKIT_EXTERN NSString *const pngKey;

UIKIT_EXTERN NSString *const userIdKey;
UIKIT_EXTERN NSString *const accountKey;
UIKIT_EXTERN NSString *const phoneKey;
UIKIT_EXTERN NSString *const passowrdKey;
UIKIT_EXTERN NSString *const newPasswordKey;
UIKIT_EXTERN NSString *const clientModeKey;
UIKIT_EXTERN NSString *const deviceModeKey;
UIKIT_EXTERN NSString *const versionKey;
UIKIT_EXTERN NSString *const verifyStateKey;

UIKIT_EXTERN NSString *const balanceKey;
UIKIT_EXTERN NSString *const wuCoinKey;
UIKIT_EXTERN NSString *const couponCountKey;

UIKIT_EXTERN NSString *const codeKey;
UIKIT_EXTERN NSString *const lastestKey;
UIKIT_EXTERN NSString *const newestKey;
UIKIT_EXTERN NSString *const resultKey;
UIKIT_EXTERN NSString *const download_urlKey;
UIKIT_EXTERN NSString *const nickNameKey;
UIKIT_EXTERN NSString *const trueNameKey;
UIKIT_EXTERN NSString *const objectNameKey;


UIKIT_EXTERN NSString *const authKey;
UIKIT_EXTERN NSString *const trueAuthKey;
UIKIT_EXTERN NSString *const phoneNumberKey;
UIKIT_EXTERN NSString *const messageKey;


UIKIT_EXTERN NSString *const idKey;
UIKIT_EXTERN NSString *const sexKey;
UIKIT_EXTERN NSString *const birthdayKey;
UIKIT_EXTERN NSString *const avatarKey;
UIKIT_EXTERN NSString *const signatureKey;
UIKIT_EXTERN NSString *const gradeKey;
UIKIT_EXTERN NSString *const driveLicenseKey;
UIKIT_EXTERN NSString *const addressKey;

UIKIT_EXTERN NSString *const studyCostKey;


UIKIT_EXTERN NSString *const newsKey;


//驾校列表

UIKIT_EXTERN NSString *const locationKey;
UIKIT_EXTERN NSString *const landMarkKey;

UIKIT_EXTERN NSString *const priorityKey;

//驾校详情
UIKIT_EXTERN NSString *const nameKey;
UIKIT_EXTERN NSString *const scoreKey;
UIKIT_EXTERN NSString *const priceKey;
UIKIT_EXTERN NSString *const minPriceKey;
UIKIT_EXTERN NSString *const precedenceKey;

UIKIT_EXTERN NSString *const teachAllCountKey;
UIKIT_EXTERN NSString *const teachedPassedCountKey;
UIKIT_EXTERN NSString *const teachableCountKey;
UIKIT_EXTERN NSString *const evalutionCountKey;
UIKIT_EXTERN NSString *const praiseCountKey;
UIKIT_EXTERN NSString *const teachBirthdayKey;
UIKIT_EXTERN NSString *const driveBirthdayKey;
UIKIT_EXTERN NSString *const introductionKey;
UIKIT_EXTERN NSString *const trainBaseKey;
UIKIT_EXTERN NSString *const lastStudentKey;
UIKIT_EXTERN NSString *const signTimeKey;
UIKIT_EXTERN NSString *const teachAllPeriodKey;

UIKIT_EXTERN NSString *const trainBaseIdKey;


UIKIT_EXTERN NSString *const bannerUrlKey;
UIKIT_EXTERN NSString *const picCountKey;
UIKIT_EXTERN NSString *const imageUrlKey;
UIKIT_EXTERN NSString *const objectIdKey;

UIKIT_EXTERN NSString *const objectingIdKey;

UIKIT_EXTERN NSString *const objectMasterIdKey;



UIKIT_EXTERN NSString *const pickRangeKey;
UIKIT_EXTERN NSString *const hotFlagKey;
UIKIT_EXTERN NSString *const recomendFlagKey;
UIKIT_EXTERN NSString *const certificateFlagKey;
UIKIT_EXTERN NSString *const verifyStateKey;
UIKIT_EXTERN NSString *const pickFlagKey;
UIKIT_EXTERN NSString *const timeFlagKey;

UIKIT_EXTERN NSString *const attentionFlagKey;

UIKIT_EXTERN NSString *const trainAddressKey;
UIKIT_EXTERN NSString *const coachModeKey;

UIKIT_EXTERN NSString *const depositKey;

//培训课程
UIKIT_EXTERN NSString *const trainClassIdKey;
UIKIT_EXTERN NSString *const trainClassCountKey;
UIKIT_EXTERN NSString *const trainClassKey;
UIKIT_EXTERN NSString *const carNameKey;
UIKIT_EXTERN NSString *const trainClassModeKey;
UIKIT_EXTERN NSString *const trainClassLiceseTypeKey;
UIKIT_EXTERN NSString *const officialPriceKey;
UIKIT_EXTERN NSString *const whole517PriceKey;
UIKIT_EXTERN NSString *const prepay517priceKey;
UIKIT_EXTERN NSString *const prepay517depositKey;


UIKIT_EXTERN NSString *const classIdKey;
UIKIT_EXTERN NSString *const classNameKey;
UIKIT_EXTERN NSString *const classTimeKey;

UIKIT_EXTERN NSString *const timeKey;
UIKIT_EXTERN NSString *const lastTimeKey;
UIKIT_EXTERN NSString *const numKey;




UIKIT_EXTERN NSString *const evaluationKey;
UIKIT_EXTERN NSString *const masterNickNameKey;
UIKIT_EXTERN NSString *const contentKey;
UIKIT_EXTERN NSString *const masterKey;
UIKIT_EXTERN NSString *const masterIdKey;
UIKIT_EXTERN NSString *const bossKey;
UIKIT_EXTERN NSString *const masterNameKey;

UIKIT_EXTERN NSString *const consultIdKey;
UIKIT_EXTERN NSString *const evaluationIdKey;
UIKIT_EXTERN NSString *const consultCountKey;
UIKIT_EXTERN NSString *const evaluatingKey;
UIKIT_EXTERN NSString *const consultKey;
UIKIT_EXTERN NSString *const replyKey;
UIKIT_EXTERN NSString *const replyCountKey;

// message center
UIKIT_EXTERN NSString *const conMsgCountKey;
UIKIT_EXTERN NSString *const evaMsgCountKey;
UIKIT_EXTERN NSString *const conRepMsgCountKey;
UIKIT_EXTERN NSString *const evaRepMsgCountKey;


UIKIT_EXTERN NSString *const userTypeKey;
UIKIT_EXTERN NSString *const userTypeCoachKey;
UIKIT_EXTERN NSString *const userTypeSchoolKey;
UIKIT_EXTERN NSString *const userTypeGuiderKey;
UIKIT_EXTERN NSString *const userTypeStudentKey;



//培训课程
UIKIT_EXTERN NSString *const trainBaseNameKey;
UIKIT_EXTERN NSString *const coachCountKey;


//搜索
//搜索
UIKIT_EXTERN NSString *const searchProvinceKey;
UIKIT_EXTERN NSString *const searchCityKey;
UIKIT_EXTERN NSString *const searchDistrictKey;
UIKIT_EXTERN NSString *const searchAddressKey;
UIKIT_EXTERN NSString *const searchModeKey;

UIKIT_EXTERN NSString *const schoolKey;
UIKIT_EXTERN NSString *const landKey;


UIKIT_EXTERN NSString *const driveSchoolNameKey;
UIKIT_EXTERN NSString *const driveSchoolIdKey;



//驾考学堂
UIKIT_EXTERN NSString *const myDriveSchoolNameKey;
UIKIT_EXTERN NSString *const myCoachNameKey;
UIKIT_EXTERN NSString *const myGuiderNameKey;
UIKIT_EXTERN NSString *const myDriveSchoolIdKey;
UIKIT_EXTERN NSString *const myCoachIdKey;
UIKIT_EXTERN NSString *const myGuiderIdKey;

UIKIT_EXTERN NSString *const myReservationNumKey;
UIKIT_EXTERN NSString *const myStudyPregressKey;

UIKIT_EXTERN NSString *const myDriveSchoolNotificationCount;
UIKIT_EXTERN NSString *const myCoachNotificationCount;
UIKIT_EXTERN NSString *const myGuiderNotificationCount;
UIKIT_EXTERN NSString *const myReservationNotificationCount;
UIKIT_EXTERN NSString *const myStudyProgressNotificationCount;

//我的驾校
UIKIT_EXTERN NSString *const myDriveSchoolInfoKey;
UIKIT_EXTERN NSString *const myDriveSchoolTrainClassKey;
UIKIT_EXTERN NSString *const myDriveSchoolCoachKey;
UIKIT_EXTERN NSString *const myDriveSchoolTrainClassNameKey;

UIKIT_EXTERN NSString *const schoolIdKey;
UIKIT_EXTERN NSString *const coachIdKey;

UIKIT_EXTERN NSString *const indexKey;



//我的教练
UIKIT_EXTERN NSString *const priceSecondKey;
UIKIT_EXTERN NSString *const priceThirdKey;

UIKIT_EXTERN NSString *const disableTimeKey;
UIKIT_EXTERN NSString *const reservationInfoKey;

UIKIT_EXTERN NSString *const weekdaysKey;
UIKIT_EXTERN NSString *const timebucketKey;



//订单
UIKIT_EXTERN NSString *const orderIdKey;
UIKIT_EXTERN NSString *const orderTimeKey;
UIKIT_EXTERN NSString *const orderPayTimeKey;
UIKIT_EXTERN NSString *const consigneeKey;
UIKIT_EXTERN NSString *const remarkKey;
UIKIT_EXTERN NSString *const orderModeKey;
UIKIT_EXTERN NSString *const studentCountKey;
UIKIT_EXTERN NSString *const applyModeKey;
UIKIT_EXTERN NSString *const orderPriceKey;
UIKIT_EXTERN NSString *const orderPreferentialPriceKey;
UIKIT_EXTERN NSString *const paidNumKey;
UIKIT_EXTERN NSString *const couponModeKey;
UIKIT_EXTERN NSString *const orderStateKey;
UIKIT_EXTERN NSString *const orderNameKey;
UIKIT_EXTERN NSString *const orderDetailKey;


UIKIT_EXTERN NSString *const durationKey;
UIKIT_EXTERN NSString *const stampKey;

UIKIT_EXTERN NSString *const masNameKey;
UIKIT_EXTERN NSString *const evaluationLevelKey;

UIKIT_EXTERN NSString *const flagKey;



UIKIT_EXTERN NSString *const feedbackUserIdKey;


UIKIT_EXTERN NSString *const dateKey;



//报名咨询
UIKIT_EXTERN NSString *const guiderIdKey;
UIKIT_EXTERN NSString *const stuNameKey;
UIKIT_EXTERN NSString *const stuPhoneKey;


//章节练习
UIKIT_EXTERN NSString *const chapterIdKey;
UIKIT_EXTERN NSString *const chapterNameKey;
UIKIT_EXTERN NSString *const chapterNumKey;
UIKIT_EXTERN NSString *const chapterProgressKey;
UIKIT_EXTERN NSString *const questionIdKey;
UIKIT_EXTERN NSString *const questionIndexsKey;
UIKIT_EXTERN NSString *const addressIdKey;

UIKIT_EXTERN NSString *const questionContentKey;
UIKIT_EXTERN NSString *const questionAnswerKey;
UIKIT_EXTERN NSString *const questionTypeKey;
UIKIT_EXTERN NSString *const questionAnalysisKey;
UIKIT_EXTERN NSString *const questionImageUrlKey;
UIKIT_EXTERN NSString *const questionDegreeKey;
UIKIT_EXTERN NSString *const questionAllTimesKey;
UIKIT_EXTERN NSString *const questionWrongTimesKey;
UIKIT_EXTERN NSString *const questionIndexKey;
UIKIT_EXTERN NSString *const questionAllCountKey;

UIKIT_EXTERN NSString *const questionNextMode;
UIKIT_EXTERN NSString *const questionCurrentIdKey;
UIKIT_EXTERN NSString *const questionRightOrWrongKey;
UIKIT_EXTERN NSString *const curQuestionIdKey;

UIKIT_EXTERN NSString *const myAnwserKey;


UIKIT_EXTERN NSString *const subjectModeKey;
UIKIT_EXTERN NSString *const chapterAddressKey;

UIKIT_EXTERN NSString *const timeConsumeKey;
UIKIT_EXTERN NSString *const examDateKey;


UIKIT_EXTERN NSString *const subjectIdKey;
UIKIT_EXTERN NSString *const chapterIdKey_collecte;

UIKIT_EXTERN NSString *const rightDeleteFlag;


//驾考圈

//UIKIT_EXTERN NSString *const newsIdKey;
//UIKIT_EXTERN NSString *const statusMasterIdKey;
//UIKIT_EXTERN NSString *const statusTimeKey;
//UIKIT_EXTERN NSString *const statusContentKey;
//UIKIT_EXTERN NSString *const statusPicCountKey;
//UIKIT_EXTERN NSString *const statusPraiseCountKey;
//UIKIT_EXTERN NSString *const statusEvalutionCountKey;
//UIKIT_EXTERN NSString *const statusTransmitCountKey;
//UIKIT_EXTERN NSString *const statusExtrasKey;
//UIKIT_EXTERN NSString *const statusPraiseFlagKey;
UIKIT_EXTERN NSString *const newsIdKey;
UIKIT_EXTERN NSString *const newsMasterIdKey;
UIKIT_EXTERN NSString *const newsTimeKey;
UIKIT_EXTERN NSString *const newsContentKey;
UIKIT_EXTERN NSString *const newsPicCountKey;
UIKIT_EXTERN NSString *const newsPraiseCountKey;
UIKIT_EXTERN NSString *const newsEvalutionCountKey;
UIKIT_EXTERN NSString *const newsTransmitCountKey;
UIKIT_EXTERN NSString *const newsExtrasKey;
UIKIT_EXTERN NSString *const newsPraiseFlagKey;


UIKIT_EXTERN NSString *const objectnewsIdKey;

UIKIT_EXTERN NSString *const praiseInfoKey;
UIKIT_EXTERN NSString *const transmitInfoKey;
UIKIT_EXTERN NSString *const startKey;



UIKIT_EXTERN NSString *const AliPayCallback_url;
UIKIT_EXTERN NSString *const realmName_517;
//UIKIT_EXTERN NSString *const realmName_517 = @"58.215.177.233:8080";

//获取当前最低支持的应用版本号
UIKIT_EXTERN NSString *const lowestAppVersion_url;
//获取当前banner数量
UIKIT_EXTERN NSString *const activityCount_url;
//登录网址
UIKIT_EXTERN NSString *const login_url;
//注册网址
UIKIT_EXTERN NSString *const register_url;
//退出接口
UIKIT_EXTERN NSString *const logout_url;
//个人信息
UIKIT_EXTERN NSString *const userInfo_url;
//修改个人信息
UIKIT_EXTERN NSString *const modifyUserInfo_url;
//获取用户名称
UIKIT_EXTERN NSString *const getUserName_url;

//发送验证码
UIKIT_EXTERN NSString *const getAuthCode_url;
//验证验证码
UIKIT_EXTERN NSString *const checkAuchCode_url;
//修改密码
UIKIT_EXTERN NSString *const modifyPassword_url;
//重设密码
UIKIT_EXTERN NSString *const resetPassword_url;
//添加关注
UIKIT_EXTERN NSString *const addAttention_url;
//取消关注
UIKIT_EXTERN NSString *const removeAttention_url;
//获取我的关注
UIKIT_EXTERN NSString *const getMyAttention_url;
//意见反馈
UIKIT_EXTERN NSString *const feedback_url;
//扫一扫用户验证
UIKIT_EXTERN NSString *const issetUserId_url;







//搜索驾校
UIKIT_EXTERN NSString *const searchSchool_url;
//搜索教练
UIKIT_EXTERN NSString *const searchCoach_url;
//搜索指导员
UIKIT_EXTERN NSString *const searchGuider_url;


//获取驾校列表
UIKIT_EXTERN NSString *const getTeacherList_url;
//详情
UIKIT_EXTERN NSString *const getTeacherDetail_url;
//获取附近驾校
UIKIT_EXTERN NSString *const getNearTeacher_url;
//获取所有评论
UIKIT_EXTERN NSString *const evaList_url;
//评价详情
UIKIT_EXTERN NSString *const evaDetail_url;
//发表提问
UIKIT_EXTERN NSString *const ask_url;
//获取所有提问
UIKIT_EXTERN NSString *const conList_url;
//提问详情
UIKIT_EXTERN NSString *const consultDetail_url;




//msg center
UIKIT_EXTERN NSString *const msgCenter_url;
// eva msg
UIKIT_EXTERN NSString *const evaMsg_url;
// reply eva
UIKIT_EXTERN NSString *const replyEva_url;
// eva detail
//UIKIT_EXTERN NSString *const evaDetail_url;
//consult msg
UIKIT_EXTERN NSString *const conMsg_url;
//reply
UIKIT_EXTERN NSString *const replyCon_url;
//consult detail
//UIKIT_EXTERN NSString *const consultDetail_url;




//我的钱包
//UIKIT_EXTERN NSString *const myWallet_url = @"https://58.215.177.233:8080/web/xueche/Index/Admin/Wallet/getMyWallet";


//驾考学堂
UIKIT_EXTERN NSString *const driveExam_url;
//添加
UIKIT_EXTERN NSString *const addMyTeacher_url;
//更换
UIKIT_EXTERN NSString *const replaceTeacher_url;
//指导员
UIKIT_EXTERN NSString *const selfCitys_url;
//添加时获取所有
UIKIT_EXTERN NSString *const getTeacher_url;;
//我的驾校
UIKIT_EXTERN NSString *const myDriveShcool_url;
//根据驾校基地科目获取教练
UIKIT_EXTERN NSString *const getTrainCoach_url;
//我的驾校更多教练
UIKIT_EXTERN NSString *const getMoreCoach_url;
//我的驾校预约教练
UIKIT_EXTERN NSString *const reservateCoach_url;
//我的教练
UIKIT_EXTERN NSString *const myChoach_url;
//创建预约
UIKIT_EXTERN NSString *const reservate_url;
//我的指导员
UIKIT_EXTERN NSString *const myGuider_url;
//指导员计时预约
UIKIT_EXTERN NSString *const reservateGuider_ur;
//指导员计时预约
UIKIT_EXTERN NSString *const reservateGuider_url;


//报名咨询
UIKIT_EXTERN NSString *const guiderApply_url;


//创建订单
UIKIT_EXTERN NSString *const createOrder_url;
//订单中心
UIKIT_EXTERN NSString *const orderCenter_url;
//取消订单
UIKIT_EXTERN NSString *const cancelOrder_url;
//删除订单
UIKIT_EXTERN NSString *const deleteOrder_url;
//评价订单
UIKIT_EXTERN NSString *const evaluateOrder_url;
//确认订单
UIKIT_EXTERN NSString *const confirmOrder_url;
//获取订单支付状态
UIKIT_EXTERN NSString *const confirmPayState_url;
//银联获取TN订单号
UIKIT_EXTERN NSString *const getTn_url;
//银联Apple Pay获取tn
UIKIT_EXTERN NSString *const getApplePayTn_url;


//理论学习
//全真模考
UIKIT_EXTERN NSString *const examing_url;
//全真模考-科目四
UIKIT_EXTERN NSString *const examing4_url;
//考试完成
UIKIT_EXTERN NSString *const saveScore_url;
//考试纪录
UIKIT_EXTERN NSString *const examHistory_url;
//章节练习
UIKIT_EXTERN NSString *const chapterStudy_url;
//章节练习---题目
UIKIT_EXTERN NSString *const chapterExecise_url;
//章节练习--收藏
UIKIT_EXTERN NSString *const collecte_url;
//试题分析
UIKIT_EXTERN NSString *const questionAnalysis_url;
//我的错题
UIKIT_EXTERN NSString *const myMistake_url;
//查看错题
UIKIT_EXTERN NSString *const viewMyMistake_url;
//练习错题
UIKIT_EXTERN NSString *const execiseMyMistake_url;
//清空我的错题
UIKIT_EXTERN NSString *const clearMyMistake_url;
//我的题库
UIKIT_EXTERN NSString *const myLibrary_url;
//清空我的题库
UIKIT_EXTERN NSString *const clearMyLibrary_url;
//查看我的题库
UIKIT_EXTERN NSString *const viewMyLibrary_url;
//删除我的错题
UIKIT_EXTERN NSString *const decollecteQuestion_url;

//驾考圈
//发表动态
UIKIT_EXTERN NSString *const sendNews_url;
//获取我的动态
UIKIT_EXTERN NSString *const getMyNews_url;
//获取所有动态
UIKIT_EXTERN NSString *const getAllNews_url;
//点赞
UIKIT_EXTERN NSString *const praise_url;
//取消赞
UIKIT_EXTERN NSString *const depraise_url;
//评论（动态）
UIKIT_EXTERN NSString *const statusEvalute_url;
//转发（动态）
UIKIT_EXTERN NSString *const statusTransmit_url;
//动态详情
UIKIT_EXTERN NSString *const statusDetail_url;
//更多评价
UIKIT_EXTERN NSString *const statusMoreEvalution_url;
//与我相关
UIKIT_EXTERN NSString *const aboutMe_url;
//回复
UIKIT_EXTERN NSString *const communityReply_url;
//删除动态
UIKIT_EXTERN NSString *const deleteNews_url;
//用户详情
UIKIT_EXTERN NSString *const userDetail_url;





//用户协议
UIKIT_EXTERN NSString *const userProtocol_url;

//常见问题
UIKIT_EXTERN NSString *const FAQ_url;

//学车指南
//学车流程
UIKIT_EXTERN NSString *const guide_studyFlow_url;
//驾考大纲
UIKIT_EXTERN NSString *const guide_outline_url;
//择校指南
UIKIT_EXTERN NSString *const guide_selectionGuide_url;
//报名须知
UIKIT_EXTERN NSString *const guide_applyNote_url;
//体检事项
UIKIT_EXTERN NSString *const guide_physicalExam_url;
//学车费用
UIKIT_EXTERN NSString *const guide_studyFee_url;
//作弊处量
UIKIT_EXTERN NSString *const guide_cheating_url;
//残疾人学车
UIKIT_EXTERN NSString *const guide_deformedMan_url;

//自学直考
UIKIT_EXTERN NSString *const selfStudy_url;

//学车成本
UIKIT_EXTERN NSString *const studyCost_url;



#define ly_url(realmName, class, category, interface)   [[NSString alloc] initWithFormat:@"%@/%@/%@/%@", realmName, class, category, interface]


#define httpFix                                         realmName_517
//#define httpFix                                         [[NSString alloc] initWithFormat:@"%@", realmName_517]
//活动图
//https://58.215.177.233:8080/web/xueche/Upload/active/iamgename
#define activity_url(imaegName)                         ly_url( realmName_517, model_upload, category_activity, imaegName)
//获取用户头像
#define getAvatar_url(imaegName)                        ly_url( realmName_517, model_upload, category_small, imaegName)
//获取驾校banner
//https://58.215.177.233:8080/web/xueche/Upload/banner/imageName.png
#define getDriveSchoolBanner(imageName)                 ly_url( realmName_517, model_upload, category_banner, imageName)



#endif /* LyMacro_h */
