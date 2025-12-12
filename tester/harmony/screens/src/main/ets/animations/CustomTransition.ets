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
import { JSON } from "@kit.ArkTS";

// Custom API to save the transition animation callback and parameters related to a page.

type AnimationCallback = (animationType: string) => void;

export interface AnimationDefinition {
  start: AnimationCallback,
  end: AnimationCallback,
}

export interface AnimateCallback {
  getAnimationType: () => string,
  attachAnimation: AnimationDefinition,
  detachAnimation: AnimationDefinition,
  hideAnimation: AnimationDefinition,
  showAnimation: AnimationDefinition,
  interactive: ((operation: NavigationOperation) => void | undefined) | undefined;
}

export class CustomTransitionCoordinator {
  proxy: NavigationTransitionProxy | undefined = undefined;
  operation: NavigationOperation = NavigationOperation.PUSH
  private customTransitionMap: Map<string, AnimateCallback> = new Map();
  interactive: boolean = false;

  logMap():void {
    let entriesIter = this.customTransitionMap.entries()
    console.debug(`RNSScreen customTransitionMap logger-------------`)
    for(const entry of entriesIter){
      console.debug(`RNSScreen customTransitionMap key: ${entry[0]}  value: ${JSON.stringify(entry[1])}`)
    }
    console.debug(`RNSScreen customTransitionMap logger-------------`)
  }

  // Passing the callbacks in the object breaks animateTo
  registerNavParam(name: string,
    getAnimationType: () => string,
    attachAnimationStartCallback: AnimationCallback,
    attachAnimationEndCallback: AnimationCallback,
    detachAnimationStartCallback: AnimationCallback,
    detachAnimationEndCallback: AnimationCallback,
    showAnimationStartCallback: AnimationCallback,
    showAnimationEndCallback: AnimationCallback,
    hideAnimationStartCallback: AnimationCallback,
    hideAnimationEndCallback: AnimationCallback,
    interactiveCallback: (operation: NavigationOperation) => void,
  ): void {
    let paramToStore: AnimateCallback = {
      getAnimationType,
      attachAnimation: {
        start: attachAnimationStartCallback,
        end: attachAnimationEndCallback,
      },
      detachAnimation: {
        start: detachAnimationStartCallback,
        end: detachAnimationEndCallback,
      },
      showAnimation: {
        start: showAnimationStartCallback,
        end: showAnimationEndCallback,
      },
      hideAnimation: {
        start: hideAnimationStartCallback,
        end: hideAnimationEndCallback,
      },
      interactive: interactiveCallback
    }
    console.debug(`RNSScreen CustomTransitionCoordinator registerNavParam pageId: ${name}`)
    if (this.customTransitionMap.has(name)) {
      console.debug(`RNSScreen CustomTransitionCoordinator has(name): ${this.customTransitionMap.has(name)}`)
      let param = this.customTransitionMap.get(name);
      if (param != undefined) {
        param = paramToStore
        return;
      }
    }
    this.customTransitionMap.set(name, paramToStore);

    this.logMap()

  }

  unregisterNavParam(name: string): void {
    console.debug(`RNSScreen CustomTransitionCoordinator unregisterNavParam pageId: ${name}`)
    this.customTransitionMap.delete(name);

    this.logMap()
  }

  finishTransition() {
    this.proxy?.finishTransition();
  }

  updateProgress(progress: number) {
    if (!this.proxy?.updateTransition) {
      return;
    }
    progress = this.operation == NavigationOperation.PUSH ? 1 - progress : progress;
    this.proxy?.updateTransition(progress);
  }

  cancelTransition() {
    if (this.proxy?.cancelTransition) {
      this.proxy.cancelTransition();
    }
  }

  getAnimateParam(name: string): AnimateCallback {
    console.debug(`RNSScreen CustomTransitionCoordinator getAnimateParam pageId: ${name} value: ${JSON.stringify(this.customTransitionMap.get(name)!)}`)
    return this.customTransitionMap.get(name)!;
  }

  fireInteractiveAnimation(name: string, operation: NavigationOperation) {
    let animation = this.customTransitionMap.get(name)?.interactive;
    console.debug(`RNSScreen CustomTransitionCoordinator getAnimateParam animation: ${!!animation}`)

    if (!animation) {
      return;
    }
    animation(operation);
  }
}