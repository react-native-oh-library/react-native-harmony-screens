import { hapTasks } from '@ohos/hvigor-ohos-plugin';
import { createRNOHHvigorPlugin } from '@rnoh/hvigor-plugin';

export default {
  system: hapTasks,
  plugins: [
    createRNOHHvigorPlugin({
      codegen: {
        rnohModulePath: './oh_modules/@rnoh/react-native-openharmony',
      },
      autolinking: {
        excludeNpmPackages: [],
      },
    }),
  ],
};

