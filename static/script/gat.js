/*
 * Google Analytics Tools
 * by KDr2
 *
 * add below line to you page:
 * <script src="//www.google-analytics.com/cx/api.js"></script>
 *
 */

var _gaq = _gaq || [];

var ga_type = {
    campaign: 0,
    custom_variable: 1,
    ecommerce: 2,
    event_tracking: 3
};

var ga_action = {};

ga_action[ga_type.campaign] = function (arg_obj) {
    //TODO
};

ga_action[ga_type.custom_variable] = function (arg_obj) {
    if(typeof _gaq !== "undefined") {
        _gaq.push(['_setCustomVar',
                   arg_obj.index, // slot,  required
                   arg_obj.name,  // required
                   arg_obj.value, // required
                   arg_obj.scope  // session-level, optional
                  ]);
    }
};

ga_action[ga_type.ecommerce] = function (arg_obj) {
    //TODO
    if(typeof _gaq !== "undefined") {
        // _addTrans
        // _addItem
        // _trackTrans
    }
};

ga_action[ga_type.event_tracking] = function (arg_obj) {
    if(typeof _gaq !== "undefined") {
        _gaq.push(['_trackEvent',
                   arg_obj.category,        // require
                   arg_obj.action,          // require
                   arg_obj.label,           // optional
                   arg_obj.value,           // optional
                   arg_obj.non_interaction  // optional
                  ]);
    }
};

var all_events = [
    "blur", "change", "click", "dblclick",
    "focus", "focusin", "focusout", "hover",
    "keydown", "keypress", "keyup",
    "mousedown", "mouseenter", "mouseleave",
    "mousemove", "mouseout", "mouseover", "mouseup",
    "resize", "scroll", "select", "submit"
];

var ga_cats = {};
var ga_spec = {};

function gat_get_ga_attrs(node){
    var ret = {};
    var r = /^data-ga[_-]/i;
    $.each($(node)[0].attributes, function(index, attr) {
        var name = attr.name;
        if(r.test(name)) {
            ret[name.replace(r, '')] = attr.value;
        }
    });
    return ret;
}

function gat_expand_arguments(arguments, event) {
    var ret = {};
    for(var key in arguments) {
        if(typeof(arguments[key]) === 'function') {
            ret[key] = arguments[key](event);
        } else {
            ret[key] = arguments[key];
        }
    }
    return ret;
}

// public API
/*
 * spec <- ga_attrs <- event.data <- opt_data
 *
 */

function gat(event, gaid, opt_data, callback) {
    if(!gaid) {
        gaid = $(event.currentTarget).attr("data-ga-id");
    }
    var info_array = ga_spec[gaid];
    if(!info_array) return;
    for(var i in info_array){
        var target_events = info_array[i]['events'] || [];
        if(target_events.indexOf(event.type) < 0) continue;
        var arguments = info_array[i]['arguments'] || {};

        // merge arguments
        var ga_attrs = gat_get_ga_attrs($(event.currentTarget));
        arguments = $.extend({}, arguments, ga_attrs);

        if(event.data) {
            arguments = $.extend({}, arguments, event.data);
        }
        if(typeof(opt_data) === 'object') {
            arguments = $.extend({}, arguments, opt_data);
        }
        arguments = gat_expand_arguments(arguments, event);
        var ga_func = ga_action[info_array[i]['type']];
        ga_func(arguments);
    }
    if(typeof(callback) == "function"){
        setTimeout(callback, 500);
    }
}

function gat_handler(_gaid, opt_data) {
    return function(e){
        var gaid = _gaid;
        var node = $(e.currentTarget);

        if(!gaid) {
            gaid = node.attr("data-ga-id");
        }
        // deal link jumping to other page
        var href = null;
        var is_link = (node.prop("tagName").toLowerCase() == "a");
        if(is_link){
            var target = node.attr("target");
            if(target && target.toLowerCase() == "_blank"){
                is_link = false;
            }
        }
        if(is_link){
            href = node.attr("href");
            is_link = (href && !href.match(/^#/));
        }
        if(is_link && e.type == "click"){ // click a link
            e.preventDefault();
            gat(e, gaid, opt_data, function(){
                window.location.href = href;
            });
        } else {
            gat(e, gaid, opt_data);
        }
    };
}


function setup_simple_gat() {
    var simple_handler = gat_handler();
    for(var i in all_events) {
        $(".gat-" + all_events[i]).on(all_events[i], simple_handler);
    }
}

function setup_ga(gid, domain){
    _gaq.push(['_setAccount', gid]);
    _gaq.push(['_setDomainName', domain]);
    _gaq.push(['_setAllowLinker', true]);
    _gaq.push(['_trackPageview']);
    
    (function() {
        var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
        ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
        var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
    })();
}
