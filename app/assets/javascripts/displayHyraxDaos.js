$( document ).on('turbolinks:load', function() {
	if ($(".daoGallery")[0]){
        $root = "http://lib-espy-ws-p101.its.albany.edu"
        $hyraxURL = $root + "/catalog?f[archivesspace_record_tesim][]=" + $(".daoGallery").attr("id") + "&format=json";
        $.ajax({
          type: "GET",
          dataType: 'json',
          url: $hyraxURL,
          success: function(data) {
            if ($(".daoGallery").children(".img-thumbnail").length > 10) {
                $count = "9" 
            } else {
                $count = $(".daoGallery").children(".img-thumbnail").length
            }
            $(".page-entries").append("<strong>1</strong>-<strong>" + $count + "</strong> of <strong>" + data['response']["pages"]["total_count"] + "</strong>")
            for (i = 0; i < data['response']['docs'].length; i++) {
                if (i < 10 ){
                    $thumbnail = $root + data['response']['docs'][i]["thumbnail_path_ss"];
                    $dates = data['response']['docs'][i]["date_created_tesim"];
                    $titles = data['response']['docs'][i]["title_tesim"];
                    $url = "http://lib-espy-ws-p101.its.albany.edu/concern/" + data['response']['docs'][i]["has_model_ssim"].toString().toLowerCase() + "s/" + data['response']['docs'][i]["id"];
                    
                    if ($(".daoGallery").children(".img-thumbnail")[i]){ 
                        $thumb = $(".daoGallery").children(".img-thumbnail:eq(" + i.toString() + ")")
                        
                        $thumb.children("a").attr("href", $url);
                        $thumb.find(".placeholder").css("display", "none");
                        $thumb.find(".daoThumbnail").attr("src", $thumbnail);
                        $thumb.find(".daoThumbnail").css("display", "block");
                        $thumb.find(".caption").children("a").attr("href", $url);
                        $thumb.find(".caption").children("a").text($titles);
                        $thumb.append("<dl></dl>");
                        $metadata = $thumb.find("dl")
                        
                        if ("resource_type_tesim" in data['response']['docs'][i]) {
                            $metadata.append("<dt>Resource Type:</dt><dd>" + data['response']['docs'][i]["resource_type_tesim"][0] + "</dd>");
                        }
                        if ("date_created_tesim" in data['response']['docs'][i]) {
                            $metadata.append("<dt>Date Created:</dt><dd>" + data['response']['docs'][i]["date_created_tesim"][0] + "</dd>");
                        }
                        if ("extent_tesim" in data['response']['docs'][i]) {
                            $metadata.append("<dt>Duration:</dt><dd>" + data['response']['docs'][i]["extent_tesim"][0] + "</dd>");
                        }
                        if ("description_tesim" in data['response']['docs'][i]) {
                            if (data['response']['docs'][i]["description_tesim"][0].length > 265) {
                                $metadata.append("<dt>Description:</dt><dd>" + data['response']['docs'][i]["description_tesim"][0].substring(0,250)+'...' + "</dd>");
                            } else {
                                $metadata.append("<dt>Description:</dt><dd>" + data['response']['docs'][i]["description_tesim"][0] + "</dd>");
                            }
                        }
                    }
                }
            }
            if (data['response']['docs'].length > 4) {
                $(".daoGallery").children(".card").css("display", "block");
            }
            if (data['response']['docs'].length > $(".daoGallery").children(".img-thumbnail").length) {
                $(".daoGalleryMore").css("cssText", "display: inline-block !important");
            }
          }
        });
    }
});
