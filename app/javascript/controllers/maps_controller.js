import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["field", "latitude", "longitude", "zipcode"]

  connect() {
    if (typeof (google) != "undefined"){
      this.initializeMap()
    }
  }

  initializeMap() {
    this.autocomplete()
    console.log('init')
  }

  autocomplete() {
    if (this._autocomplete == undefined) {
      this._autocomplete = new google.maps.places.Autocomplete(this.fieldTarget, { types: ['geocode'] })
      this._autocomplete.setFields(['address_components', 'geometry', 'icon', 'name'])
      this._autocomplete.addListener('place_changed', this.locationChanged.bind(this))
    }
    return this._autocomplete
  }

  locationChanged() {
    let place = this.autocomplete().getPlace()

    if (!place.geometry) {
      // User entered the name of a Place that was not suggested and
      // pressed the Enter key, or the Place Details request failed.
      window.alert("No details available for input: '" + place.name + "'");
      return;
    }
    this.latitudeTarget.value = place.geometry.location.lat()
    this.longitudeTarget.value = place.geometry.location.lng()
    let zipCode = place.address_components.find((ac) => ac.types.includes('postal_code'))
    if (zipCode) { this.zipcodeTarget.value = zipCode.long_name }
  }

  clearCoordinates() {
    // Clear latitude, longitude and zipcode when the search field is emptied
    if (this.fieldTarget.value === "") {
      this.latitudeTarget.value = ""
      this.longitudeTarget.value = ""
      this.zipcodeTarget.value = ""
    }
  }

  preventSubmit(e) {
    if (e.key == "Enter") { e.preventDefault() }
  }
}