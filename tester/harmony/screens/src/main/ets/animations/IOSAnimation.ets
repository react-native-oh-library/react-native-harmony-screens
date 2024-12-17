import { AnimationConfiguration } from "./AnimationHandler";

const ios: AnimationConfiguration = {
  animationConfiguration: {
    duration: 200,
    curve: Curve.Friction
  },
  attachAnimationStartState: {
    translateXValue: '100%'
  },
  attachAnimationEndState: {
    translateXValue: '0'
  },
  detachAnimationStartState: {
    translateXValue: '0'
  },
  detachAnimationEndState: {
    translateXValue: '100%'
  },
  showAnimationStartState: {
    translateXValue: '-30%'
  },
  showAnimationEndState: {
    translateXValue: '0'
  },
  hideAnimationStartState: {
    translateXValue: '0'
  },
  hideAnimationEndState: {
    translateXValue: '-30%'
  }
}

export default ios