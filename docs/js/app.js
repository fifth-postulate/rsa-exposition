(function(remark, MathJax){
  let slideshow = remark.create({
    sourceUrl: 'presentation.md'
  });
  
  
  // Setup MathJax
  MathJax.Hub.Config({
      tex2jax: {
          skipTags: ['script', 'noscript', 'style', 'textarea', 'pre']
      }
  });

  MathJax.Hub.Configured();
})(remark, MathJax);
