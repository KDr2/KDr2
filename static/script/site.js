function init_site() {
    var url = window.location.href;
    var domain = url.replace(/^\w+:\/\//, "").replace(/\/.*$/gi,"").toLowerCase();
    var page = url.replace(/^\w+:\/\/.*?\//i,"").replace(/#.*$/gi,"");
    var site_name = "KDr2.com";
    $("#site-name").text(site_name);
    if(page == "" || page == "/" || page == "index.html") {
        document.title = site_name;
        $("h1").text(site_name);
    }
    $("#sitesearch").val(domain);
}

function init_gat(){
    ga_cats['test'] = "TEST";
    ga_cats['donate'] = "DONATE";
    ga_cats['social'] = "SOCIAL";
    ga_spec['test-button']= [
        {
            'type' : ga_type.event_tracking,
            'arguments': {
                category: ga_cats.test,
                action: "click.button.test",
                //label: function(e) { return "FUNC-LABEL";}
                label: "DEFAULT_LABEL"
            },
            'events' : ['click', 'mouseover']
        }
    ];

    ga_spec['donate-link']= [
        {
            'type' : ga_type.event_tracking,
            'arguments': {
                category: ga_cats.donate,
                action: "link.header.click",
                label: "DEFAULT-LABEL"
            },
            'events' : ['click']
        }
    ];

    ga_spec['social-link']= [
        {
            'type' : ga_type.event_tracking,
            'arguments': {
                category: ga_cats.social,
                action: "header.click",
                label: "DEFAULT-LABEL"
            },
            'events' : ['click']
        }
    ];

    setup_ga('UA-45424100-1', 'kdr2.com');
    setup_simple_gat();
    $(".button_to_link").click(function(e){
        e.preventDefault();
        gat(e);
        var button = $(this);
        setTimeout(function(){
            button.parent("form").submit();
        }, 500);
    });
}

$(document).ready(function(){
    init_site();
    init_gat();
});
