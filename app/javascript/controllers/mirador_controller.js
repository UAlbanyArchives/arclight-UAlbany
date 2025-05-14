import { Controller } from "@hotwired/stimulus"

// Ensure that Mirador is loaded properly
import "mirador"; // This will make Mirador available in the current file scope

export default class extends Controller {
  static values = {
    manifestUrl: String
  }

  connect() {
    //console.log("Mirador controller connected");

    const manifestUrl = this.manifestUrlValue;
    //console.log("Manifest URL:", manifestUrl);

    // Make sure Mirador is available on the window object globally
    if (typeof window.Mirador === 'undefined') {
      console.error("Mirador is not available globally.");
    } else {
      //console.log("Mirador is available globally.");
      window.Mirador.viewer({
        id: "mirador-viewer",
        windows: [{
          manifestId: manifestUrl
        }]
      });
    }
  }
}
