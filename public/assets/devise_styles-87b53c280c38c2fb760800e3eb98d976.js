((function(){$(function(){var a;return $("#member_email").bind("ajax:success",function(b,c,d,e){return c===!1?($("#email_check").html("Email format is invalid."),$("#member_email").addClass("error"),a("#email_status","invalid")):($("#member_email").addClass("pass"),a("#email_status","valid"))}),$("#member_email").live("ajax:before",function(){if($(this).val()==="")return!1}),$("#member_email").focus(function(){return $("#email_check").empty(),$("#member_email").removeClass("error"),$("#member_email").removeClass("pass"),a("#email_status","new")}),$("#member_email").bind("ajax:beforeSend",function(){return a("#email_status","checking")}),$("#member_twitter").bind("ajax:success",function(b,c,d,e){return c===!1?($("#twitter_check").html("Invalid twitter username."),$("#member_twitter").addClass("error"),a("#twitter_status","invalid")):($("#member_twitter").addClass("pass"),a("#twitter_status","valid"))}),$("#member_twitter").live("ajax:before",function(){if($(this).val()==="")return!1}),$("#member_twitter").focus(function(){return $("#twitter_check").empty(),$("#member_twitter").removeClass("error"),$("#member_twitter").removeClass("pass"),a("#twitter_status","new")}),$("#member_twitter").bind("ajax:beforeSend",function(){return a("#twitter_status","checking")}),$("#member_github").bind("ajax:success",function(b,c,d,e){return c===!1?($("#github_check").html("Invalid github username."),$("#member_github").addClass("error"),a("#github_status","invalid")):($("#member_github").addClass("pass"),a("#github_status","valid"))}),$("#member_github").live("ajax:before",function(){if($(this).val()==="")return!1}),$("#member_github").focus(function(){return $("#github_check").empty(),$("#member_github").removeClass("error"),$("#member_github").removeClass("pass"),a("#github_status","new")}),$("#member_github").bind("ajax:beforeSend",function(){return a("#github_status","checking")}),$("#member_blogrss").bind("ajax:success",function(b,c,d,e){return c===!1?($("#blogrss_check").html("Invalid blog url."),$("#member_blogrss").addClass("error"),a("#blogrss_status","invalid")):($("#member_blogrss").addClass("pass"),a("#blogrss_status","valid"))}),$("#member_blogrss").live("ajax:before",function(){if($(this).val()==="")return!1}),$("#member_blogrss").focus(function(){return $("#blogrss_check").empty(),$("#member_blogrss").removeClass("error"),$("#member_blogrss").removeClass("pass"),a("#blogrss_status","new")}),$("#member_blogrss").bind("ajax:beforeSend",function(){return a("#blogrss_status","checking")}),a=function(a,b){return $(a).removeClass("new valid invalid checking"),$(a).addClass(b)}})})).call(this);