function _url(){
    var full_url=window.location.href;
    var ret = full_url.replace(/^\w+:\/\/.*?\//i,"").replace(/#.*$/gi,"");
    if(ret!="")return ret;
    return "index.html";
}

var disqus_shortname = 'mindniche';
var disqus_identifier = _url();

/* * * DON'T EDIT BELOW THIS LINE * * */
(function() {
    var dsq = document.createElement('script'); dsq.type = 'text/javascript'; dsq.async = true;
    dsq.src = '//' + disqus_shortname + '.disqus.com/embed.js';
    (document.getElementsByTagName('head')[0] || document.getElementsByTagName('body')[0]).appendChild(dsq);
})();
