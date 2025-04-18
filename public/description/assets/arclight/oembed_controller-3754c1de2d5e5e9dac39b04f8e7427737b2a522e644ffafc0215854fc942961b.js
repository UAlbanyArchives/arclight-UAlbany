import { Controller } from '@hotwired/stimulus'

export default class OembedController extends Controller {
  static values = {
    url: String
  }

  connect() {
    const loadedAttr = this.element.getAttribute('loaded')

    if (loadedAttr && loadedAttr === 'loaded') {
      return
    }

    fetch(this.urlValue)
      .then((response) => {
        if (response.ok) return response.text()
        throw new Error(`HTTP error, status = ${response.status}`)
      })
      .then((body) => {
        const oEmbedEndPoint = this.findOEmbedEndPoint(body)
        if (!oEmbedEndPoint || oEmbedEndPoint.length === 0) {
          console.warn(`No oEmbed endpoint found in <head> at ${this.urlValue}`)
          return
        }
        this.loadEndPoint(oEmbedEndPoint)
      }).catch(error => {
        console.error(error)
      })
  }

  // We are choosing not to make this class static so that downstream classes
  // can override it and access values to populate extraParams.
  // E.g. https://github.com/sul-dlss/vt-arclight/blob/main/app/javascript/controllers/sul_embed_controller.js
  findOEmbedEndPoint(body, extraParams = {}) { // eslint-disable-line class-methods-use-this
    // Parse out link elements so image assets are not loaded
    const template = document.createElement('template')
    template.innerHTML = body.match(/<link .*>/g).join('')

    // Look for a link element containing the oEmbed endpoint; bail out if none
    const endpoint = template.content.querySelector('link[rel="alternate"][type="application/json+oembed"]')
      ?.getAttribute('href')
    if (!endpoint) return ''

    // Serialize any extra params and append them to the endpoint
    const qs = new URLSearchParams(extraParams).toString()
    return `${endpoint}&${qs}`
  }

  loadEndPoint(oEmbedEndPoint) {
    fetch(oEmbedEndPoint)
      .then((response) => response.json())
      .then((json) => {
        this.element.innerHTML = json.html
        this.element.setAttribute('loaded', 'loaded')
      })
  }
};
