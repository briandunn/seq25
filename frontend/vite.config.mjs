import { defineConfig } from 'vite';
import { extensions, classicEmberSupport, ember } from '@embroider/vite';
import { babel } from '@rollup/plugin-babel';

export default defineConfig({
  plugins: [
    classicEmberSupport(),
    ember(),
    // extra plugins here
    babel({
      babelHelpers: 'runtime',
      extensions,
    }),
  ],
  server: {
    // Same-origin /songs, as in production where the host nginx proxies it.
    proxy: {
      '/songs': process.env.BACKEND_URL ?? 'http://localhost:3001',
    },
  },
});
