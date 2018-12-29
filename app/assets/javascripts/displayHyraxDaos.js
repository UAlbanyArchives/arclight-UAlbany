$(document).ready(function(){
	if ($(".daoGallery")[0]){
		$hyraxURL = $("#hyraxURI").attr("href") + "&format=json"
        $.ajax({
          type: "GET",
          dataType: 'json',
          url: $hyraxURL,
          success: function(data) {
            if ($(".daoGallery").children(".img-thumbnail")[0]) {
				if ($(".daoGallery").children(".img-thumbnail").length > 10) {
					$count = "9"
				} else {
					$count = $(".daoGallery").children(".img-thumbnail").length
				}
            } else {
                $count = "9"
            }
			if (Number(data['response']["pages"]["total_count"]) > 0) {
	            $(".page-entries").append("<strong>1</strong>-<strong>" + $count + "</strong> of <strong>" + data['response']["pages"]["total_count"] + "</strong>")
            }
			for (i = 0; i < data['response']['docs'].length; i++) {
                if (i < 9 ){
                    $thumbnail = $hyraxURL.split("/catalog")[0] + data['response']['docs'][i]["thumbnail_path_ss"];
                    $dates = data['response']['docs'][i]["date_created_tesim"];
                    $titles = data['response']['docs'][i]["title_tesim"];
                    $url = "https://archives.albany.edu/concern/" + data['response']['docs'][i]["has_model_ssim"].toString().toLowerCase() + "s/" + data['response']['docs'][i]["id"];
                    
                    if ($(".daoGallery").children(".img-thumbnail")[i]){ 
                        $thumb = $(".daoGallery").children(".img-thumbnail:eq(" + i.toString() + ")");
                    } else {
						$thumb = $("<div class='img-thumbnail'></div>").prependTo(".daoGallery");
						$thumb.append("<a><i class='fa fa-file-o fa-5x fa-5x placeholder'></i><img class='daoThumbnail'></a>");
						$thumb.append("<p class='caption'><a></a></p>");
					}
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
            if (data['response']['docs'].length > 4) {
                $(".daoGallery").children(".card").css("display", "block");
            }
            if (data['response']['docs'].length > $count) {
                $(".daoGalleryMore").css("cssText", "display: inline-block !important");
            }
          }
        });
    }
});
