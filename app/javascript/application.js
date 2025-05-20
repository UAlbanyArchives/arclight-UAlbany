// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "mirador-shim"
import "controllers"
import bootstrap from "bootstrap"
import githubAutoCompleteElement from "@github/auto-complete-element"
import Blacklight from "blacklight"
import "arclight"

import "grenander/search_sources_menu"
import "displayHyraxDaos";

/* Searching within a collection should not yield results */
/* grouped by collection. */

/*$('form.search-query-form').submit(() => {
if ($('select#within_collection').val()) {
  $('input#group').remove();
}
});*/

/* loads Contact modal */
(function () {
  'use strict';

  // Select links that should trigger the modal
  var list = document.querySelectorAll('a[href*="libwizard.com"], a[href*="apps.library.albany.edu/forms/"]');
  for (var i = 0; i < list.length; ++i) {
    list[i].classList.add('modal-form');
  }

  const buttons = document.querySelectorAll('.modal-form');

  if (!(buttons.length > 0)) {
    return;
  } else {
    Array.from(buttons).forEach(btn => {
      btn.addEventListener('click', (event) => {
        event.preventDefault(); // Prevent the default link behavior

        // Find the default modal in Blacklight
        const dialog = document.getElementById('blacklight-modal');
        const modalContent = dialog.querySelector('.modal-content');

        // Check if modalContent exists
        if (modalContent) {
          // Clear any existing iframe or content
          modalContent.innerHTML = `
            <div class="modal-header">
              <h5 class="modal-title">Contact Us</h5>
              <button type="button" class="btn-close" onclick="document.getElementById('blacklight-modal').close();"></button>
            </div>
            <div class="modal-body">
              <iframe class="modal-iframe" src="${btn.href}" style="width: 100%; height: 400px;" frameborder="0"></iframe>
            </div>
            <div class="modal-footer">
              <button type="button" class="btn btn-secondary" onclick="document.getElementById('blacklight-modal').close();">Close</button>
            </div>
          `;

          // Show the modal
          dialog.showModal();
        } else {
          console.error('Modal content not found.');
        }
      });
    });
  }

  // Optional: Close the modal when clicking outside
  const dialog = document.getElementById('blacklight-modal');
  dialog.addEventListener('click', (event) => {
    if (event.target === dialog) {
      dialog.close(); // Close the modal
    }
  });
})();
