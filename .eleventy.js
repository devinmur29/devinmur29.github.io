module.exports = function(eleventyConfig) {
  // Copy static files directly
  eleventyConfig.addPassthroughCopy("css");
  eleventyConfig.addPassthroughCopy("assets");
  eleventyConfig.addPassthroughCopy("icon.png");
  eleventyConfig.addPassthroughCopy("index.html");
  eleventyConfig.addPassthroughCopy("posts/**/*.!(md)");

  // Create blog post collection
  eleventyConfig.addCollection("post", function(collectionApi) {
    return collectionApi.getFilteredByGlob("posts/**/index.md").sort((a, b) => b.date - a.date);
  });

  return {
    dir: {
      input: ".",        // everything relative to root
      includes: "_includes",
      output: "_site"    // output directory
    },
    passthroughFileCopy: true
  };
};
