//
//  ChatRoom_VC.h
//  ChatRoom
//
//  Created by Nicolás Hechim on 25/1/17.
//  Copyright © 2017 Nicolás Hechim. All rights reserved.
//

#import "ViewController.h"
#import "Chat_Msg_Cell.h"
#import "Chat_MsgOthers_Cell.h"
#import "Chat_MyImage_Cell.h"
#import "Chat_OtherImage_Cell.h"

@interface ChatRoom_VC : ViewController <UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableViewChat;
@property (strong, nonatomic) IBOutlet UIView *viewToolBar;
- (IBAction)backToHome:(id)sender;
- (IBAction)addPicture:(id)sender;
- (IBAction)sendMessage:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *textFieldNewMessage;
@end
