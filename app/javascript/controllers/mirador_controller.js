import { Controller } from "@hotwired/stimulus"

// Load Mirador
import "mirador";

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
          manifestId: manifestUrl,
          defaultView: 'single',
          sideBarOpenByDefault: false,
          defaultSideBarPanel: 'none'
        }],
        workspaceControlPanel: {
          enabled: false
        }
      });
    }
  }
}
