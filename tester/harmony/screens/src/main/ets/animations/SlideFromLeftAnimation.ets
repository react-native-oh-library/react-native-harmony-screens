import { AnimationConfiguration } from "./AnimationHandler";

const slideFromLeft: AnimationConfiguration = {
  animationConfiguration: {
    duration: 400
  },
  attachAnimationStartState: {
    translateXValue: '-100%'
  },
  attachAnimationEndState: {
    translateXValue: '0'
  },
  detachAnimationStartState: {
    translateXValue: '0'
  },
  detachAnimationEndState: {
    translateXValue: '-100%'
  },
  showAnimationStartState: {
    translateXValue: '100%'
  },
  showAnimationEndState: {
    translateXValue: '0'
  },
  hideAnimationStartState: {
    translateXValue: '0'
  },
  hideAnimationEndState: {
    translateXValue: '100%'
  }
}

export default slideFromLeft