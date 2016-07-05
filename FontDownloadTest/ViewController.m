//
//  ViewController.m
//  FontDownloadTest
//
//  Created by EdenLi on 2016/6/30.
//  Copyright © 2016年 Darktt. All rights reserved.
//

#import "ViewController.h"

#import "DTFileController.h"
#import "DTDownloader.h"

@import CoreText;

@interface ViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSArray<NSString *> *fontURLs;

- (IBAction)downloadFonts:(id)sender;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self.tableView setDataSource:self];
    [self.tableView setDelegate:self];
    
    self.fontURLs = @[@"https://dl.dropboxusercontent.com/u/77217798/UbuntuFonts/Ubuntu-R.ttf",
                      @"https://dl.dropboxusercontent.com/u/77217798/UbuntuFonts/Ubuntu-C.ttf",
                      @"https://dl.dropboxusercontent.com/u/77217798/UbuntuFonts/Ubuntu-L.ttf",
                      @"https://dl.dropboxusercontent.com/u/77217798/Demo/Astar.ttf"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions

- (void)downloadFonts:(id)sender
{
    NSInteger __block index = 0;
    NSString *fontURL = self.fontURLs[index];
    NSURL *URL = [NSURL URLWithString:fontURL];
    
    NSString *__block fileName = URL.lastPathComponent;
    UIAlertController *__block alertController = nil;
    
    DTDownloadProgressHandler progressHandler = ^(DTDownloader *downloader, float precenage) {
        
        NSString *message = [NSString stringWithFormat:@"Downloading... (%.2f%%)", precenage * 100.0f];
        
        [alertController setMessage:message];
    };
    
    DTDownloadCompletionHandler completionHandler = ^(DTDownloader *downloader, NSURL *location, NSError *error) {
        
        DTFileController *fileController = [DTFileController mainController];
        NSString *savePath = [fileController cachesPathWithFileName:fileName];
        
        if ([fileController fileExistAtPath:savePath]) {
            
            [self unregisterFontWithPath:savePath];
            [fileController removeFileAtPath:savePath];
        }
        
        [fileController copyFileAtPath:location.path toPath:savePath];
        [self registerFontWithPath:savePath];
        
        index += 1;
        if (index == self.fontURLs.count) {
            
            [alertController dismissViewControllerAnimated:YES completion:nil];
            [self.tableView reloadData];
            
            return;
        }
        
        NSString *fontURL = self.fontURLs[index];
        NSURL *URL = [NSURL URLWithString:fontURL];
        
        [downloader startNextWithURL:URL];
        
        fileName = URL.lastPathComponent;
        [alertController setTitle:fileName];
        [alertController setMessage:@"Downloading... (0.0%)"];
    };
    
    DTDownloader *downloader = [DTDownloader downloaderWithURL:URL];
    [downloader setProgressHandler:progressHandler];
    [downloader setCompletionHandler:completionHandler];
    [downloader startDownload];
    
    void (^cancelActionHandler) (UIAlertAction *) = ^(UIAlertAction * _Nonnull action) {
        [downloader cancel];
    };
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:cancelActionHandler];
    
    alertController = [UIAlertController alertControllerWithTitle:fileName message:@"Downloading... (0.0%)" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:cancelAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - Private Methods

- (void)registerFontWithPath:(NSString *)path
{
    NSData *fontData = [NSData dataWithContentsOfFile:path options:NSDataReadingUncached error:NULL];
    
    CGDataProviderRef provider = CGDataProviderCreateWithCFData((__bridge CFDataRef)fontData);
    CGFontRef font = CGFontCreateWithDataProvider(provider);
    
    CFErrorRef error;
    if (!CTFontManagerRegisterGraphicsFont(font, &error)) {
        CFStringRef errorDescription = CFErrorCopyDescription(error);
        NSLog(@"Failed to load font: %@", errorDescription);
        CFRelease(errorDescription);
    }
    
    CFRelease(font);
    CFRelease(provider);
}

- (void)unregisterFontWithPath:(NSString *)path
{
    NSData *fontData = [NSData dataWithContentsOfFile:path options:NSDataReadingUncached error:NULL];
    
    CGDataProviderRef provider = CGDataProviderCreateWithCFData((__bridge CFDataRef)fontData);
    CGFontRef font = CGFontCreateWithDataProvider(provider);
    
    CFErrorRef error;
    if (!CTFontManagerUnregisterGraphicsFont(font, &error)) {
        CFStringRef errorDescription = CFErrorCopyDescription(error);
        NSLog(@"Failed to unload font: %@", errorDescription);
        CFRelease(errorDescription);
    }
    
    CFRelease(font);
    CFRelease(provider);
}

#pragma mark - UITableView DataSource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSInteger index = indexPath.row;
    NSString *fontName = nil;
    
    if (index == 0) {
        fontName = @"Ubuntu";
    }
    
    if (index == 1) {
        fontName = @"UbuntuCondensed-Regular";
    }
    
    if (index == 2) {
        fontName = @"Ubuntu-Light";
    }
    
    if (index == 3) {
        fontName = @"AstarWebFont";
    }
    
    UIFont *font = [UIFont fontWithName:fontName size:20];
    
    if (font == nil) {
        font = [UIFont systemFontOfSize:20];
    }
    
    [cell.textLabel setFont:font];
    
    if (index < 3) {
        [cell.textLabel setText:@"Ubuntu"];
    } else {
        [cell.textLabel setText:@"【游錫】"];
    }
    
    return cell;
}

#pragma mark UITableView Delegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSArray<NSString *> *familyNames = [UIFont familyNames];
    
    for (NSString *familyName in familyNames) {
        
        NSLog(@"%@", familyName);
        
        NSArray<NSString *> *fontNames = [UIFont fontNamesForFamilyName:familyName];
        
        for (NSString *fontName in fontNames) {
            NSLog(@"- %@", fontName);
        }
    }
}


@end
