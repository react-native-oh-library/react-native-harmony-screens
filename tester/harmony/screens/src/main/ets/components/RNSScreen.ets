import { Descriptor, RNComponentContext, RNViewBase, } from '@rnoh/react-native-openharmony';
import { RNC } from "@rnoh/react-native-openharmony/generated"
import { RNSScreenStackHeaderConfigDescriptor } from './RNSScreenStackHeaderConfig';
import { RNSScreenStackHeaderSubview } from './RNSScreenStackHeaderSubview';

export type RNSScreenDescriptor = Descriptor<"RNSScreen", RNC.RNSScreen.Props>

const TITLEBAR_HEIGHT = 56;

@Component
struct RNSScreenTitle {
  public ctx!: RNComponentContext
  @State screenStackHeaderConfigDescriptor: RNSScreenStackHeaderConfigDescriptor =
    {} as RNSScreenStackHeaderConfigDescriptor

  build() {
    Stack() {
      Text(this.screenStackHeaderConfigDescriptor.rawProps["title"])
        .width("100%")
        .height("100%")
        .offset({
          left: TITLEBAR_HEIGHT + 8
        })
        .fontFamily(this.screenStackHeaderConfigDescriptor.rawProps["titleFontFamily"])
        .fontSize(this.screenStackHeaderConfigDescriptor.rawProps["titleFontSize"])
        .fontWeight(this.screenStackHeaderConfigDescriptor.rawProps["titleFontWeight"])
        .fontColor(this.screenStackHeaderConfigDescriptor.rawProps["titleColor"])
        .textAlign(TextAlign.Start)
      ForEach(this.screenStackHeaderConfigDescriptor.childrenTags, (childTag: number) => {
        RNSScreenStackHeaderSubview({
          ctx: this.ctx,
          tag: childTag
        })
      })
    }
    .width("100%")
    .height("100%")
    .hitTestBehavior(HitTestMode.Transparent)
    .offset({
      right: TITLEBAR_HEIGHT
    })
  }
}


@Component
export struct RNSScreen {
  public static readonly NAME = RNC.RNSScreen.NAME
  public ctx!: RNComponentContext
  public isFirstScreenInStack!: boolean
  public tag: number = 0
  private eventEmitter: RNC.RNSScreen.EventEmitter | undefined = undefined
  private cleanUpCallbacks: (() => void)[] = []
  private dismissCount: number = 1;
  @State public topInset: number = 0;
  @State descriptor: RNSScreenDescriptor = {} as RNSScreenDescriptor
  @State screenStackHeaderConfigDescriptor: RNSScreenStackHeaderConfigDescriptor =
    {} as RNSScreenStackHeaderConfigDescriptor
  @State titleHeight: number = 0;

  private isComponentOfType(childTag: number, componentType: string): boolean {
    const descriptor = this.ctx.descriptorRegistry.getDescriptor<Descriptor>(childTag)
    if (descriptor.type === componentType) {
      return true;
    }
    return false;
  }

  aboutToAppear() {
    this.eventEmitter = new RNC.RNSScreen.EventEmitter(this.ctx.rnInstance, this.tag)

    // RNSScreen
    this.descriptor = this.ctx.descriptorRegistry.getDescriptor<RNSScreenDescriptor>(this.tag)
    this.cleanUpCallbacks.push(this.ctx.descriptorRegistry.subscribeToDescriptorChanges(this.tag,
      (newDescriptor) => {
        this.descriptor = (newDescriptor as RNSScreenDescriptor)
      }
    ))

    // RNSScreenStackHeaderConfig
    const screenStackHeaderConfigTag =
      this.descriptor.childrenTags.find((childTag) => this.isComponentOfType(childTag,
        "RNSScreenStackHeaderConfig"))

    if (screenStackHeaderConfigTag) {
      this.screenStackHeaderConfigDescriptor =
        this.ctx.descriptorRegistry.getDescriptor<RNSScreenStackHeaderConfigDescriptor>(screenStackHeaderConfigTag)
      this.cleanUpCallbacks.push(this.ctx.descriptorRegistry.subscribeToDescriptorChanges(screenStackHeaderConfigTag,
        (newDescriptor) => {
          this.screenStackHeaderConfigDescriptor = (newDescriptor as RNSScreenStackHeaderConfigDescriptor)
          this.updateNativeHeaderHeight()
        }
      ))
    }

    this.updateNativeHeaderHeight()
  }

  updateNativeHeaderHeight() {
    if (this.screenStackHeaderConfigDescriptor.rawProps["hidden"]) {
      this.titleHeight = 0;
    } else if (this.screenStackHeaderConfigDescriptor.rawProps["title"]) {
      this.titleHeight = TITLEBAR_HEIGHT
    } else if (!this.isFirstScreenInStack) {
      this.titleHeight = TITLEBAR_HEIGHT
    }

    this.eventEmitter?.emit("headerHeightChange", {
      headerHeight: this.topInset + this.titleHeight
    })
  }

  aboutToDisappear() {
    this.cleanUpCallbacks.forEach(cb => cb())
  }

  @Builder
  screenTitleBuilder() {
    RNSScreenTitle({
      ctx: this.ctx,
      screenStackHeaderConfigDescriptor: this.screenStackHeaderConfigDescriptor
    })
  }

  build() {
    NavDestination() {
      RNViewBase({ ctx: this.ctx, tag: this.tag }) {
        Stack() {
          ContentSlot(this.ctx.getContentForTag(this.tag))
        }.offset({
          top: -this.topInset - this.titleHeight
        })
      }
    }
    .title({ builder: this.screenTitleBuilder, height: this.titleHeight }, {
      backgroundColor: this.screenStackHeaderConfigDescriptor.rawProps["backgroundColor"],
    })
    // .backgroundColor('rgba(0,0,0,0.0)')
    // .mode(this.screenStackHeaderConfigDescriptor.rawProps["stackPresentation"] === "modal" ||
    //   this.screenStackHeaderConfigDescriptor.rawProps["stackPresentation"] === "transparentModal" ?
    // NavDestinationMode.DIALOG :
    // NavDestinationMode.STANDARD)
    .hideTitleBar(this.screenStackHeaderConfigDescriptor.rawProps["hidden"] ||
      this.screenStackHeaderConfigDescriptor.rawProps["stackPresentation"] === "modal")
    .onWillAppear(() => {
      this.eventEmitter!.emit("willAppear", {})
    })
    .onAppear(() => {
      this.eventEmitter!.emit("appear", {})
    })
    .onWillDisappear(() => {
      this.eventEmitter!.emit("willDisappear", {})
    })
    .onDisAppear(() => {
      this.eventEmitter!.emit("disappear", {})
    })
    .onBackPressed(() => {
      this.eventEmitter!.emit("dismissed", {
        dismissCount: this.dismissCount
      })
      return false;
    })
  }
}