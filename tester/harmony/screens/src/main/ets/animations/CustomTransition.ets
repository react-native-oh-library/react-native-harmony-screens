// Custom API to save the transition animation callback and parameters related to a page.

type AnimationCallback = (animationType: string) => void;

export interface AnimationDefinition {
  start: AnimationCallback,
  end: AnimationCallback,
  options: AnimateParam
}

export interface AnimateCallback {
  getAnimationType: () => string,
  attachAnimation: AnimationDefinition,
  detachAnimation: AnimationDefinition,
  hideAnimation: AnimationDefinition,
  showAnimation: AnimationDefinition,
}

export class CustomTransitionCoordinator {
  proxy: NavigationTransitionProxy | undefined = undefined;
  operation: NavigationOperation = NavigationOperation.PUSH
  private customTransitionMap: Map<string, AnimateCallback> = new Map();

  // Passing the callbacks in the object breaks animateTo
  registerNavParam(name: string,
    getAnimationType: () => string,
    attachAnimationStartCallback: AnimationCallback,
    attachAnimationEndCallback: AnimationCallback,
    attachAnimationOptions: AnimateParam,
    detachAnimationStartCallback: AnimationCallback,
    detachAnimationEndCallback: AnimationCallback,
    detachAnimationOptions: AnimateParam,
    showAnimationStartCallback: AnimationCallback,
    showAnimationEndCallback: AnimationCallback,
    showAnimationOptions: AnimateParam,
    hideAnimationStartCallback: AnimationCallback,
    hideAnimationEndCallback: AnimationCallback,
    hideAnimationOptions: AnimateParam,
  ): void {
    let paramToStore: AnimateCallback = {
      getAnimationType,
      attachAnimation: {
        start: attachAnimationStartCallback,
        end: attachAnimationEndCallback,
        options: attachAnimationOptions
      },
      detachAnimation: {
        start: detachAnimationStartCallback,
        end: detachAnimationEndCallback,
        options: detachAnimationOptions
      },
      showAnimation: {
        start: showAnimationStartCallback,
        end: showAnimationEndCallback,
        options: showAnimationOptions
      },
      hideAnimation: {
        start: hideAnimationStartCallback,
        end: hideAnimationEndCallback,
        options: hideAnimationOptions
      }
    }
    if (this.customTransitionMap.has(name)) {
      let param = this.customTransitionMap.get(name);
      if (param != undefined) {
        param = paramToStore
        return;
      }
    }
    this.customTransitionMap.set(name, paramToStore);
  }

  unregisterNavParam(name: string): void {
    this.customTransitionMap.delete(name);
  }

  finishTransition() {
    this.proxy?.finishTransition();
  }

  getAnimateParam(name: string): AnimateCallback {
    return this.customTransitionMap.get(name)!;
  }
}