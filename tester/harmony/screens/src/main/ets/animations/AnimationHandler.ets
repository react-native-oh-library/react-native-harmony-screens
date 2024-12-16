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
      return animationConfig.detachAnimationStartState;
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