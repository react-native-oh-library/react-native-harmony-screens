import { AnimationConfiguration } from "./AnimationHandler";

const slideFromBottom: AnimationConfiguration = {
  animationConfiguration: {
    duration: 400
  },
  attachAnimationStartState: {
    translateYValue: '100%'
  },
  attachAnimationEndState: {
    translateYValue: '0'
  },
  detachAnimationStartState: {
    translateYValue: '0'
  },
  detachAnimationEndState: {
    translateYValue: '100%'
  },
  showAnimationStartState: {
    translateYValue: '0'
  },
  showAnimationEndState: {
    translateYValue: '0'
  },
  hideAnimationStartState: {
    translateYValue: '0'
  },
  hideAnimationEndState: {
    translateYValue: '0'
  }
}

export default slideFromBottom