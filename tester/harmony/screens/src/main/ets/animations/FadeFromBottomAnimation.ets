import { AnimationConfiguration } from "./AnimationHandler";

const fadeFromBottom: AnimationConfiguration = {
  animationConfiguration: {
    duration: 400
  },
  attachAnimationStartState: {
    translateYValue: '100%',
    opacityValue: 0
  },
  attachAnimationEndState: {
    translateYValue: '0',
    opacityValue: 1
  },
  detachAnimationStartState: {
    translateYValue: '0',
    opacityValue: 1
  },
  detachAnimationEndState: {
    translateYValue: '100%',
    opacityValue: 0
  },
  showAnimationStartState: {
    translateYValue: '0',
    opacityValue: 1
  },
  showAnimationEndState: {
    translateYValue: '0',
    opacityValue: 1
  },
  hideAnimationStartState: {
    translateYValue: '0',
    opacityValue: 1
  },
  hideAnimationEndState: {
    translateYValue: '0',
    opacityValue: 1
  }
}

export default fadeFromBottom