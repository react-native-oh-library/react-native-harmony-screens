import { Descriptor, RNComponentContext, } from '@rnoh/react-native-openharmony';
import { RNC } from "@rnoh/react-native-openharmony/generated"
import { NATIVE_BUTTON_OFFSET, NATIVE_BUTTON_VERTICAL_EDGE_MARGIN } from '../Constants'

export type RNSSearchBarDescriptor = Descriptor<"RNSSearchBar", RNC.RNSSearchBar.Props>


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
  @State placeholder: string | undefined = undefined;
  @State backgroundColorValue: string | undefined = undefined;
  @State fontColor: string | undefined = undefined
  @State type: InputType | undefined = undefined

  aboutToAppear() {
    this.eventEmitter = new RNC.RNSSearchBar.EventEmitter(this.ctx.rnInstance, this.tag)
    this.descriptor = this.ctx.descriptorRegistry.getDescriptor<RNSSearchBarDescriptor>(this.tag)
    this.cleanUpCallbacks.push(this.ctx.descriptorRegistry.subscribeToDescriptorChanges(this.tag,
      (newDescriptor) => {
        this.descriptor = (newDescriptor as RNSSearchBarDescriptor)
        this.updateState()
      }
    ))
    this.updateState()
    // TODO: event handlers, like cleanText
  }

  updateState() {
    if (this.placeholder !== this.descriptor.rawProps["placeholder"]) {
      this.placeholder = this.descriptor.rawProps["placeholder"];
    }
    if (this.backgroundColorValue !== (this.descriptor.rawProps["barTintColor"] || Color.Transparent)) {
      this.backgroundColorValue = this.descriptor.rawProps["barTintColor"] || Color.Transparent
    }
    if (this.fontColor !== this.descriptor.rawProps["textColor"]) {
      this.fontColor = this.descriptor.rawProps["textColor"];
    }
    if (this.type !== this.getInputType(this.descriptor.rawProps["inputType"])) {
      this.type = this.getInputType(this.descriptor.rawProps["inputType"])
    }
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
            placeholder: this.placeholder,
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
            .backgroundColor(this.backgroundColorValue)
            .fontColor(this.fontColor)
            .type(this.type)
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
      left: this.isFirstScreenInStack ? NATIVE_BUTTON_OFFSET - NATIVE_BUTTON_VERTICAL_EDGE_MARGIN :
        -NATIVE_BUTTON_VERTICAL_EDGE_MARGIN,
    })
  }
}
