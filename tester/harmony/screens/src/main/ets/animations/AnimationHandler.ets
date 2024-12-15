@Observed
// FIXME: updating the animation state from the component in this class doesn't work
export abstract class AnimationHandler {
  translateXValue: string = '0';
  translateYValue: string = '0';
  opacityValue: number = 1;
  abstract attachAnimationOptions: AnimateParam;
  abstract detachAnimationOptions: AnimateParam;
  abstract showAnimationOptions: AnimateParam;
  abstract hideAnimationOptions: AnimateParam;

  constructor(translateXValue: string, translateYValue: string, opacityValue: number) {
    this.translateXValue = translateXValue;
    this.translateYValue = translateYValue;
    this.opacityValue = opacityValue;
  }

  abstract attachAnimationStartCallback(translateXValue: string, translateYValue: string, opacityValue: number): void

  abstract attachAnimationEndCallback(translateXValue: string, translateYValue: string, opacityValue: number): void

  abstract detachAnimationStartCallback(): void;

  abstract detachAnimationEndCallback(): void;

  abstract showAnimationStartCallback(): void;

  abstract showAnimationEndCallback(): void;

  abstract hideAnimationStartCallback(): void;

  abstract hideAnimationEndCallback(): void;
}