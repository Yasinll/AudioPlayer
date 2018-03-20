//
//  ViewController.m
//  AudioPlayer
//
//  Created by PatrickY on 2017/11/28.
//  Copyright © 2017年 PatrickY. All rights reserved.
//

#import "ViewController.h"

@interface ViewController (){
    
    AVAudioPlayer *audioPlayer;
    NSTimer *timer;
    
}
@property (weak, nonatomic) IBOutlet UISlider *audioVol;

@property (weak, nonatomic) IBOutlet UISlider *audioTime;
@property (weak, nonatomic) IBOutlet UIStepper *audioCyc;
@property (weak, nonatomic) IBOutlet UIProgressView *audioProgress;
@property (weak, nonatomic) IBOutlet UITextView *audioInfo;
- (IBAction)audioPlay:(id)sender;
- (IBAction)audioPause:(id)sender;
- (IBAction)audioStop:(id)sender;
- (IBAction)audioSwitch:(id)sender;
- (IBAction)audioVol:(id)sender;
- (IBAction)audioTime:(id)sender;
- (IBAction)audioCyc:(id)sender;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)audioPlay:(id)sender {
    
    NSString *audioPath = [[NSBundle mainBundle] pathForResource:@"Cinderella" ofType:@"mp3"];
    
    if (audioPath) {
        
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
        
         NSURL *audioUrl = [NSURL fileURLWithPath:audioPath];
        
        audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:audioUrl error:nil];
        audioPlayer.delegate = self;
        audioPlayer.meteringEnabled = YES;
        
        timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(monitor) userInfo:nil repeats:YES];
        
        [audioPlayer play];
        
    }
 
}

- (void)monitor {
    
    NSInteger channels = audioPlayer.numberOfChannels;
    NSTimeInterval duration = audioPlayer.duration;
    
    [audioPlayer updateMeters];
    
    NSString *audioInfoValue = [[NSString alloc] initWithFormat:@"%f, %f\n channles=%lu duration = %lu\n currentTime = %f",[audioPlayer peakPowerForChannel:0], [audioPlayer peakPowerForChannel:1], (unsigned long)channels, (unsigned long)duration, audioPlayer.currentTime];
    
    self.audioInfo.text = audioInfoValue;
    
    self.audioProgress.progress = audioPlayer.currentTime / audioPlayer.duration;
    
}

- (IBAction)audioPause:(id)sender {
    
    if ([audioPlayer isPlaying]) {
        
        [audioPlayer pause];
    
    }else {
    
        [audioPlayer play];
        
    }
    
}

- (IBAction)audioStop:(id)sender {
    
    self.audioTime.value = 0;
    self.audioProgress.progress = 0;
    
    [audioPlayer stop];
    
}

- (IBAction)audioSwitch:(id)sender {
    
    audioPlayer.volume = [sender isOn];
    
}

- (IBAction)audioVol:(id)sender {
    
    audioPlayer.volume = self.audioVol.value;
    
}

- (IBAction)audioTime:(id)sender {
    
    [audioPlayer pause];
    [audioPlayer setCurrentTime:(NSTimeInterval)self.audioTime.value * audioPlayer.duration];
    
    [audioPlayer play];
    
}

- (IBAction)audioCyc:(id)sender {
    
    audioPlayer.numberOfLoops = self.audioCyc.value;
    
}


#pragma mark -- audio delegate

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    NSLog(@"播放完成");
    
}

- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError * __nullable)error {
    
}

- (void)audioPlayerBeginInterruption:(AVAudioPlayer *)player {
    
}



@end



