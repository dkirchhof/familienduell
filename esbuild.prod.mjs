import esbuild from "esbuild";

const ctx = await esbuild.build({
  entryPoints: ["src/index.mjs"],
  outfile: "public/bundle.min.js",
  bundle: true,
  minify: true,
});
