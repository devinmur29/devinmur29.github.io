const yaml = require("js-yaml");

module.exports = function(eleventyConfig) {
  // Support YAML data files in _data/
  eleventyConfig.addDataExtension("yaml", contents => yaml.load(contents));
  eleventyConfig.addDataExtension("yml", contents => yaml.load(contents));
  // Copy static files directly
  eleventyConfig.addPassthroughCopy("css");
  eleventyConfig.addPassthroughCopy("assets");
  eleventyConfig.addPassthroughCopy("fonts");
  eleventyConfig.addPassthroughCopy("js");
  eleventyConfig.addPassthroughCopy("icon.png");
  eleventyConfig.addPassthroughCopy("posts/**/*.!(md)");

  // Create blog post collection
  eleventyConfig.addCollection("post", function(collectionApi) {
    return collectionApi.getFilteredByGlob("posts/**/index.md").sort((a, b) => b.date - a.date);
  });

  return {
    dir: {
      input: ".",        // everything relative to root
      includes: "_includes",
      data: "_data",
      output: "_site"    // output directory
    },
    passthroughFileCopy: true
  };
};
