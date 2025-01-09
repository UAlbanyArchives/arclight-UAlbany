window.addEventListener("DOMContentLoaded", function() {
    // Disable Turbo globally
    if (window.Turbo) {
        Turbo.session.drive = false;
    }

    // Function to get text content from HTML element string
    function getTextContent(htmlString) {
        const tempElement = document.createElement('div');
        tempElement.innerHTML = htmlString;
        return tempElement.textContent || tempElement.innerText;
    }

    function fetchData(retryCount = 0) {
        const daoGallery = document.querySelector(".daoGallery");
        const hyraxURI = document.querySelector("#hyraxURI");

        if (!daoGallery) {
            //console.error("Required element .daoGallery is not found in the DOM.");
            if (retryCount < 3) { // Retry up to 3 times
                //console.log(`Retrying... Attempt ${retryCount + 1}`);
                setTimeout(() => fetchData(retryCount + 1), 1000); // Retry after 1 second
            }
            return; // Exit if elements are missing
        }
        if (!hyraxURI) {
            console.error("Required element #hyraxURI is not found in the DOM.");
            if (retryCount < 3) { // Retry up to 3 times
                console.log(`Retrying... Attempt ${retryCount + 1}`);
                setTimeout(() => fetchData(retryCount + 1), 1000); // Retry after 1 second
            }
            return; // Exit if elements are missing
        }

        const storedURL = hyraxURI.getAttribute("href") + "&sort=system_create_dtsi+asc&format=json";
        const tmp = document.createElement('a');
        tmp.href = storedURL;
        const hyraxURL = "https://archives.albany.edu" + storedURL.split(tmp.host)[1];

        // Fetch request
        fetch(hyraxURL)
            .then(response => {
                if (!response.ok) {
                    throw new Error('Network response was not ok');
                }
                return response.json();
            })
            .then(data => {
                if (data['data'].length > 0) {
                    document.querySelector(".hyraxDaoDisplay").style.display = "block";
                    //document.querySelector(".defaultDaoDisplay").style.display = "none";

                    let count;
                    const thumbnails = document.querySelectorAll(".daoGallery .img-thumbnail");
                    count = thumbnails.length > 10 ? "9" : thumbnails.length.toString();

                    if (Number(data['meta']["pages"]["total_count"]) > 0) {
                        document.querySelector(".page-entries").innerHTML = `<strong>1</strong>-<strong>${count}</strong> of <strong>${data['meta']["pages"]["total_count"]}</strong>`;
                    }

                    for (let i = 0; i < data['data'].length; i++) {
                        if (i < 9) {
                            const thumbnail = hyraxURL.split("/catalog")[0] + data['data'][i]["attributes"]["thumbnail_path_ss"]["attributes"]["value"];
                            const titles = getTextContent(data["data"][i]["attributes"]["title"]);
                            const link = "https://archives.albany.edu/concern/" + data["data"][i]["type"].toString().toLowerCase() + "s/" + data["data"][i]["id"];
                            let url = link;

                            if (window.location.hostname.includes("lib-espy-ws-d101.its") && link.includes("://archives.albany.edu/")) {
                                const tmp2 = document.createElement('a');
                                tmp2.href = link;
                                url = window.location.protocol + "//" + window.location.hostname + link.split(tmp2.host)[1];
                            }

                            let thumb;
                            if (thumbnails[i]) {
                                thumb = thumbnails[i];
                            } else {
                                thumb = document.createElement('div');
                                thumb.className = 'img-thumbnail';
                                document.querySelector("#insertBefore").insertAdjacentElement('beforebegin', thumb);
                                thumb.innerHTML = `<a><i class='fas fa-file fa-5x thumbnail-placeholder'></i><img class='daoThumbnail' style='display: none;'></a>`;
                                thumb.innerHTML += "<p class='caption'><a></a></p>";
                            }

                            thumb.querySelector("a").setAttribute("href", url);
                            thumb.querySelector(".thumbnail-placeholder").style.display = "none";
                            const daoThumbnail = thumb.querySelector(".daoThumbnail");
                            daoThumbnail.setAttribute("src", thumbnail);
                            daoThumbnail.style.display = "block";
                            const captionLink = thumb.querySelector(".caption a");
                            captionLink.setAttribute("href", url);
                            captionLink.textContent = titles;

                            // Add metadata
                            const metadata = thumb.querySelector("dl") || document.createElement('dl');
                            thumb.appendChild(metadata);
                            if ("resource_type_tesim" in data["data"][i]["attributes"]) {
                                metadata.insertAdjacentHTML('beforeend', `<dt>Resource Type:</dt><dd>${data["data"][i]["attributes"]["resource_type_tesim"]["attributes"]["value"]}</dd>`);
                            }
                            if ("date_created_tesim" in data["data"][i]["attributes"]) {
                                metadata.insertAdjacentHTML('beforeend', `<dt>Date Created:</dt><dd>${data["data"][i]["attributes"]["date_created_tesim"]["attributes"]["value"]}</dd>`);
                            }
                            if ("extent_tesim" in data["data"][i]["attributes"]) {
                                metadata.insertAdjacentHTML('beforeend', `<dt>Duration:</dt><dd>${data["data"][i]["attributes"]["extent_tesim"]["attributes"]["value"]}</dd>`);
                            }
                            if ("description_tesim" in data["data"][i]["attributes"]) {
                                const description = data["data"][i]["attributes"]["description_tesim"]["attributes"]["value"];
                                const shortDescription = description.length > 265 ? description.substring(0, 250) + '...' : description;
                                metadata.insertAdjacentHTML('beforeend', `<dt>Description:</dt><dd>${shortDescription}</dd>`);
                            }
                        }
                    }

                    if (data['response']['docs'].length > 4) {
                        document.querySelector(".daoGallery").children[0].style.display = "block"; // Display the first child or adjust as needed
                    }
                    if (data['response']['docs'].length <= count) {
                        document.querySelector(".daoGalleryMore").style.display = "none";
                    }
                }
            })
            .catch(error => console.error('Error fetching data:', error));
    }

    fetchData(); // Initial call
});
