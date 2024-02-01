$(document).ready(function(){
    // Function to get text content from HTML element string
    function getTextContent(htmlString) {
        const tempElement = document.createElement('div');
        tempElement.innerHTML = htmlString;
        return tempElement.textContent || tempElement.innerText;
    }

	if ($(".daoGallery")[0]){
		$storedURL = $("#hyraxURI").attr("href") + "&sort=system_create_dtsi+asc&format=json"
		var tmp = document.createElement('a');
		tmp.href = $storedURL
		$hyraxURL = window.location.protocol + "//" + window.location.hostname + $storedURL.split(tmp.host)[1];
        $.ajax({
          type: "GET",
          dataType: 'json',
          url: $hyraxURL,
          success: function(data) {
            if (data['data'].length > 0) {
                $(".hyraxDaoDisplay").css("display", "block");
                $(".defaultDaoDisplay").css("display", "none");
                if ($(".daoGallery").children(".img-thumbnail")[0]) {
                    if ($(".daoGallery").children(".img-thumbnail").length > 10) {
                        $count = "9"
                    } else {
                        $count = $(".daoGallery").children(".img-thumbnail").length
                    }
                } else {
                    $count = "9"
                }
                if (Number(data['meta']["pages"]["total_count"]) > 0) {
                    $(".page-entries").append("<strong>1</strong>-<strong>" + $count + "</strong> of <strong>" + data['meta']["pages"]["total_count"] + "</strong>")
                }
                for (i = 0; i < data['data'].length; i++) {
                    if (i < 9 ){
                        $thumbnail = $hyraxURL.split("/catalog")[0] + data['data'][i]["attributes"]["thumbnail_path_ss"]["attributes"]["value"];
                        $dates = getTextContent(data["data"][i]["attributes"]["date_created_tesim"]["attributes"]["value"]);
                        $titles = getTextContent(data["data"][i]["attributes"]["title"]);
                        $link = "https://archives.albany.edu/concern/" + data["data"][i]["type"].toString().toLowerCase() + "s/" + data["data"][i]["id"];
                        if ( ( window.location.hostname.includes("lib-espy-ws-d101.its") ) && ( $link.includes("://archives.albany.edu/") ) ) {
				var tmp2 = document.createElement('a');
				tmp2.href = $link
				$url = window.location.protocol + "//" + window.location.hostname + $link.split(tmp2.host)[1];
			} else {
				$url = $link
			}

                        if ($(".daoGallery").children(".img-thumbnail")[i]){ 
                            $thumb = $(".daoGallery").children(".img-thumbnail:eq(" + i.toString() + ")");
                        } else {
                            $thumb = $("<div class='img-thumbnail'></div>").insertBefore("#insertBefore");
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
                        
                        if ("resource_type_tesim" in data["data"][i]["attributes"]) {
                            $metadata.append("<dt>Resource Type:</dt><dd>" + data["data"][i]["attributes"]["resource_type_tesim"]["attributes"]["value"] + "</dd>");
                        }
                        if ("date_created_tesim" in data["data"][i]["attributes"]) {
                            $metadata.append("<dt>Date Created:</dt><dd>" + data["data"][i]["attributes"]["date_created_tesim"]["attributes"]["value"] + "</dd>");
                        }
                        if ("extent_tesim" in data["data"][i]["attributes"]) {
                            $metadata.append("<dt>Duration:</dt><dd>" + data["data"][i]["attributes"]["extent_tesim"]["attributes"]["value"] + "</dd>");
                        }
                        if ("description_tesim" in data["data"][i]["attributes"]) {
                            if (data["data"][i]["attributes"]["description_tesim"]["attributes"]["value"].length > 265) {
                                $metadata.append("<dt>Description:</dt><dd>" + data["data"][i]["attributes"]["description_tesim"]["attributes"]["value"].substring(0,250)+'...' + "</dd>");
                            } else {
                                $metadata.append("<dt>Description:</dt><dd>" + data["data"][i]["attributes"]["description_tesim"]["attributes"]["value"] + "</dd>");
                            }
                        }
                    }
                }
                if (data['response']['docs'].length > 4) {
                    $(".daoGallery").children(".card").css("display", "block");
                }
                if (data['response']['docs'].length <= $count) {
                    $(".daoGalleryMore").css("cssText", "display: none;");
                }
            }
          }
        });
    }
});

