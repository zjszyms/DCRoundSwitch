//
//  DCRoundSwitchKnobLayer.m
//
//  Created by Patrick Richards on 29/06/11.
//  MIT License.
//
//  http://twitter.com/patr
//  http://domesticcat.com.au/projects
//  http://github.com/domesticcatsoftware/DCRoundSwitch
//

#import "DCRoundSwitchKnobLayer.h"

CGGradientRef CreateGradientRefWithColors(CGColorSpaceRef colorSpace, CGColorRef startColor, CGColorRef endColor);

@implementation DCRoundSwitchKnobLayer
@synthesize gripped, flatKnob;

- (void)drawInContext:(CGContextRef)context
{
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
	CGFloat inset = 2;
    CGRect knobRect = CGRectInset(self.bounds, inset, inset);
	CGFloat knobRadius = self.bounds.size.height - inset;

    if (!self.flatKnob) {
        // knob outline (shadow is drawn in the toggle layer)
        CGContextSetStrokeColorWithColor(context, [UIColor colorWithWhite:0.62 alpha:1.0].CGColor);
        CGContextSetLineWidth(context, 1.5);
        CGContextStrokeEllipseInRect(context, knobRect);
        CGContextSetShadowWithColor(context, CGSizeMake(0, 0), 0, NULL);
    }

	// knob inner gradient
	CGContextAddEllipseInRect(context, knobRect);
	CGContextClip(context);
	CGColorRef knobStartColor = self.flatKnob ? [UIColor whiteColor].CGColor : [UIColor colorWithWhite:0.82 alpha:1.0].CGColor;
	CGColorRef knobEndColor;
    if (self.flatKnob) {
        knobEndColor = knobStartColor;
    } else {
        knobEndColor = (self.gripped) ? [UIColor colorWithWhite:0.894 alpha:1.0].CGColor : [UIColor colorWithWhite:0.996 alpha:1.0].CGColor;
    }
	CGPoint topPoint = CGPointMake(0, 0);
	CGPoint bottomPoint = CGPointMake(0, knobRadius + inset);
	CGGradientRef knobGradient = CreateGradientRefWithColors(colorSpace, knobStartColor, knobEndColor);
	CGContextDrawLinearGradient(context, knobGradient, topPoint, bottomPoint, 0);
	CGGradientRelease(knobGradient);

    if (!self.flatKnob) {
        // knob inner highlight
        CGContextAddEllipseInRect(context, CGRectInset(knobRect, 0.5, 0.5));
        CGContextAddEllipseInRect(context, CGRectInset(knobRect, 1.5, 1.5));
        CGContextEOClip(context);
        CGGradientRef knobHighlightGradient = CreateGradientRefWithColors(colorSpace, [UIColor whiteColor].CGColor, [UIColor colorWithWhite:1.0 alpha:0.5].CGColor);
        CGContextDrawLinearGradient(context, knobHighlightGradient, topPoint, bottomPoint, 0);
        CGGradientRelease(knobHighlightGradient);
    }

	CGColorSpaceRelease(colorSpace);
}

CGGradientRef CreateGradientRefWithColors(CGColorSpaceRef colorSpace, CGColorRef startColor, CGColorRef endColor)
{
	CGFloat colorStops[2] = {0.0, 1.0};
	CGColorRef colors[] = {startColor, endColor};
	CFArrayRef colorsArray = CFArrayCreate(NULL, (const void**)colors, sizeof(colors) / sizeof(CGColorRef), &kCFTypeArrayCallBacks);
	CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, colorsArray, colorStops);
	CFRelease(colorsArray);
	return gradient;
}

- (void)setGripped:(BOOL)newGripped
{
	gripped = newGripped;
	[self setNeedsDisplay];
}

@end
