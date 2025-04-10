/**
 * MIT License
 *
 * Copyright (C) 2025 Huawei Device Co., Ltd.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

import fadeFromBottom from './FadeFromBottomAnimation';
import slideFromBottom from './SlideFromBottomAnimation';
import slideFromLeft from './SlideFromLeftAnimation';
import slideFromRight from './SlideFromRightAnimation';
import iosAnimation from './IOSAnimation'
import noneAnimation from './NoneAnimation'
import fade from './FadeAnimation';

export enum AnimationHandlerEvent {
  ATTACH_START,
  ATTACH_END,
  DETACH_START,
  DETACH_END,
  SHOW_START,
  SHOW_END,
  HIDE_START,
  HIDE_END,
}

export interface AnimationState {
  translateXValue?: string;
  translateYValue?: string;
  opacityValue?: number;
}

export interface AnimationConfiguration {
  animationConfiguration: AnimateParam
  attachAnimationStartState: AnimationState
  attachAnimationEndState: AnimationState
  detachAnimationStartState: AnimationState
  detachAnimationEndState: AnimationState
  showAnimationStartState: AnimationState
  showAnimationEndState: AnimationState
  hideAnimationStartState: AnimationState
  hideAnimationEndState: AnimationState
}

function getAnimationConfigurationObject(animationType: string): AnimationConfiguration {
  switch (animationType) {
    case 'slide_from_right':
      return slideFromRight;
    case 'slide_from_left':
      return slideFromLeft;
    case 'slide_from_bottom':
      return slideFromBottom;
    case 'fade_from_bottom':
      return fadeFromBottom;
    case 'ios':
      return iosAnimation;
    case 'none':
      return noneAnimation;
    case 'fade':
      return fade;
    case 'default':
      return slideFromRight;
    case 'flip':
      return slideFromRight;
    case 'simple_push':
      return slideFromRight;
  }

  // TODO: create/import from specs the type for animationType variable
  return {} as AnimationConfiguration
}

export function getAnimationConfig(animationType: string): AnimateParam {
  const animationConfig = getAnimationConfigurationObject(animationType);
  return animationConfig.animationConfiguration;
}

export function getNewAnimationState(animationType: string, animationEvent: AnimationHandlerEvent): AnimationState {
  const animationConfig = getAnimationConfigurationObject(animationType);
  switch (animationEvent) {
    case AnimationHandlerEvent.ATTACH_START:
      return animationConfig.attachAnimationStartState;
    case AnimationHandlerEvent.ATTACH_END:
      return animationConfig.attachAnimationEndState;
    case AnimationHandlerEvent.DETACH_START:
      return animationConfig.detachAnimationStartState;
    case AnimationHandlerEvent.DETACH_END:
      return animationConfig.detachAnimationEndState;
    case AnimationHandlerEvent.SHOW_START:
      return animationConfig.showAnimationStartState;
    case AnimationHandlerEvent.SHOW_END:
      return animationConfig.showAnimationEndState;
    case AnimationHandlerEvent.HIDE_START:
      return animationConfig.hideAnimationStartState;
    case AnimationHandlerEvent.HIDE_END:
      return animationConfig.hideAnimationEndState;
  }
}