//
//  LVInfiniteScrollView.h
//  LVInfiniteScrollView
//
//  Created by 孔友夫 on 2018/5/11.
//  Copyright © 2018年 LV. All rights reserved.
//

#import <UIKit/UIKit.h>


@class LVInfiniteScrollView;

@protocol LVInfiniteDelegate<NSObject>

    -(void)LVInfinite:(LVInfiniteScrollView*)infiniteView DidSelected:(NSInteger)index;
    

    @end

@interface LVInfiniteScrollView : UIView


    @property (nonatomic,assign)CGFloat animationDuration;
    
    @property (nonatomic, weak) id <LVInfiniteDelegate>delegate;

@property (nonatomic, strong) NSArray *imageNames;
    



@end
