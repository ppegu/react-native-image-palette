import { NativeModules, Platform } from 'react-native';

const LINKING_ERROR =
  `The package 'react-native-image-palette' doesn't seem to be linked. Make sure: \n\n` +
  Platform.select({ ios: "- You have run 'pod install'\n", default: '' }) +
  '- You rebuilt the app after installing the package\n' +
  '- You are not using Expo Go\n';

const ImagePalette = NativeModules.ImagePalette
  ? NativeModules.ImagePalette
  : new Proxy(
      {},
      {
        get() {
          throw new Error(LINKING_ERROR);
        },
      }
    );

export function multiply(a: number, b: number): Promise<number> {
  return ImagePalette.multiply(a, b);
}

export function getColors(imageUri: string): Promise<any> {
  return ImagePalette.getColors(imageUri, {
    quality: 'high',
  });
}
