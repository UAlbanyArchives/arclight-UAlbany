# Pin npm packages by running ./bin/importmap

pin "application"
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
pin_all_from "app/javascript/controllers", under: "controllers"
pin "@github/auto-complete-element", to: "https://cdn.skypack.dev/@github/auto-complete-element"
pin "@popperjs/core", to: "https://ga.jspm.io/npm:@popperjs/core@2.11.6/dist/umd/popper.min.js"
pin "bootstrap", to: "https://ga.jspm.io/npm:bootstrap@5.3.2/dist/js/bootstrap.js"
pin "arclight", to: "arclight/arclight.js"
# TODO: We may be able to move these to a single importmap for arclight.
pin "arclight/oembed_controller", to: "arclight/oembed_controller.js"
pin "arclight/truncate_controller", to: "arclight/truncate_controller.js"
pin "displayHyraxDaos"
pin "grenander/search_sources_menu", to: "grenander/search_sources_menu.js"
