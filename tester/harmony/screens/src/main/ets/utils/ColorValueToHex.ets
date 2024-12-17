import { ColorValue } from "@rnoh/react-native-openharmony";

interface ColorObject {
  a: number;
  r: number;
  g: number;
  b: number;
}

export function convertColorValueToHex(colorValue: ColorValue | undefined, defaultColor: string = "#00000000") {
  if (colorValue === undefined) {
    return defaultColor;
  }
  const toHex = (num: number, padding: number) => num.toString(16).padStart(padding, '0');
  const argb: ColorObject = {
    a: (colorValue >> 24) & 0xff,
    r: (colorValue >> 16) & 0xff,
    g: (colorValue >> 8) & 0xff,
    b: ((colorValue >> 0) & 0xff),
  }
  return `#${toHex(argb.a, 2)}${toHex(argb.r, 2)}${toHex(argb.g, 2)}${toHex(argb.b, 2)}`;
}
