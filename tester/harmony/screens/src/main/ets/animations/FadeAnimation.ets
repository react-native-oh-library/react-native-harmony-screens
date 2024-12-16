import { AnimationConfiguration } from "./AnimationHandler";

const fade: AnimationConfiguration = {
  animationConfiguration: {
    duration: 400
  },
  attachAnimationStartState: {
    opacityValue: 0
  },
  attachAnimationEndState: {
    opacityValue: 1
  },
  detachAnimationStartState: {
    opacityValue: 1
  },
  detachAnimationEndState: {
    opacityValue: 0
  },
  showAnimationStartState: {
    opacityValue: 1
  },
  showAnimationEndState: {
    opacityValue: 1
  },
  hideAnimationStartState: {
    opacityValue: 1
  },
  hideAnimationEndState: {
    opacityValue: 1
  }
}

export default fade