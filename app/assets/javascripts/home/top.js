
function init() {
	//how to pass info to params when enter pushed in window
	//https://code-examples.net/ja/q/c3902c
	var input = document.getElementById('search');
	var autocomplete = new google.maps.places.Autocomplete(input);
	var location_being_changed = true;
	autocomplete.addListener('place_changed', function() {
		location_being_changed = false;
		var place = autocomplete.getPlace();
		var lat = place.geometry.location.lat();
		var lng = place.geometry.location.lng();
		//alert(`lat: ${lat}\nlng: ${lng}`);
		document.getElementById('lat').value = lat;
		document.getElementById('lng').value = lng;
		if (!place.geometry) {
			window.alert("Autocomplete's returned place contains no geometry");
			return;
		}
	});

	//when a key is pushed
	google.maps.event.addDomListener(input, 'keydown', function (e) {
			//13 is enter key
		    if (e.keyCode === 13) {
		    	//if enter key is used to select autocomplete candidates
		        if (location_being_changed) {
		        	//prevents to submit
		            e.preventDefault();
		            e.stopPropagation();
		        }
		    } else {
		        // means the user is probably typing
		        location_being_changed = true;
		    }
		}
	);
}