//
//  CALayer+borderColor.m
//  dices
//
//  Created by 簡吟真 on 2021/4/26.
//

#import "CALayer+borderColor.h"
#import <UIKit/UIKit.h>
@implementation CALayer (borderColor)
- (void)setBorderColorWithUIColor:(UIColor *)color
{
 self.borderColor = color.CGColor;
}@end
