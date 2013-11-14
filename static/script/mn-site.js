function init_mn_site() {
    var url = window.location.href;
    var domain = url.replace(/^\w+:\/\//, "").replace(/\/.*$/gi,"").toLowerCase();
    var page = url.replace(/^\w+:\/\/.*?\//i,"").replace(/#.*$/gi,"");
    var site_name = "KDr2.com";
    if(domain=="mindniche.com") {
        site_name = "Mind Niche";
    }
    $("#site-name").text(site_name);
    if(page == "" || page == "/" || page == "index.html") {
        document.title = site_name;
        $("h1").text(site_name);
    }
    $("#sitesearch").val(domain);
}

$(document).ready(init_mn_site);
