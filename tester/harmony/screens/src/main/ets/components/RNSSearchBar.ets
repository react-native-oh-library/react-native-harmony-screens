import { Descriptor, RNComponentContext, } from '@rnoh/react-native-openharmony';
import { RNC } from "@rnoh/react-native-openharmony/generated"

export type RNSSearchBarDescriptor = Descriptor<"RNSSearchBar", RNC.RNSSearchBar.Props>

const NATIVE_BUTTON_OFFSET = 52

@Component
export struct RNSSearchBar {
  public static readonly NAME = RNC.RNSSearchBar.NAME
  public ctx!: RNComponentContext
  public isFirstScreenInStack!: boolean
  public tag: number = 0
  @State descriptor: RNSSearchBarDescriptor = {} as RNSSearchBarDescriptor
  private cleanUpCallbacks: (() => void)[] = []
  private controller: TextInputController = new TextInputController()
  private eventEmitter: RNC.RNSSearchBar.EventEmitter | undefined = undefined
  @State text: string = ''
  @State showTextInput: boolean = false;

  aboutToAppear() {
    this.eventEmitter = new RNC.RNSSearchBar.EventEmitter(this.ctx.rnInstance, this.tag)
    this.descriptor = this.ctx.descriptorRegistry.getDescriptor<RNSSearchBarDescriptor>(this.tag)
    this.cleanUpCallbacks.push(this.ctx.descriptorRegistry.subscribeToDescriptorChanges(this.tag,
      (newDescriptor) => {
        this.descriptor = (newDescriptor as RNSSearchBarDescriptor)
      }
    ))
    // TODO: event handlers, like cleanText
  }

  aboutToDisappear() {
    this.cleanUpCallbacks.forEach(cb => cb())
  }

  getInputType(value: string): InputType {
    switch (value) {
      case 'text':
        return InputType.Normal
      case 'phone':
        return InputType.PhoneNumber
      case 'number':
        return InputType.Number
      case 'email':
        return InputType.Email
      default:
        return InputType.Normal
    }
  }

  cancelSearch() {
    this.eventEmitter!.emit("cancelButtonPress", {})
    this.showTextInput = false;
    this.eventEmitter!.emit("close", {})
  }

  build() {
    Column() {
      Row() {
        if (this.showTextInput) {
          TextInput({
            text: this.text,
            controller: this.controller,
            placeholder: this.descriptor.rawProps["placeholder"],
          })
            .onChange((value: string) => {
              this.text = value
              this.eventEmitter!.emit("changeText", { text: value })
            })
            .onFocus(() => {
              this.eventEmitter!.emit("searchFocus", {})
            })
            .onBlur(() => {
              this.eventEmitter!.emit("searchBlur", {})
            })
            .onSubmit(() => {
              this.eventEmitter?.emit("searchButtonPress", {
                text: this.text
              })
            })
            .width(200)
            .backgroundColor(this.descriptor.rawProps["barTintColor"] || Color.Transparent)
            .fontColor(this.descriptor.rawProps["textColor"])
            .type(this.getInputType(this.descriptor.rawProps["inputType"]))
          SymbolGlyph($r('sys.symbol.xmark')).fontSize(26).onClick(() => {
            this.cancelSearch()
          })
        } else {
          SymbolGlyph($r('sys.symbol.magnifyingglass')).fontSize(26).onClick(() => {
            this.showTextInput = true;
            this.eventEmitter!.emit("open", {})
          })
        }
      }
    }
    .width("100%")
    .height("100%")
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.End)
    .offset({
      left: this.isFirstScreenInStack ? NATIVE_BUTTON_OFFSET - 8 : -8,
    })
  }
}
