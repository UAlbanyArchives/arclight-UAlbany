window.addEventListener('load', function() {

    // URLs for Search form get request
    var allSearchURL = "https://archives.albany.edu/search";
    var arclightSearchURL = "http://archives.albany.edu/collections/catalog";
    var hyraxSearchURL = "https://archives.albany.edu/repository/catalog/";

    //query selector for search form
    var searchForm = document.getElementsByClassName('allSearch');
    var searchPlaceholder = document.getElementById('params-q');
    var currentSelection = document.getElementById('currentSelection');


    //button query selectors
    var allSearchBtn = document.getElementById('allSearch')
    var arclightBtn = document.getElementById('arclightSearch');
    var hyraxBtn = document.getElementById('hyraxSearch');


    //
    //
    // Event Listeners - Search options change
    //
    //

    //Search all
    allSearchBtn.addEventListener('click', function() {
        searchForm[0].action = allSearchURL;
        searchPlaceholder.placeholder = "Search everything...";
        currentSelection.textContent = "Everything";
    });

    //Search Arclight
    arclightBtn.addEventListener('click', function() {
        searchForm[0].action = arclightSearchURL;
        searchPlaceholder.placeholder = "Search all collection records...";
        currentSelection.textContent = "Collections";
    });

    //Search Hyrax
    hyraxBtn.addEventListener('click', function() {
        searchForm[0].action = hyraxSearchURL;
        searchPlaceholder.placeholder = "Search only online digital content...";
        currentSelection.textContent = "Digital Selections";
    });


}, false);


window.addEventListener('load', function() {
    $('#toggleSearch').click( function() {
        $("#searchSub").toggleClass("fixedSubnav");
    } );

    $(window).scroll(function () {
        var top_offset = $(window).scrollTop();
        if (top_offset == 0) {
            $('#searchSub').removeClass('fixedSubnav');
         }
    } );
});

