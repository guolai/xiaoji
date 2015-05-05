//
//  BSKeyboardControls.h
//  Example
//
//  Created by Simon B. Støvring on 11/01/13.
//  Copyright (c) 2013 simonbs. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  Available controls.
 */
typedef enum
{
    BSKeyboardControlPreviousNext = 1 << 0,
    BSKeyboardControlDone = 1 << 1
} BSKeyboardControl;


typedef enum
{
    BSKeyboardControlsDirectionPrevious = 0,
    BSKeyboardControlsDirectionNext
} BSKeyboardControlsDirection;

@protocol BSKeyboardControlsDelegate;

@interface BSKeyboardControls : UIView


@property (nonatomic, assign) id <BSKeyboardControlsDelegate> delegate;

@property (nonatomic, assign) BSKeyboardControl visibleControls;

@property (nonatomic, retain) NSArray *fields;

@property (nonatomic, retain) UIView *activeField;

@property (nonatomic, assign) UIBarStyle barStyle;
@property (nonatomic, retain) UIColor *barTintColor;
@property (nonatomic, retain) UIColor *segmentedControlTintControl;
@property (nonatomic, retain) NSString *previousTitle;
@property (nonatomic, retain) NSString *nextTitle;
@property (nonatomic, retain) NSString *doneTitle;
@property (nonatomic, retain) UIColor *doneTintColor;

- (id)initWithFields:(NSArray *)fields;

@end

@protocol BSKeyboardControlsDelegate <NSObject>
@optional
/**
 *  Called when a field was selected by going to the previous or the next field.
 *  The implementation of this method should scroll to the view.
 *  @param keyboardControls The instance of keyboard controls.
 *  @param field The selected field.
 *  @param direction Direction in which the field was selected.
 */
- (void)keyboardControls:(BSKeyboardControls *)keyboardControls selectedField:(UIView *)field inDirection:(BSKeyboardControlsDirection)direction;

/**
 *  Called when the done button was pressed.
 *  @param keyboardControls The instance of keyboard controls.
 */
- (void)keyboardControlsDonePressed:(BSKeyboardControls *)keyboardControls;
@end