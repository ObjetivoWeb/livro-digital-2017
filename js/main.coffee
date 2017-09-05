---
---

window.$ = (selector) -> document.querySelectorAll selector
window._ = (nodeList) -> Array.prototype.slice.call nodeList

loadPhotoset = (flickr_id, callback) ->
	api_url = 'https://api.flickr.com/services/rest/?method=flickr.photosets.getPhotos&api_key=5c249699ea647bc35a82241524a98d04&photoset_id=' +
		flickr_id +
		'&user_id=131087492%40N07&format=json&nojsoncallback=1'
	HTTP.get api_url, ( data ) ->
		callback JSON.parse( data ).photoset.photo

photoURL = (p) -> 'https://farm' + p.farm + '.staticflickr.com/' + p.server + '/' + p.id + '_' + p.secret + '.jpg'

turmas = _( $ '.post-section' )

turmas.forEach (turma) ->
	loadPhotoset turma.getAttribute( 'data-flickr-id' ), (photos) ->
		photos.forEach (p) ->
			imgContainer = turma.querySelector '[data-pic-title="' + p.title + '"]'
			if imgContainer
				imgContainer.innerHTML = '<img src="' + photoURL(p) + '" alt="' + p.title.replace( '-', ' ' ) + '">'
				imgContainer.parentNode.classList.add 'has-flicker-image'

cover = $( '.data-img' )[0]
if cover
	pic_title = cover.getAttribute 'data-pic-title'
	loadPhotoset cover.getAttribute( 'data-flickr-id' ), (photos) ->
		photos.some (p) ->
			return false if not (pic_title is p.title)
			cover.innerHTML = '<img src="' + photoURL(p) + '" alt="' + p.title.replace( '-', ' ' ) + '">'
			true
