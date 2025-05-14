// app/javascript/controllers/application.js
import { Application } from "@hotwired/stimulus"
import MiradorController from "./mirador_controller"  // Import the Mirador controller

const application = Application.start()

// Configure Stimulus development experience
application.debug = false
window.Stimulus = application

// Register the Mirador controller
application.register("mirador", MiradorController)

export { application }
