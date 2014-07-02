//
//  ViewController.m
//  FirstContact
//
//  Created by Eri Tange on 2014/04/27.
//  Copyright (c) 2014年 ___FULLUSERNAME___. All rights reserved.
//

#import "ViewController.h"
#import "ContactRecord.h"
#import "ContactRecordManager.h"
#import "ContactService.h"

@interface ViewController ()<ABPeoplePickerNavigationControllerDelegate>

@end

@implementation ViewController

-(void)awakeFromNib{
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
}

- (IBAction)performAddButtonAction:(id)sender {
    
    //ABPeoplePickerNavigationControllerを初期化
    ABPeoplePickerNavigationController *controller = [[ABPeoplePickerNavigationController alloc] init];
    controller.peoplePickerDelegate =self;
    //表示するプロパティを電話番号とメールアドレスだけに限定
    controller.displayedProperties = @[@(kABPersonPhoneProperty),@(kABPersonEmailProperty)];
    
    [self presentViewController:controller animated:YES completion:nil];
}

//これはなんだろう…？
#pragma mark - ABPeoplePickerNavigationControllerDelegate
#pragma mark -

-(void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker{
    
    //キャンセルが押されたときには何もせずにABPeoplePickerNavigationControllerを閉じる
    [peoplePicker dismissViewControllerAnimated:YES completion:nil];
}

-(BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person{
    
    //連絡先のレコードを選択したときは何もせずに、処理を継続させる(プロパティを選択させる)
    return YES;
}

-(BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier{
    
    //選択されたレコード、プロパティをもとにContastRecordオブジェクトを作成
    ContactRecord *record = [[ContactRecord alloc] initWithPerson:person
                                                         property:property
                                                        identifer:identifier];
    
    //作成されたContactRecordをマネージャーに追加し保存
    ContactRecordManager *manager = [ContactRecordManager sharedManager];
    [manager.records addObject:record];
    [manager save];
    
    //表示を更新
    [self.tableView reloadData];
    
    //ABPeoplePickerNavigationControllerを閉じる
    [peoplePicker dismissViewControllerAnimated:YES completion:nil];
    
    //デフォルトの処理はしない
    return NO;
}

#pragma mark - UITableViewDataSource
#pragma mark -

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    //テーブルビューの行の数はレコードの数と同じ
    return [[[ContactRecordManager sharedManager] records] count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    //行数からContactRecordを取得
    ContactRecord *record = [[ContactRecordManager sharedManager] records][indexPath.row];
    //ContactRecordからABRecordRefを取得
    ABRecordRef person = record.person;
    
    //画像データを取得し、イメージビューに設定
    NSData *imageData = (__bridge_transfer NSData *)ABPersonCopyImageDataWithFormat(person, kABPersonImageFormatThumbnail);
    cell.imageView.image = [UIImage imageWithData:imageData];
    
    //名前を取得し、ラベルに設定
    NSString *name = (__bridge_transfer NSString *)ABRecordCopyCompositeName(person);
    cell.textLabel.text = name;
    
    //プロパティIDとmultiValueIdentiferから、プロパティの特定の値を取得し、詳細ラベルに設定
    //複数ある電話番号またはメールアドレスからひとつを取得
    ABMultiValueRef multiValue = ABRecordCopyValue(person, record.propertyID);
    CFIndex index = ABMultiValueGetIndexForIdentifier(multiValue, record.multiValueIdentifer);
    NSString *value = (__bridge_transfer NSString *)ABMultiValueCopyValueAtIndex(multiValue, index);
    CFRelease(multiValue);
    cell.detailTextLabel.text = value;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //マネージャーからindexPathで示されるレコードを削除
        ContactRecordManager *manager = [ContactRecordManager sharedManager];
        [manager.records removeObjectAtIndex:indexPath.row];
        [manager save];
        
        //テーブルビューの行も削除
        [tableView deleteRowsAtIndexPaths:@[indexPath]
                         withRowAnimation:UITableViewRowAnimationFade];
    }
}

-(void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath{
    
    //指定されたindexPathに基づいてレコードの並び順を変更
    ContactRecordManager *manager = [ContactRecordManager sharedManager];
    NSMutableArray *records = manager.records;
    
    id object = records[sourceIndexPath.row];
    [records removeObjectAtIndex:sourceIndexPath.row];
    [records insertObject:object atIndex:destinationIndexPath.row];
    [manager save];
}

#pragma mark - UITableViewDelegate
#pragma mark -

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //セルの選択を解除
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //ContactRecordを渡してサービスの処理を実行
    ContactRecord *record = [[ContactRecordManager sharedManager] records][indexPath.row];
    [ContactService contactWithRecord:record];
}

-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
    
    ContactRecord *record = [[ContactRecordManager sharedManager] records][indexPath.row];
    
    //詳細ボタンを押すときは連絡先の詳細を表示
    ABPersonViewController *controller = [[ABPersonViewController alloc] init];
    controller.displayedPerson = record.person;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
