/* eslint-disable */
import codegenNativeComponent from "react-native/Libraries/Utilities/codegenNativeComponent";
import type { ViewProps, ColorValue, HostComponent } from "react-native";
import type {
  WithDefault,
  DirectEventHandler,
} from "react-native/Libraries/Types/CodegenTypes";
import codegenNativeCommands from "react-native/Libraries/Utilities/codegenNativeCommands";

export type SearchBarEvent = Readonly<{}>;

export type SearchButtonPressedEvent = Readonly<{
  text?: string;
}>;

export type ChangeTextEvent = Readonly<{
  text?: string;
}>;

type SearchBarPlacement = "automatic" | "inline" | "stacked";

type AutoCapitalizeType = "none" | "words" | "sentences" | "characters";

export interface NativeProps extends ViewProps {
  onSearchFocus?: DirectEventHandler<SearchBarEvent> | null;
  onSearchBlur?: DirectEventHandler<SearchBarEvent> | null;
  onSearchButtonPress?: DirectEventHandler<SearchButtonPressedEvent> | null;
  onCancelButtonPress?: DirectEventHandler<SearchBarEvent> | null;
  onChangeText?: DirectEventHandler<ChangeTextEvent> | null;
  hideWhenScrolling?: boolean;
  autoCapitalize?: WithDefault<AutoCapitalizeType, "none">; // TODO
  placeholder?: string;
  placement?: WithDefault<SearchBarPlacement, "stacked">; // iOS only
  obscureBackground?: boolean; // iOS only
  hideNavigationBar?: boolean; // iOS only
  cancelButtonText?: string; // iOS only
  // TODO: implement these on iOS
  barTintColor?: ColorValue; // iOS only
  tintColor?: ColorValue; // iOS only
  textColor?: ColorValue; // iOS only

  // Android only
  disableBackButtonOverride?: boolean;
  // TODO: consider creating enum here
  inputType?: string;
  onClose?: DirectEventHandler<SearchBarEvent> | null;
  onOpen?: DirectEventHandler<SearchBarEvent> | null;
  hintTextColor?: ColorValue; // Android only
  headerIconColor?: ColorValue; // TODO
  shouldShowHintSearchIcon?: WithDefault<boolean, true>; // Android only
}

type ComponentType = HostComponent<NativeProps>;

interface NativeCommands {
  blur: (viewRef: React.ElementRef<ComponentType>) => void;
  focus: (viewRef: React.ElementRef<ComponentType>) => void;
  clearText: (viewRef: React.ElementRef<ComponentType>) => void;
  toggleCancelButton: (
    viewRef: React.ElementRef<ComponentType>,
    flag: boolean
  ) => void;
  setText: (viewRef: React.ElementRef<ComponentType>, text: string) => void;
  cancelSearch: (viewRef: React.ElementRef<ComponentType>) => void;
}

export const Commands: NativeCommands = codegenNativeCommands<NativeCommands>({
  supportedCommands: [
    "blur",
    "focus",
    "clearText",
    "toggleCancelButton",
    "setText",
    "cancelSearch",
  ],
});

export default codegenNativeComponent<NativeProps>("RNSSearchBar", {});
