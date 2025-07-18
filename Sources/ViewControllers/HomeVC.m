#import <AVFoundation/AVFoundation.h>
#import "HomeVC.h"
#import "../Views/HomeView.h"

@interface HomeViewController ()
@property(nonatomic, strong) HomeView *homeView;
@property(nonatomic, strong) NSArray<NSString *> *sayings;
@property(nonatomic, strong) AVAudioPlayer *audioPlayer;
@property(nonatomic, copy) NSString *selectedSaying;
@end

@implementation HomeViewController

- (void)loadView {
    self.homeView = [[HomeView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.view = self.homeView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    [[AVAudioSession sharedInstance] setActive:YES error:nil];


    self.sayings = @[ @"shit", @"dammit", @"i love you"];

    [self.homeView.dropdownButton addTarget:self
                                           action:@selector(showDropdown)
                                 forControlEvents:UIControlEventTouchUpInside];

    [self.homeView.playSoundButton addTarget:self
                                            action:@selector(playSelectedSound)
                                  forControlEvents:UIControlEventTouchUpInside];
}

- (void)showDropdown {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Pick a Saying"
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleActionSheet];

    for (NSString *saying in self.sayings) {
        UIAlertAction *action = [UIAlertAction actionWithTitle:saying
                                                         style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction *_Nonnull action) {
            [self.homeView.dropdownButton setTitle:saying forState:UIControlStateNormal];

            if ([saying isEqualToString:@"shit"]) {
                self.selectedSaying = @"shit";
            } else if ([saying isEqualToString:@"dammit"]) {
                self.selectedSaying = @"dammit";
            } else if ([saying isEqualToString:@"i love you"]) {
                self.selectedSaying = @"i_love_you";
            } else {
                self.selectedSaying = @"error";
            }

        }];
        [alert addAction:action];
    }

    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel"
                                                     style:UIAlertActionStyleCancel
                                                   handler:nil];
    [alert addAction:cancel];

    [self presentViewController:alert animated:YES completion:nil];
}

- (void)playSelectedSound {
    if (!self.selectedSaying) {
        NSLog(@"No saying selected to play.");
        return;
    }
    [self playSoundForSaying:self.selectedSaying];
}

- (void)playSoundForSaying:(NSString *)saying {
    // Defensive: check input
    if (saying.length == 0) {
        NSLog(@"⚠️ Saying string is empty");
        return;
    }

    // Get path for resource inside Sounds folder
    NSString *filePath = [[NSBundle mainBundle] pathForResource:saying
                                                         ofType:@"wav"];
    if (!filePath) {
        NSLog(@"⚠️ .wav file not found for: %@", saying);

        // Debug: list all files in Sounds folder
        NSString *soundsPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Sounds"];
        NSError *error = nil;
        NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:soundsPath error:&error];
        if (error) {
            NSLog(@"Error reading Sounds folder: %@", error.localizedDescription);
        } else {
            NSLog(@"Files in Sounds folder: %@", files);
        }
        return;
    }

    NSURL *fileURL = [NSURL fileURLWithPath:filePath];
    NSError *error = nil;

    // Initialize audio player
    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:&error];
    if (error) {
        NSLog(@"Error initializing audio player: %@", error.localizedDescription);
        return;
    }

    if (![self.audioPlayer prepareToPlay]) {
        NSLog(@"Failed to prepare audio player");
        return;
    }

    if (![self.audioPlayer play]) {
        NSLog(@"Failed to play audio");
    }
}


@end

