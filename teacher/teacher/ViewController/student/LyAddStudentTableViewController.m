//
//  LyAddStudentTableViewController.m
//  teacher
//
//  Created by Junes on 16/8/17.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import "LyAddStudentTableViewController.h"
#import "LyAddStudentTableViewCell.h"

#import "LyIndicator.h"
#import "LyRemindView.h"

#import "NSString+Validate.h"

#import "LyUtil.h"


#import "LyAddStudentManuallyViewController.h"


#import <AddressBook/ABPerson.h>
#import <AddressBookUI/AddressBookUI.h>

//#import <ContactsUI/ContactsUI.h>
//#import <Contacts/Contacts.h>


@interface LyAddStudentTableViewController () <ABPeoplePickerNavigationControllerDelegate, LyAddStudentManuallyViewControllerDelegate>
{
    NSString            *curName;
    NSString            *curPhone;
}
@end

@implementation LyAddStudentTableViewController

static NSString *const lyAddStudentTableViewCellReuseIdentifier = @"lyAddStudentTableViewCellReuseIdentifier";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.title = @"添加学员";
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
    
    
    [self.tableView registerClass:[LyAddStudentTableViewCell class] forCellReuseIdentifier:lyAddStudentTableViewCellReuseIdentifier];
    [self.tableView setRowHeight:astcellHeight];
    [self.tableView setTableFooterView:[UIView new]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -LyAddStudentManuallyViewControllerDelegate
- (NSDictionary *)obtainStudentInfoByAddStudentManuallyViewController:(LyAddStudentManuallyViewController *)aAddStudentManuallyVC
{
    return @{
             asmNameKey:curName,
             asmPhoneKey:curPhone
             };
}

- (void)onAddDoneByAddStudentManuallyViewController:(LyAddStudentManuallyViewController *)aAddStudentManuallyVC
{
    [_delegate onAddDoneByAddStudentTVC:self];
}



#pragma mark -ABPeoplePickerNavigationControllerDelegate
// Called after a person has been selected by the user.
- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController*)peoplePicker didSelectPerson:(ABRecordRef)person NS_AVAILABLE_IOS(8_0)
{
    ABPersonViewController *abPersonVC = [[ABPersonViewController alloc] init];
    [abPersonVC setDisplayedPerson:person];
    [peoplePicker pushViewController:abPersonVC animated:YES];
}


// Called after a property has been selected by the user.
- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController*)peoplePicker didSelectPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier NS_AVAILABLE_IOS(8_0)
{
    CFStringRef lastNameStrRef = ABRecordCopyValue(person, kABPersonLastNameProperty);
    NSString *strLastName = (__bridge NSString *)(lastNameStrRef);
    (lastNameStrRef) ? CFRelease(lastNameStrRef) : NULL;   // 使用__bridge type 方法记得释放！
    
    CFStringRef firstNameStrRef = ABRecordCopyValue(person, kABPersonFirstNameProperty);
    NSString *strFirstName = (__bridge NSString *)(firstNameStrRef);
    (firstNameStrRef) ? CFRelease(firstNameStrRef) : NULL;  // 使用__bridge type 方法记得释放！

    
    ABMultiValueRef phones = ABRecordCopyValue(person, kABPersonPhoneProperty);
    long index = ABMultiValueGetIndexForIdentifier(phones, identifier);
    if (kABMultiValueInvalidIdentifier == index)
    {
        index = ABMultiValueGetIndexForIdentifier(phones, identifier-1);
    }
    if (kABMultiValueInvalidIdentifier == index)
    {
        index = 0;
    }
    
    CFStringRef phoneStrRef = ABMultiValueCopyValueAtIndex(phones, index);
    NSString *phoneNo = (__bridge NSString *)(phoneStrRef);
    if (phoneStrRef)
    {
        CFRelease(phoneStrRef);
    }
    
    if ([phoneNo hasPrefix:@"+"])
    {
        phoneNo = [phoneNo substringFromIndex:3];
    }
    
    phoneNo = [phoneNo stringByReplacingOccurrencesOfString:@"-" withString:@""];
    NSLog(@"%@", phoneNo);
    
    if (phoneNo && [phoneNo validatePhoneNumber])
    {
        if (!strFirstName || [strFirstName rangeOfString:@"null"].length > 0)
        {
            curName = strLastName;
        }
        else if (!strLastName || [strLastName rangeOfString:@"null"].length > 0)
        {
            curName = strFirstName;
        }
        else
        {
            curName = [[NSString alloc] initWithFormat:@"%@%@", strLastName, strFirstName];
        }
        curPhone = phoneNo;
        
        LyAddStudentManuallyViewController *addStudentManually = [[LyAddStudentManuallyViewController alloc] init];
        [addStudentManually setDelegate:self];
        [addStudentManually setMode:LyAddStudentManuallyViewControllerMode_addressBook];
        [self.navigationController pushViewController:addStudentManually animated:YES];
    }
    else
    {
        [[LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:@"请选择有效的手机号码"] show];
    }
}

// Called after the user has pressed cancel.
- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker
{
    [peoplePicker dismissViewControllerAnimated:YES completion:^{
    }];
}


// Deprecated, use predicateForSelectionOfPerson and/or -peoplePickerNavigationController:didSelectPerson: instead.
- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person NS_DEPRECATED_IOS(2_0, 8_0)
{
    return YES;
}

// Deprecated, use predicateForSelectionOfProperty and/or -peoplePickerNavigationController:didSelectPerson:property:identifier: instead.
- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier NS_DEPRECATED_IOS(2_0, 8_0)
{
    CFStringRef lastNameStrRef = ABRecordCopyValue(person, kABPersonLastNameProperty);
    NSString *strLastName = (__bridge NSString *)(lastNameStrRef);
    (lastNameStrRef) ? CFRelease(lastNameStrRef) : NULL; // 使用__bridge type 方法记得释放！
    
    CFStringRef firstNameStrRef = ABRecordCopyValue(person, kABPersonFirstNameProperty);
    NSString *strFirstName = (__bridge NSString *)(firstNameStrRef);
    (firstNameStrRef) ? CFRelease(firstNameStrRef) : NULL;
    
    ABMultiValueRef phones = ABRecordCopyValue(person, kABPersonPhoneProperty);
    long index = ABMultiValueGetIndexForIdentifier(phones, identifier);
    if (kABMultiValueInvalidIdentifier == index)
    {
        index = ABMultiValueGetIndexForIdentifier(phones, identifier-1);
    }
    if (kABMultiValueInvalidIdentifier == index)
    {
        index = 0;
    }
    
    CFStringRef phoneStrRef = ABMultiValueCopyValueAtIndex(phones, index);
    NSString *phoneNo = (__bridge NSString *)(phoneStrRef);
    if (phoneStrRef)
    {
        CFRelease(phoneStrRef);
    }
    
    if ([phoneNo hasPrefix:@"+"])
    {
        phoneNo = [phoneNo substringFromIndex:3];
    }
    
    phoneNo = [phoneNo stringByReplacingOccurrencesOfString:@"-" withString:@""];
    NSLog(@"%@", phoneNo);
    
    if (phoneNo && [phoneNo validatePhoneNumber])
    {
        if (!strFirstName || [strFirstName rangeOfString:@"null"].length > 0)
        {
            curName = strLastName;
        }
        else if (!strLastName || [strLastName rangeOfString:@"null"].length > 0)
        {
            curName = strFirstName;
        }
        else
        {
            curName = [[NSString alloc] initWithFormat:@"%@%@", strLastName, strFirstName];
        }
        curPhone = phoneNo;
        
        LyAddStudentManuallyViewController *addStudentManually = [[LyAddStudentManuallyViewController alloc] init];
        [addStudentManually setDelegate:self];
        [self.navigationController pushViewController:addStudentManually animated:YES];
        
        return NO;
    }
    else
    {
        [[LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:@"请选择有效的手机号码"] show];
        return YES;
    }
    
    
    
    return YES;
}


#pragma mark -UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if (0 == indexPath.row)
    {
        ABAuthorizationStatus status = ABAddressBookGetAuthorizationStatus();
        switch (status) {
            case kABAuthorizationStatusNotDetermined: {
                //用户未选择，用户还没有决定是否授权你的程序进行访问
                ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
                ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
                    if (error)
                    {
                        return ;
                    }
                    else if (granted)
                    {
                        NSLog(@"通讯录授权成功");
                    }
                    else
                    {
                        NSLog(@"通讯录授权失败");
                    }
                });
                CFRelease(addressBook);
                
                return;
                break;
            }
            case kABAuthorizationStatusRestricted: {
                //iOS设备上一些许可配置阻止程序与通讯录数据库进行交互
                break;
            }
            case kABAuthorizationStatusDenied: {
                //用户明确的拒绝了你的程序对通讯录的访问
                
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:alertTitleForAddressBook
                                                                               message:alertMessageForAddressBook
                                                                        preferredStyle:UIAlertControllerStyleAlert];
                [alert addAction:[UIAlertAction actionWithTitle:@"取消"
                                                          style:UIAlertActionStyleCancel
                                                        handler:nil]];
                [alert addAction:[UIAlertAction actionWithTitle:@"设置"
                                                          style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction * _Nonnull action) {
                                                            NSURL *url;
                                                            url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                                                            if ([[UIApplication sharedApplication] canOpenURL:url]) {
                                                                [LyUtil openUrl:url];
                                                            } else {
                                                                [LyUtil showAlert:LyAlertViewForAuthorityMode_addressBook vc:self];
                                                            }

                                                        }]];
                
                [self presentViewController:alert animated:YES completion:nil];
                
                return;
                
                break;
            }
            case kABAuthorizationStatusAuthorized: {
                //用户已经授权给你的程序对通讯录进行访问
                break;
            }
            default: {
                break;
            }
        }
        
        ABPeoplePickerNavigationController *abPeoplePicker = [[ABPeoplePickerNavigationController alloc] init];
        [abPeoplePicker setPeoplePickerDelegate:self];
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0f)
        {
            [abPeoplePicker setPredicateForSelectionOfPerson:[NSPredicate predicateWithValue:NO]];
        }
        [self presentViewController:abPeoplePicker animated:YES completion:nil];
    }
    else if (1 == indexPath.row)
    {
        LyAddStudentManuallyViewController *addStudentManually = [[LyAddStudentManuallyViewController alloc] init];
        [addStudentManually setDelegate:self];
        [self.navigationController pushViewController:addStudentManually animated:YES];
    }
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LyAddStudentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:lyAddStudentTableViewCellReuseIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    if (!cell)
    {
        cell = [[LyAddStudentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:lyAddStudentTableViewCellReuseIdentifier];
    }
    
    if (0 == indexPath.row)
    {
        [cell setCellInfo:[LyUtil imageForImageName:@"addStudent_addressBook" needCache:NO] title:@"手机通讯录导入"];
        
    }
    else if (1 == indexPath.row)
    {
        [cell setCellInfo:[LyUtil imageForImageName:@"addStudent_manual" needCache:NO] title:@"手动添加"];
    }
    
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
