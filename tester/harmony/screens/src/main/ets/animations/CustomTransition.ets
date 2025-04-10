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
    detachAnimationStartCallback: AnimationCallback,
    detachAnimationEndCallback: AnimationCallback,
    showAnimationStartCallback: AnimationCallback,
    showAnimationEndCallback: AnimationCallback,
    hideAnimationStartCallback: AnimationCallback,
    hideAnimationEndCallback: AnimationCallback,
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
    return this.customTransitionMap.get(name)!;
  }
}