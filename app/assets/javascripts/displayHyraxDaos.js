$( document ).on('turbolinks:load', function() {
	if ($(".daoGallery")[0]){
        $root = "http://lib-espy-ws-p101.its.albany.edu"
        $hyraxURL = $root + "/catalog?f[archivesspace_record_tesim][]=" + $(".daoGallery").attr("id") + "&format=json";
        $.ajax({
          type: "GET",
          dataType: 'json',
          url: $hyraxURL,
          success: function(data) {
            for (i = 0; i < data['response']['docs'].length; i++) {
                $thumbnail = $root + data['response']['docs'][i]["thumbnail_path_ss"];
                $dates = data['response']['docs'][i]["date_created_tesim"];
                $titles = data['response']['docs'][i]["title_tesim"];
                $url = "http://lib-espy-ws-p101.its.albany.edu/concern/" + data['response']['docs'][i]["has_model_ssim"].toString().toLowerCase() + "s/" + data['response']['docs'][i]["id"];
                
                if ($(".daoGallery").children(".img-thumbnail")[i]){ 
                    $thumb = $(".daoGallery").children(".img-thumbnail:eq(" + i.toString() + ")")
                    
                    $thumb.children("a").attr("href", $url);
                    $thumb.children("a").find(".placeholder").css("display", "none");
                    $thumb.children("a").find(".daoThumbnail").attr("src", $thumbnail);
                    $thumb.children("a").find(".daoThumbnail").css("display", "block");
                    $thumb.children("a").find(".caption").text($titles)
                }
            }
          }
        });
    }
});
