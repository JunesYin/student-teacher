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



#define __Ly__HTTPS__FLAG__


//
UIKIT_EXTERN NSString *const app_boudleIdentifier;
UIKIT_EXTERN NSString *const appStore_id;
UIKIT_EXTERN NSString *const appStore_url;
UIKIT_EXTERN NSString *const host_url;


UIKIT_EXTERN NSString *const share_url;
UIKIT_EXTERN NSString *const shareTitle;
UIKIT_EXTERN NSString *const shareContent;
UIKIT_EXTERN NSString *const shareContent_sinaWeibo;
//#define shareContent_exam(score)  [[NSString alloc] initWithFormat:@"我在“我要去学车”考了%d分，这么牛逼的学车软件，还有谁！动动手指一起来吧！", score]
//#define shareContent_exam_sinaWeibo(score)  [[NSString alloc] initWithFormat:@"我在“我要去学车”考了%d分，这么牛逼的学车软件，还有谁！动动手指一起来吧！http://www.517xc.com", score]

//支付宝相关
UIKIT_EXTERN NSString *const alipayPartner;
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

UIKIT_EXTERN NSString *const userTypeKey_tc;
UIKIT_EXTERN NSString *const userId517Key_tc;
UIKIT_EXTERN NSString *const userAccount517Key_tc;
UIKIT_EXTERN NSString *const userPassword517Key_tc;
UIKIT_EXTERN NSString *const userName517Key_tc;
UIKIT_EXTERN NSString *const userVerifyKey_tc;
//UIKIT_EXTERN NSString *const userAutoLoginFlagKey;
#define userAutoLoginFlagKey                            [[NSString alloc] initWithFormat:@"userAutoLoginFlagKey%@__tc", [[NSUserDefaults standardUserDefaults] objectForKey:userId517Key_tc]]



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


UIKIT_EXTERN NSString *const teacherCoachKey;
UIKIT_EXTERN NSString *const teacherSchoolKey;
UIKIT_EXTERN NSString *const teacherGuiderKey;


UIKIT_EXTERN NSString *const getListStartKey;
UIKIT_EXTERN NSString *const getListTypeKey;

UIKIT_EXTERN NSString *const keyKey;
UIKIT_EXTERN NSString *const valueKey;



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
UIKIT_EXTERN NSString *const jpgKey;

UIKIT_EXTERN NSString *const userIdKey;
UIKIT_EXTERN NSString *const accountKey;
UIKIT_EXTERN NSString *const phoneKey;
UIKIT_EXTERN NSString *const passowrdKey;
UIKIT_EXTERN NSString *const newPasswordKey;
UIKIT_EXTERN NSString *const clientModeKey;
UIKIT_EXTERN NSString *const deviceModeKey;
UIKIT_EXTERN NSString *const versionKey;
UIKIT_EXTERN NSString *const verifyKey;

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
UIKIT_EXTERN NSString *const fullNameKey;
UIKIT_EXTERN NSString *const objectNameKey;

UIKIT_EXTERN NSString *const avatarNameKey;


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


UIKIT_EXTERN NSString *const idKey;
UIKIT_EXTERN NSString *const sexKey;
UIKIT_EXTERN NSString *const birthdayKey;

UIKIT_EXTERN NSString *const driveBirthdayKey;
UIKIT_EXTERN NSString *const teachBirthdayKey;
UIKIT_EXTERN NSString *const addressKey;

UIKIT_EXTERN NSString *const avatarKey;
UIKIT_EXTERN NSString *const signatureKey;
UIKIT_EXTERN NSString *const gradeKey;
UIKIT_EXTERN NSString *const driveLicenseKey;


UIKIT_EXTERN NSString *const studyCostKey;


UIKIT_EXTERN NSString *const newsKey;


//驾校列表

UIKIT_EXTERN NSString *const locationKey;
UIKIT_EXTERN NSString *const landMarkKey;
UIKIT_EXTERN NSString *const landNameKey;
UIKIT_EXTERN NSString *const landMarkRecordKey;
UIKIT_EXTERN NSString *const landKey;
UIKIT_EXTERN NSString *const landMarkIdKey;

//驾校详情
UIKIT_EXTERN NSString *const nameKey;
UIKIT_EXTERN NSString *const scoreKey;
UIKIT_EXTERN NSString *const priceKey;
UIKIT_EXTERN NSString *const minPriceKey;
UIKIT_EXTERN NSString *const teachAllCountKey;
UIKIT_EXTERN NSString *const teachedPassedCountKey;
UIKIT_EXTERN NSString *const teachableCountKey;
UIKIT_EXTERN NSString *const evalutionCountKey;
UIKIT_EXTERN NSString *const praiseCountKey;
UIKIT_EXTERN NSString *const teachedAgeKey;
UIKIT_EXTERN NSString *const drivedAgeKey;
UIKIT_EXTERN NSString *const introductionKey;
UIKIT_EXTERN NSString *const trainBaseKey;
UIKIT_EXTERN NSString *const lastStudentKey;
UIKIT_EXTERN NSString *const signTimeKey;
UIKIT_EXTERN NSString *const teachAllPeriodKey;

UIKIT_EXTERN NSString *const trainBaseIdKey;


UIKIT_EXTERN NSString *const bannerUrlKey;
UIKIT_EXTERN NSString *const picCountKey;
UIKIT_EXTERN NSString *const imageKey;
UIKIT_EXTERN NSString *const imageUrlKey;
UIKIT_EXTERN NSString *const imageNameKey;
UIKIT_EXTERN NSString *const objectIdKey;

UIKIT_EXTERN NSString *const objectingIdKey;

UIKIT_EXTERN NSString *const objectMasterIdKey;



UIKIT_EXTERN NSString *const pickRangeKey;
UIKIT_EXTERN NSString *const hotFlagKey;
UIKIT_EXTERN NSString *const recomendFlagKey;
UIKIT_EXTERN NSString *const certificateFlagKey;
UIKIT_EXTERN NSString *const pickFlagKey;
UIKIT_EXTERN NSString *const timeFlagKey;

UIKIT_EXTERN NSString *const attentionFlagKey;

UIKIT_EXTERN NSString *const trainAddressKey;

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
UIKIT_EXTERN NSString *const depositKey;
UIKIT_EXTERN NSString *const trainClassTimeKey;
UIKIT_EXTERN NSString *const includeKey;
UIKIT_EXTERN NSString *const waitDayKey;
UIKIT_EXTERN NSString *const objectSecondKey;
UIKIT_EXTERN NSString *const objectThirdKey;
UIKIT_EXTERN NSString *const objectSecondCountKey;
UIKIT_EXTERN NSString *const objectThirdCountKey;
UIKIT_EXTERN NSString *const trainModeKey;
UIKIT_EXTERN NSString *const pickModeKey;


UIKIT_EXTERN NSString *const classKey;
UIKIT_EXTERN NSString *const classIdKey;
UIKIT_EXTERN NSString *const classNameKey;

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


UIKIT_EXTERN NSString *const coachModeKey;



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


UIKIT_EXTERN NSString *const schoolNameKey;
UIKIT_EXTERN NSString *const schoolIdKey;



//驾考学堂
UIKIT_EXTERN NSString *const myschoolNameKey;
UIKIT_EXTERN NSString *const myCoachNameKey;
UIKIT_EXTERN NSString *const myGuiderNameKey;
UIKIT_EXTERN NSString *const myschoolIdKey;
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
UIKIT_EXTERN NSString *const statussKey;


//订单
UIKIT_EXTERN NSString *const orderKey;
UIKIT_EXTERN NSString *const orderIdKey;
UIKIT_EXTERN NSString *const orderTimeKey;
UIKIT_EXTERN NSString *const consigneeKey;
UIKIT_EXTERN NSString *const remarkKey;
UIKIT_EXTERN NSString *const orderModeKey;
UIKIT_EXTERN NSString *const studentCountKey;
UIKIT_EXTERN NSString *const applyModeKey;
UIKIT_EXTERN NSString *const orderPriceKey;
UIKIT_EXTERN NSString *const paidNumKey;
UIKIT_EXTERN NSString *const couponModeKey;
UIKIT_EXTERN NSString *const orderStateKey;
UIKIT_EXTERN NSString *const orderNameKey;
UIKIT_EXTERN NSString *const orderDetailKey;
UIKIT_EXTERN NSString *const recipientKey;
UIKIT_EXTERN NSString *const recipientNameKey;
UIKIT_EXTERN NSString *const startDateKey;
UIKIT_EXTERN NSString *const endDateKey;



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
UIKIT_EXTERN NSString *const currentQuestionIdKey;

UIKIT_EXTERN NSString *const myAnwserKey;


UIKIT_EXTERN NSString *const subjectModeKey;
UIKIT_EXTERN NSString *const chapterAddressKey;

UIKIT_EXTERN NSString *const timeConsumeKey;
UIKIT_EXTERN NSString *const examDateKey;


UIKIT_EXTERN NSString *const subjectIdKey;
UIKIT_EXTERN NSString *const chapterIdKey_collecte;

UIKIT_EXTERN NSString *const rightDeleteFlag;


//驾考圈

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

//UIKIT_EXTERN NSString *const objectingIdKey;

UIKIT_EXTERN NSString *const praiseInfoKey;
UIKIT_EXTERN NSString *const transmitInfoKey;
UIKIT_EXTERN NSString *const startKey;




UIKIT_EXTERN NSString *const censusKey;
UIKIT_EXTERN NSString *const pickAddressKey;
UIKIT_EXTERN NSString *const trainClassNameKey;
UIKIT_EXTERN NSString *const payInfoKey;
UIKIT_EXTERN NSString *const noteKey;


UIKIT_EXTERN NSString *const orderCountKey;
UIKIT_EXTERN NSString *const curStudentCountKey;
UIKIT_EXTERN NSString *const curOrderCountKey;




UIKIT_EXTERN NSString *const districtNameKey;
UIKIT_EXTERN NSString *const districtIdKey;

//认证
UIKIT_EXTERN NSString *const coachLicenseIdKey;
UIKIT_EXTERN NSString *const driveLicenseIdKey;
UIKIT_EXTERN NSString *const identityIdKey;
UIKIT_EXTERN NSString *const businessLicenseIdKey;
//UIKIT_EXTERN NSString *const fullNameKey;




UIKIT_EXTERN NSString *const AliPayCallback_url;
UIKIT_EXTERN NSString *const realmName_517;
//UIKIT_EXTERN NSString *const realmName_517 = @"58.215.177.233:8080";

//获取当前最低支持的应用版本号
UIKIT_EXTERN NSString *const lowestAppVersion_url;
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
UIKIT_EXTERN NSString *const attente_url;
//取消关注
UIKIT_EXTERN NSString *const removeAttention_url;
//获取我的关注
UIKIT_EXTERN NSString *const getMyAttention_url;
//意见反馈
UIKIT_EXTERN NSString *const feedback_url;
//扫一扫用户验证
UIKIT_EXTERN NSString *const issetUserId_url;



//msg center
UIKIT_EXTERN NSString *const msgCenter_url;
// eva msg
UIKIT_EXTERN NSString *const evaMsg_url;
// reply eva
UIKIT_EXTERN NSString *const replyEva_url;
// eva detail
UIKIT_EXTERN NSString *const evaDetail_url;
//consult msg
UIKIT_EXTERN NSString *const conMsg_url;
//reply
UIKIT_EXTERN NSString *const replyCon_url;
//consult detail
UIKIT_EXTERN NSString *const consultDetail_url;



//上传认征资料
UIKIT_EXTERN NSString *const uploadCertification_url;
//获取所选城市所有基地
UIKIT_EXTERN NSString *const getAllTrainBase_url;


#pragma mark -学员
//获取学员
UIKIT_EXTERN NSString *const getStudent_url;
//添加学员
UIKIT_EXTERN NSString *const addStudent_url;
//修改学员信息
UIKIT_EXTERN NSString *const modifyStudent_url;
//删除学员
UIKIT_EXTERN NSString *const deleteStudent_url;




#pragma mark -发布
//添加培训课程
UIKIT_EXTERN NSString *const addTrainClass_url;
//删除培训订程
UIKIT_EXTERN NSString *const deleteTrainClass_url;
//修改计时培训
UIKIT_EXTERN NSString *const updateTimeTeachFlag_url;
//添加简介（修改简介）
UIKIT_EXTERN NSString *const updateSynopsis_url;
//添加教学环境（修改，删除）
//添加教学环境
UIKIT_EXTERN NSString *const updateTeachEnvironmnet_url;
//删除教学环境
UIKIT_EXTERN NSString *const deleteTeachEnvironment_url;
//获取培训课程
UIKIT_EXTERN NSString *const getTrainClass_url;
//获取简介
UIKIT_EXTERN NSString *const getSynopsis_url;
//获取教学图片
UIKIT_EXTERN NSString *const getTeachEnvironment_url;
//获取发布信息
UIKIT_EXTERN NSString *const getPublishInfo_url;
//修改学车成本
//UIKIT_EXTERN NSString *const updateCost_url;
//修改接送范围
UIKIT_EXTERN NSString *const updatePickRange_url;



#pragma mark -教学管理
//获取基地
UIKIT_EXTERN NSString *const getTrainBase_url;

//教学管理主界面
UIKIT_EXTERN NSString *const teachManage_url;
//教练管理
UIKIT_EXTERN NSString *const coachManage_url;
//添加教练
UIKIT_EXTERN NSString *const addCoach_url;
//教练详情
UIKIT_EXTERN NSString *const coachDetail_url;
//修改老师当前驾照
UIKIT_EXTERN NSString *const modifyTeacherLicense_url;
//订时预约
UIKIT_EXTERN NSString *const timeTeachManage_url;
//根据驾照类型获取价格详情
UIKIT_EXTERN NSString *const priceDetailByLicense_url;
//添加价格详情
UIKIT_EXTERN NSString *const addPriceDetail_url;
//修改价格详情
UIKIT_EXTERN NSString *const modifyPriceDetail_url;
//删除价格详情
UIKIT_EXTERN NSString *const deletePriceDetail_url;
//修改教练基地
UIKIT_EXTERN NSString *const modifyCoachTrainBase_url;
//删除教练
UIKIT_EXTERN NSString *const deleteCoach_url;
//基地管理
UIKIT_EXTERN NSString *const trainBaseManage_url;
//添加基地
UIKIT_EXTERN NSString *const addTrainBase_url NS_DEPRECATED_IOS(2_0, 8_0, "Please use operateTrainBase_url") NS_EXTENSION_UNAVAILABLE_IOS("operateTrainBase_url");
//删除基地
UIKIT_EXTERN NSString *const deleteTrainBase_url NS_DEPRECATED_IOS(2_0, 8_0, "Please use operateTrainBase_url") NS_EXTENSION_UNAVAILABLE_IOS("operateTrainBase_url");
//操作基地
UIKIT_EXTERN NSString *const operateTrainBase_url;
//基地详情
UIKIT_EXTERN NSString *const trainBaseDetail_url;
//地标管理
UIKIT_EXTERN NSString *const landMarkManage_url;
//获取所有地标
UIKIT_EXTERN NSString *const getDistrictLandMark_url;
//添加地标
UIKIT_EXTERN NSString *const addLandMark_url NS_DEPRECATED_IOS(2_0, 8_0, "Please use operateLandMark_url") NS_EXTENSION_UNAVAILABLE_IOS("operateLandMark_url");
//删除地标
UIKIT_EXTERN NSString *const deleteLandMark_url NS_DEPRECATED_IOS(2_0, 8_0, "Please use operateLandMark_url") NS_EXTENSION_UNAVAILABLE_IOS("operateLandMark_url");
//操作地标
UIKIT_EXTERN NSString *const operateLandMark_url;


//订单中心
//订单中心
UIKIT_EXTERN NSString *const orderCenter_url;
//分配订单
UIKIT_EXTERN NSString *const orderDispatch_url;
//当前可用教练-分配订单用
UIKIT_EXTERN NSString *const usefulCoach_url;




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
UIKIT_EXTERN NSString *const getEvalution_url;
//获取所有提问
UIKIT_EXTERN NSString *const getConsult_url;
//发表提问
UIKIT_EXTERN NSString *const sendConsult_url;






//我的钱包


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

//报名咨询
UIKIT_EXTERN NSString *const guiderApply_url;


//创建订单
UIKIT_EXTERN NSString *const createOrder_url;
//订单中心//学员端用
//UIKIT_EXTERN NSString *const orderCenter_url;
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


#define ly_url(realmName, class, category, interface)   [[NSString alloc] initWithFormat:@"%@/%@/%@/%@", realmName, class, category, interface]


//#define httpFix                                         [[NSString alloc] initWithFormat:@"%@", realmName_517]
#define httpFix                                         realmName_517
//活动图
//http://58.215.177.233:8080/web/xueche/Upload/active/iamgename
#define activity_url(imaegName)                         ly_url( realmName_517, model_upload, category_activity, imaegName)
//获取用户头像
#define getAvatar_url(userId)                           ly_url( realmName_517, model_upload, category_small, userId)
//获取驾校banner
//http://58.215.177.233:8080/web/xueche/Upload/banner/imageName.png
#define getDriveSchoolBanner(imageName)                 ly_url( realmName_517, model_upload, category_banner, imageName)



/*
 //Admin/Index/index(模块/控制器/方法)
 
 
 //活动图
 //http://58.215.177.233:8080/Upload/active/iamgename
 #define activity_url(imaegName)                         ly_url( realmName_517, model_upload, category_activity, imaegName)
 
 //获取当前最低支持的应用版本号
 //http://58.215.177.233:8080/Admin/index/version
 #define lowestAppVersion_url                            ly_url( realmName_517, model_admin, category_index, @"version")
 //登录网址
 //http://58.215.177.233:8080/Admin/index/check
 #define login_url                                       ly_url( realmName_517, model_admin, category_index, @"check")
 //注册网址
 //http://58.215.177.233:8080/Admin/index/adduser
 #define register_url                                    ly_url( realmName_517, model_admin,  category_index, @"adduser")
 //退出接口
 //http://58.215.177.233:8080/Admin/index/logout
 #define logout_url                                      ly_url( realmName_517, model_admin, category_index, @"logout")
 //个人信息
 //http://58.215.177.233:8080/Admin/index/userinfo
 #define userInfo_url                                    ly_url( realmName_517, model_admin, category_index, @"userinfo")
 //修改个人信息
 //http://58.215.177.233:8080/Admin/index/updateuinfo
 #define modifyUserInfo_url                              ly_url( realmName_517, model_admin, category_index, @"updateuinfo")
 
 //获取用户头像
 //http://58.215.177.233:8080/Upload/small/userid.png
 #define getAvatar_url(userId)                           ly_url( realmName_517, model_upload, category_small, userId)
 
 //获取用户名称
 //http://58.215.177.233:8080/admin/index/getUserName
 #define getUserName_url                                ly_url( realmName_517, model_admin, category_index, @"getUserName")
 
 
 
 
 
 //发送验证码
 //http://58.215.177.233:8080/Admin/index/sends
 #define getAuthCode_url                                 ly_url( realmName_517, model_admin, category_index, @"sends")
 
 
 //验证验证码
 //http://58.215.177.233:8080/Admin/index/verification
 #define checkAuchCode_url                               ly_url( realmName_517, model_admin, category_index, @"verification")
 
 
 //修改密码
 //http://58.215.177.233:8080/Admin/index/passupdate
 #define modifyPassword_url                              ly_url( realmName_517, model_admin, category_index,  @"passupdate")
 
 //重设密码
 //http://58.215.177.233:8080/Admin/index/passreset
 #define resetPassword_url                               ly_url( realmName_517, model_admin, category_index, @"passreset")
 
 
 
 
 
 //搜索驾校
 //http://58.215.177.233:8080/admin/search/search
 #define searchSchool_url                                ly_url( realmName_517, model_admin, category_search, @"search")
 //搜索教练
 //http://58.215.177.233:8080/admin/search/searchCoach
 #define searchCoach_url                                 ly_url( realmName_517, model_admin, category_search, @"searchCoach")
 //搜索指导员
 //http://58.215.177.233:8080/admin/search/searchGuider
 #define searchGuider_url                                ly_url( realmName_517, model_admin, category_search, @"searchGuider")
 
 
 
 //获取驾校列表
 //http://58.215.177.233:8080/Admin/coach/getpublicList
 #define getTeacherList_url                              ly_url( realmName_517, model_admin, category_coach, @"getpublicList")
 
 //详情
 //http://58.215.177.233:8080/Admin/coach/getTeacherDetail
 #define getTeacherDetail_url                            ly_url( realmName_517, model_admin, category_coach, @"getTeacherDetail")
 
 //获取驾校banner
 //http://58.215.177.233:8080/Upload/banner/imageName.png
 #define getDriveSchoolBanner(imageName)                 ly_url( realmName_517, model_upload, category_banner, imageName)
 
 //获取附近驾校
 //http://58.215.177.233:8080/admin/coach/getCoachadd
 #define getNearTeacher_url                              ly_url ( realmName_517, model_admin, category_coach, @"getCoachadd")
 
 
 
 
 
 
 //获取所有评论
 //http://58.215.177.233:8080/Admin/coach/getAllList
 #define getEvalution_url                                ly_url( realmName_517, model_admin, category_coach, @"getAllList")
 
 //获取所有提问
 ////http://58.215.177.233:8080/web/xueche/Admin/coach/getAllconList
 #define getConsult_url                                  ly_url ( realmName_517, model_admin, category_coach, @"getAllconList")
 
 //发表提问
 //http://58.215.177.233:8080/Admin/coach/addconsult
 #define sendConsult_url                                 ly_url( realmName_517, model_admin, category_coach, @"addconsult")
 
 
 //添加关注
 //http://58.215.177.233:8080/admin/index/addmycon
 #define attente_url                                ly_url( realmName_517, model_admin, category_index, @"addmycon")
 //取消
 //http://58.215.177.233:8080/admin/index/removemycon
 #define removeAttention_url                                ly_url( realmName_517, model_admin, category_index, @"removemycon")
 //获取我的关注
 //http://58.215.177.233:8080/admin/index/myconcern
 #define getMyAttention_url                              ly_url( realmName_517, model_admin, category_index, @"myconcern")
 
 
 //用户详情
 //http://127.0.0.1:8080/web/xueche/Admin/Dynamic/userDetails
 #define userDetail_url                                  ly_url( realmName_517, model_admin, category_dynamic, @"userDetails")
 
 
 
 
 //我的钱包
 //http://58.215.177.233:8080/index.php/Admin/Wallet/getMyWallet
 #define myWallet_url                                    ly_url( realmName_517, model_admin, category_wallet, @"getMyWallet")
 
 
 
 //驾考学堂
 //http://58.215.177.233:8080/Admin/driving/dirsch
 #define driveExam_url                                   ly_url( realmName_517, model_admin, category_driving, @"dirsch")
 //添加
 //http://58.215.177.233:8080/Admin/driving/addMyTeacher
 #define addMyTeacher_url                                ly_url( realmName_517, model_admin, category_driving, @"addMyTeacher")
 //更换
 //http://58.215.177.233:8080/Admin/driving/updateTeacher
 #define replaceTeacher_url                              ly_url( realmName_517, model_admin, category_driving, @"updateTeacher")
 //指导员
 //http://127.0.0.1:8080/web/xueche/admin/driving/selfCity
 #define selfCitys_url                                   ly_url( realmName_517, model_admin, category_driving, @"selfCity")
 //添加时获取所有
 //http://58.215.177.233:8080/admin/Driving/returnAllTeacher
 #define getTeacher_url                                  ly_url( realmName_517, model_admin, category_driving, @"returnAllTeacher")
 //我的驾校
 //http://58.215.177.233:8080/Admin/driving/mydrisch
 #define myDriveShcool_url                               ly_url( realmName_517, model_admin, category_driving, @"mydrisch")
 //根据驾校基地科目获取教练
 //http://58.215.177.233:8080/Admin/driving/getTrainCoach
 #define getTrainCoach_url                               ly_url( realmName_517, model_admin, category_driving, @"getTrainCoach")
 //我的驾校更多教练
 //http://58.215.177.233:8080/Admin/driving/getMoreCoach
 #define getMoreCoach_url                                ly_url( realmName_517, model_admin, category_driving, @"getMoreCoach")
 //我的驾校预约教练
 //http://58.215.177.233:8080/Admin/driving/reserCoach
 #define reservateCoach_url                              ly_url( realmName_517, model_admin, category_driving, @"reserCoach")
 
 
 //我的教练
 //http://58.215.177.233:8080/Admin/driving/getCoachInfo
 #define myChoach_url                                    ly_url( realmName_517, model_admin, category_driving, @"getCoachInfo")
 
 //创建预约
 //http://58.215.177.233:8080/Admin/driving/addmyreser
 #define reservate_url                                   ly_url( realmName_517, model_admin, category_driving, @"addmyreser")
 
 
 //我的指导员
 //http://58.215.177.233:8080/Admin/driving/getGuiderinfo
 #define myGuider_url                                    ly_url( realmName_517, model_admin, category_driving, @"getGuiderinfo")
 
 
 
 //报名咨询
 //http://58.215.177.233:8080/Admin/driving/guiderList
 #define guiderApply_url                                 ly_url( realmName_517, model_admin, category_driving, @"guiderList")
 
 
 
 
 
 
 //创建订单
 //http://58.215.177.233:8080/admin/Driving/mylist
 #define createOrder_url                                 ly_url( realmName_517, model_admin, category_driving, @"mylist")
 //订单中心
 //http://58.215.177.233:8080/admin/Driving/listcenter
 #define orderCenter_url                                 ly_url( realmName_517, model_admin, category_driving, @"listcenter")
 //取消订单
 //http://58.215.177.233:8080/admin/Driving/cancellist
 #define cancelOrder_url                                 ly_url( realmName_517, model_admin, category_driving, @"cancellist")
 //删除订单
 //http://58.215.177.233:8080/admin/Driving/dellist
 #define deleteOrder_url                                 ly_url( realmName_517, model_admin, category_driving, @"dellist")
 //评价订单
 //http://58.215.177.233:8080/adminDriving/evaluatlist
 #define evaluateOrder_url                               ly_url( realmName_517, model_admin, category_driving, @"evaluatlist")
 //确认订单
 //http://58.215.177.233:8080/adminDriving/confirmlist
 #define confirmOrder_url                                ly_url( realmName_517, model_admin, category_driving, @"confirmlist")
 
 //获取订单支付状态
 //http://58.215.177.233:8080/adminDriving/returnOrderState
 #define confirmPayState_url                             ly_url( realmName_517, model_admin, category_driving, @"returnOrderState")
 
 
 
 //意见反馈
 //http://58.215.177.233:8080/admin/index/feedback
 #define feedback_url                                    ly_url( realmName_517, model_admin, category_index, @"feedback")
 
 
 
 
 //理论学习
 //全真模考
 //http://58.215.177.233:8080/admin/theory/truetheory
 #define examing_url                                     ly_url( realmName_517, model_admin, category_theory, @"truetheory")
 //全真模考-科目四
 //http://58.215.177.233:8080/admin/theory/truetheory4
 #define examing4_url                                     ly_url( realmName_517, model_admin, category_theory, @"truetheory4")
 //考试完成
 //http://58.215.177.233:8080/admin/theory/savescore
 #define saveScore_url                                   ly_url( realmName_517, model_admin, category_theory, @"savescore")
 //考试纪录
 //http://58.215.177.233:8080/Admin/Theory/returnscore
 #define examHistory_url                                 ly_url( realmName_517, model_admin, category_theory, @"returnscore")
 
 //章节练习
 //http://127.0.0.1/web/xueche/admin/theory/zjtestnum1
 #define chapterStudy_url                                ly_url( realmName_517, model_admin, category_theory, @"zjtestnum1")
 //章节练习---题目
 //http://58.215.177.233:8080/admin/theory/chapter
 #define chapterExecise_url                              ly_url( realmName_517, model_admin, category_theory, @"chapter")
 //章节练习--收藏
 //http://58.215.177.233:8080/admin/theory/addMytheory
 #define collecte_url                                    ly_url( realmName_517, model_admin, category_theory, @"addMytheory")
 
 //试题分析
 //http://58.215.177.233:8080/admin/theory/getAnalysis
 #define questionAnalysis_url                            ly_url(realmName_517, model_admin, category_theory, @"getAnalysis")
 
 //我的错题
 //http://58.215.177.233:8080/admin/Theory/ctestnum1
 #define myMistake_url                                   ly_url( realmName_517, model_admin, category_theory, @"ctestnum1")
 //查看错题
 //http://58.215.177.233:8080/admin/Theory/viewMyerror
 #define viewMyMistake_url                               ly_url( realmName_517, model_admin, category_theory, @"viewMyerror")
 //练习错题
 //http://58.215.177.233:8080/admin/Theory/myerrorTest
 #define execiseMyMistake_url                            ly_url( realmName_517, model_admin, category_theory, @"myerrorTest")
 //清空我的错题
 //http://58.215.177.233:8080/admin/Theory/trunMyerrorTheory
 #define clearMyMistake_url                              ly_url( realmName_517, model_admin, category_theory, @"trunMyerrorTheory")
 
 //我的题库
 //http://58.215.177.233:8080/admin/Theory/Mytheory
 #define myLibrary_url                                   ly_url( realmName_517, model_admin, category_theory, @"Mytheory")
 //清空我的题库
 //http://58.215.177.233:8080/admin/Theory/trunMyBank
 #define clearMyLibrary_url                              ly_url( realmName_517, model_admin, category_theory, @"trunMyBank")
 //查看我的题库
 //http://58.215.177.233:8080/admin/Theory/MytheoryTest
 #define viewMyLibrary_url                               ly_url( realmName_517, model_admin, category_theory, @"MytheoryTest")
 //删除我的错题
 //http://58.215.177.233:8080/admin/Theory/delMyBank
 #define decollecteQuestion_url                          ly_url( realmName_517, model_admin, category_theory, @"delMyBank")
 
 
 //驾考圈
 //发表动态
 //http://58.215.177.233:8080/admin/Dynamic/sendDynamic
 #define sendNews_url                                    ly_url( realmName_517, model_admin, category_dynamic, @"sendDynamic")
 //获取我的动态
 // http://58.215.177.233:8080/web/xueche/admin/getMyDynamic
 #define getMyNews_url                                   ly_url( realmName_517, model_admin, category_dynamic, @"getMyDynamic")
 
 //获取所有动态
 //http://58.215.177.233:8080/admin/dynamic/getAllDynamic
 #define getAllNews_url                                  ly_url( realmName_517, model_admin, category_dynamic, @"getAllDynamic")
 //点赞
 //http://58.215.177.233:8080/admin/dynamic/thumb
 #define praise_url                                      ly_url( realmName_517, model_admin, category_dynamic, @"thumb")
 //取消赞
 ////http://58.215.177.233:8080/web/xueche/admin/dynamic/cancelthumb
 #define depraise_url                                    ly_url( realmName_517, model_admin, category_dynamic, @"cancelthumb")
 //评论（动态）
 //http://58.215.177.233:8080/admin/Dynamic/evaluate
 #define statusEvalute_url                               ly_url( realmName_517, model_admin, category_dynamic, @"evaluate")
 //转发（动态）
 //http://58.215.177.233:8080/admin/Dynamic/forwDynamic
 #define statusTransmit_url                              ly_url( realmName_517, model_admin, category_dynamic, @"forwDynamic")
 //动态详情
 //http://58.215.177.233:8080/admin/Dynamic/getNewsDetail
 #define statusDetail_url                                ly_url( realmName_517, model_admin, category_dynamic, @"getNewsDetail")
 //更多评价
 ////http://58.215.177.233:8080/web/xueche/admin/Dynamic/moreEvaluation
 #define statusMoreEvalution_url                         ly_url( realmName_517, model_admin, category_dynamic, @"moreEvaluation")
 
 //与我相关
 //http://58.215.177.233:8080/admin/Dynamic/aboutMe
 #define aboutMe_url                                     ly_url( realmName_517, model_admin, category_dynamic, @"aboutMe")
 //回复
 //http://58.215.177.233:8080/admin/Dynamic/returnEvaluate
 #define communityReply_url                              ly_url( realmName_517, model_admin, category_dynamic, @"returnEvaluate")
 //删除动态
 //http://58.215.177.233:8080/admin/Dynamic/delDynamic
 #define deleteNews_url                                  ly_url( realmName_517, model_admin, category_dynamic, @"delDynamic")
 
 
 
 
 //扫一扫用户验证
 //http://58.215.177.233:8080/admin/Index/userisset
 #define issetUserId_url                                 ly_url( realmName_517, model_admin, category_index, @"userisset")
 */







#endif /* LyMacro_h */
