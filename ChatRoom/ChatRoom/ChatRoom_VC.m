//
//  ChatRoom_VC.m
//  ChatRoom
//
//  Created by Nicolás Hechim on 25/1/17.
//  Copyright © 2017 Nicolás Hechim. All rights reserved.
//

#import "ChatRoom_VC.h"
#import "ChatData.h"

@interface ChatRoom_VC ()
{
    NSMutableArray *m_aMessages;
    CGFloat heightTableViewChat;
    CGFloat yPosicViewToolbar;
}
@end

@implementation ChatRoom_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Asigno delegate y guardo la ubicación inicial de la toolBar y la altura de la tableView del chat
    _textFieldNewMessage.delegate = self;
    heightTableViewChat = _tableViewChat.frame.size.height;
    yPosicViewToolbar = _viewToolBar.frame.origin.y;
    
    // Keyboard events
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
    // Tap Gesture Recognizer para poder quitar el teclado de la vista
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc]
                                                    initWithTarget:self
                                                    action:@selector(handleTapHideKeyboard)];
    tapGestureRecognizer.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
    //Inicializo el chat con los 4 mensajes solicitados
    [self initMessiChat];
}

- (void) didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void) initMessiChat
{
    // Creo 4 mensajes con fecha de ayer para que al escribir nuevos mensajes puedan visualizarse dos secciones: una fecha de ayer y otra de hoy.
    m_aMessages = [[NSMutableArray alloc] init];
    NSDate *ayer = [NSDate date];
    NSDateComponents *dateComponent = [[NSDateComponents alloc] init];
    [dateComponent setDay:-1];
    ayer = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponent toDate:ayer options:0];
    
    ChatData* msj1 = [[ChatData alloc] init];
    msj1.m_bIsMine = false;
    msj1.m_Date = ayer;
    msj1.m_eChatDataType = ChatData_Message;
    msj1.m_sMessage = @"Nico, ¿Querés jugar mañana en Camp Nou con Ney, Luis y yo?";
    [self printMessageAndSection:msj1];
    
    ChatData* msj2 = [[ChatData alloc] init];
    msj2.m_bIsMine = false;
    msj2.m_eChatDataType = ChatData_Image;
    msj2.m_Date = ayer;
    msj2.m_Image = [UIImage imageNamed:@"MSN.jpeg"];
    [self printMessageAndSection:msj2];
    
    ChatData* msj3 = [[ChatData alloc] init];
    msj3.m_bIsMine = true;
    msj3.m_Date = ayer;
    msj3.m_eChatDataType = ChatData_Message;
    msj3.m_sMessage = @"¡Hola crack! Obvio que sí, llevo tus botines, los compré ayer!";
    [self printMessageAndSection:msj3];
    
    ChatData* msj4 = [[ChatData alloc] init];
    msj4.m_bIsMine = true;
    msj4.m_Date = ayer;
    msj4.m_eChatDataType = ChatData_Image;
    msj4.m_Image = [UIImage imageNamed:@"botinesMessi.png"];
    [self printMessageAndSection:msj4];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Inicializo los prototipos de celdas según la que se necesite dibujar
    NSMutableArray* section = m_aMessages[indexPath.section];
    ChatData* chatData = section[indexPath.row];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"hh:mm";
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    
    switch (chatData.m_eChatDataType)
    {
        case ChatData_Message:
        {
            if (chatData.m_bIsMine)
            {
                Chat_Msg_Cell * cell_MyMessage = [tableView
                                                  dequeueReusableCellWithIdentifier:@"Chat_Msg_Cell"
                                                  forIndexPath:indexPath];
                if (cell_MyMessage == nil)
                {
                    cell_MyMessage = [[Chat_Msg_Cell alloc]
                                      initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:@"Chat_Msg_Cell"];
                }
                
                [cell_MyMessage.msj setText: chatData.m_sMessage];
                [cell_MyMessage.time setText: [dateFormatter stringFromDate:chatData.m_Date]];
                
                return cell_MyMessage;
            }
            else
            {
                Chat_MsgOthers_Cell * cell_OtherMessage = [tableView
                                                           dequeueReusableCellWithIdentifier:@"Chat_MsgOthers_Cell"
                                                           forIndexPath:indexPath];
                if (cell_OtherMessage == nil)
                {
                    cell_OtherMessage = [[Chat_MsgOthers_Cell alloc]
                                      initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:@"Chat_MsgOthers_Cell"];
                }
                
                [cell_OtherMessage.msj setText: chatData.m_sMessage];
                [cell_OtherMessage.time setText: [dateFormatter stringFromDate:chatData.m_Date]];
                
                return cell_OtherMessage;
            }
        }
            break;
        case ChatData_Image:
        {
            if (chatData.m_bIsMine)
            {
                Chat_MyImage_Cell * cell_MyImage = [tableView
                                                           dequeueReusableCellWithIdentifier:@"Chat_MyImage_Cell"
                                                           forIndexPath:indexPath];
                if (cell_MyImage == nil)
                {
                    cell_MyImage = [[Chat_MyImage_Cell alloc]
                                         initWithStyle:UITableViewCellStyleDefault
                                         reuseIdentifier:@"Chat_MyImage_Cell"];
                }
                
                [cell_MyImage.img setImage:chatData.m_Image];
                [cell_MyImage.time setText: [dateFormatter stringFromDate:chatData.m_Date]];
                
                return cell_MyImage;

            }else{
                Chat_OtherImage_Cell * cell_OtherImage = [tableView
                                                    dequeueReusableCellWithIdentifier:@"Chat_OtherImage_Cell"
                                                    forIndexPath:indexPath];
                if (cell_OtherImage == nil)
                {
                    cell_OtherImage = [[Chat_OtherImage_Cell alloc]
                                    initWithStyle:UITableViewCellStyleDefault
                                    reuseIdentifier:@"Chat_OtherImage_Cell"];
                }
                
                [cell_OtherImage.img setImage:chatData.m_Image];
                [cell_OtherImage.time setText: [dateFormatter stringFromDate:chatData.m_Date]];
                
                return cell_OtherImage;
            }
        }
            break;
        case ChatData_None:
            NSLog(@"Error_ChatRoom:tableView--> chatData with ChatData_None value");
            return nil;
        default:
            break;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20.0f;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    //Dibujo una sección con la fecha de cualquier mensaje perteneciente de dicha sección (todos los mensajes de una sección deben tener la misma fecha)
    NSMutableArray* sectionMensajes = [m_aMessages objectAtIndex:section];
    ChatData* datosMensaje = [sectionMensajes objectAtIndex:0];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd-MM-yyyy"];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 20)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, tableView.frame.size.width, 20)];
    [label setTextColor:[UIColor whiteColor]];
    [label setFont:[UIFont systemFontOfSize:12]];
    [label setText:[dateFormat stringFromDate:datosMensaje.m_Date]];
    [view addSubview:label];
    [view setBackgroundColor:[UIColor
                              colorWithRed:91/255.0
                              green:187/255.0
                              blue:123/255.0
                              alpha:1.0]];
    return view;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return m_aMessages.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSMutableArray* rows = [m_aMessages objectAtIndex:section];
    return rows.count;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray* section = m_aMessages[indexPath.section];
    ChatData* chatData = section[indexPath.row];
    
    CGFloat fontHeight;
    CGFloat cellHeight;
    if (chatData.m_eChatDataType == ChatData_Message){
        
        CGSize size = [chatData.m_sMessage
                       sizeWithAttributes:@{NSFontAttributeName:
                                                [UIFont fontWithName:@"Helvetica" size:14]}];
        
        fontHeight= ((size.width/250)*size.height) +size.height;
        
        if (fontHeight < 34)
        {
            fontHeight = 34;
        }
        cellHeight = fontHeight + 36;
        
    }else
    {
        cellHeight = 104;
    }
    
    return cellHeight;
}

- (IBAction)backToHome:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)addPicture:(id)sender
{
    //Muestro un menú de acciones para acceder a la cámara o carrete
    UIActionSheet *popup = [[UIActionSheet alloc] initWithTitle:@"Enviar foto desde" delegate:self cancelButtonTitle:@"Cancelar" destructiveButtonTitle:nil otherButtonTitles:
                            @"Cámara",
                            @"Carrete",
                            nil];
    [popup showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)popup clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //Según la opción elegida, se intentará acceder a la cámara o carrete del móvil. Si no es posible, se mostrará una alerta
    if(buttonIndex == 0)
    {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
            [self sendPhotoFromCamera];
        else
        {
            UIAlertController *alert =
            [UIAlertController alertControllerWithTitle:@"Lo sentimos"
                                                message:@"No se puede abrir la cámara"
                                         preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *ok = [UIAlertAction
                                 actionWithTitle:@"Ok"
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action)
                                 {
                                     [alert dismissViewControllerAnimated:YES completion:nil];
                                 }];
            [alert addAction:ok];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }
    else if(buttonIndex == 1)
    {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
            [self sendPhotoFromCarrete];
        else
        {
            UIAlertController *alert =
            [UIAlertController alertControllerWithTitle:@"Lo sentimos"
                                                message:@"No se puede abrir el carrete"
                                         preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *ok = [UIAlertAction
                                 actionWithTitle:@"Ok"
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action)
                                 {
                                     [alert dismissViewControllerAnimated:YES completion:nil];
                                 }];
            [alert addAction:ok];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }
}

- (void) sendPhotoFromCamera
{
    //Picker para tomar una foto desde la cámara
    UIImagePickerController *pickerView =[[UIImagePickerController alloc]init];
    pickerView.allowsEditing = YES;
    pickerView.delegate = self;
    pickerView.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentModalViewController:pickerView animated:true];
}

- (void) sendPhotoFromCarrete
{
    //Picker para seleccionar una foto desde el carrete
    UIImagePickerController *pickerView = [[UIImagePickerController alloc] init];
    pickerView.allowsEditing = YES;
    pickerView.delegate = self;
    [pickerView setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    [self presentModalViewController:pickerView animated:YES];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //Aquí se carga en pantalla la imagen que el usuario tomó desde su cámara o carrete
    NSDate *now = [NSDate date];
    
    ChatData* msj = [[ChatData alloc] init];
    msj.m_bIsMine = true;
    msj.m_eChatDataType = ChatData_Image;
    msj.m_Date = now;
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    msj.m_Image = chosenImage;
    [self printMessageAndSection:msj];
    [_tableViewChat reloadData];
    [self goToLastMessage];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)sendMessage:(id)sender
{
    //Se muestra en pantalla el mensaje tipeado por el usuario y se simula un mensaje de réplica
    if (![_textFieldNewMessage.text isEqualToString:@""])
    {
        NSDate *now = [NSDate date];
        
        ChatData* msjMine = [[ChatData alloc] init];
        msjMine.m_bIsMine = true;
        msjMine.m_Date = now;
        msjMine.m_eChatDataType = ChatData_Message;
        msjMine.m_sMessage = _textFieldNewMessage.text;
        [self printMessageAndSection:msjMine];
        
        ChatData* msjReply = [[ChatData alloc] init];
        msjReply.m_bIsMine = false;
        msjReply.m_Date = now;
        msjReply.m_eChatDataType = ChatData_Message;
        msjReply.m_sMessage = _textFieldNewMessage.text;
        [self printMessageAndSection:msjReply];
        
        [_textFieldNewMessage setText:@""];
        [_tableViewChat reloadData];
        [self goToLastMessage];
    }
}

-(void) printMessageAndSection: (ChatData*) chatData
{
    //Obtengo el día de hoy
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    bool reusarSeccion = false;
    
    //Compruebo si hay alguna sección de mensajes creada con fecha de hoy
    for(int i = 0; i < m_aMessages.count; i++)
    {
        NSMutableArray* section = [m_aMessages objectAtIndex:i];
        ChatData* data = [section objectAtIndex:0];
     
        if([[dateFormat stringFromDate:chatData.m_Date] isEqualToString: [dateFormat stringFromDate:data.m_Date]]){
            reusarSeccion = true;
            [section addObject:chatData];
        }
    }
    //Si no encontré ninguna sección creada con fecha de hoy, entonces crearé una
    if(!reusarSeccion)
    {
        NSMutableArray* newSection = [[NSMutableArray alloc] initWithObjects:chatData, nil];
        [m_aMessages addObject:newSection];
    }
}

- (void)handleTapHideKeyboard
{
    //Escondo el teclado de la vista
     [self.view endEditing:YES];
}

#pragma mark - Keyboard events
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    [UIView animateWithDuration:0.2f animations:^{
        
        CGRect frame = _viewToolBar.frame;
        frame.origin.y -= kbSize.height;
        _viewToolBar.frame = frame;
        
        frame = _tableViewChat.frame;
        frame.size.height -= kbSize.height;
        _tableViewChat.frame = frame;
        
        [self goToLastMessage];
    }];
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    [UIView animateWithDuration:0.2f animations:^{
        
        CGRect frame = _viewToolBar.frame;
        frame.origin.y = yPosicViewToolbar;
        _viewToolBar.frame = frame;
        
        frame = _tableViewChat.frame;
        frame.size.height = heightTableViewChat;
        _tableViewChat.frame = frame;
    }];
}

-(void) goToLastMessage
{
    //Desplazo hacia la posición del último mensaje de la tableViewChat
    CGPoint offset = CGPointMake(0, _tableViewChat.contentSize.height - _tableViewChat.frame.size.height);
    [_tableViewChat setContentOffset:offset animated:YES];
}
@end
