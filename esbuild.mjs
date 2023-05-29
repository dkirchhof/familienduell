import esbuild from "esbuild";

const watchPlugin = {
  name: "watch-plugin",
  setup(build) {
    build.onStart(() => console.log(`Build starting: ${new Date().toLocaleString()}`));
    build.onEnd(result => {
      if (result.errors.length > 0) {
        console.log(`Build finished with errors: ${new Date().toLocaleString()}`);
      } else {
        console.log(`Build finished: ${new Date().toLocaleString()}`);
      }
    });
  }
}

const ctx = await esbuild.context({
  entryPoints: ["src/client/index.mjs"],
  outfile: "public/bundle.js",
  bundle: true,
  sourcemap: true,
  plugins: [watchPlugin],
});

await ctx.watch();

let { host, port } = await ctx.serve({
  port: 7777,
  servedir: "./public",
})

console.log(`Serve app on ${host}:${port}`);
