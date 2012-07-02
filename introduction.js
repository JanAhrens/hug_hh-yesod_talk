$(function() {
  $.deck('.slide', {
    selectors: {
      container: 'body > article'
    },
    keys: {
      goto: -1
    }
  });

  Modernizr.addTest('pointerevents',function(){
    return document.documentElement.style.pointerEvents === '';
  });
});
