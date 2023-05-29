import esbuild from "esbuild";

const ctx = await esbuild.build({
  entryPoints: ["src/client/index.mjs"],
  outfile: "public/bundle.js",
  bundle: true,
  minify: true,
});
