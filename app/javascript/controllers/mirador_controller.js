import { Controller } from "@hotwired/stimulus"

// Import the shim that ensures Mirador is loaded onto the `window` object
import "mirador-shim";

export default class extends Controller {
  static values = {
    manifestUrl: String
  }

  connect() {
    const manifestUrl = this.manifestUrlValue;

    // Wait a tick to ensure Mirador is available in slow-loading environments
    setTimeout(() => {
      if (typeof window.Mirador === 'undefined') {
        console.error("Mirador is not available globally.");
        return;
      }

      window.Mirador.viewer({
      id: "mirador-viewer",
      state: {
        windows: {
          "window-1": {
            id: "window-1",
            canvasIndex: 0,
            manifestId: manifestUrl,
            view: "single",
            zoom: 3.5,     // Adjust to fit
            x: 0,
            y: 0
          }
        }
      },
      windows: [{
        manifestId: manifestUrl,
        windowId: "window-1",
        defaultView: 'single',
        sideBarOpenByDefault: false,
        defaultSideBarPanel: 'none'
      }],
      workspaceControlPanel: {
        enabled: false
      }
    });
    }, 0); // or increase to 50–100ms if you still see intermittent issues
  }
}
