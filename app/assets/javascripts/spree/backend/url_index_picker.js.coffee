$(document).ready ->
	picker = $('#url-index-picker')
	unless picker
		return
	url_space = $('#url-index-ex-space')
	code_field = $('#code-field')

	picker.attr 'style', 'width: 50px'

	url_space.text 'example.com/stores'
	sub = []
	sub[0] = $ '<span>', text: 'store0'
	sub[1] = $ '<span>', text: 'store1'
	sub[2] = $ '<span>', text: 'store2'
	for s, i in sub
		url_space.append $('<span>', id: 'slash-'+i, text: '/')
		url_space.append s

	last_slash = $('#slash-'+(sub.length-1))

	current = null
	select_color = '#FF8811'

	set_current = (num) ->
		if isNaN num then return
		greater = false
		if num >= sub.length
			num = sub.length-1
			greater = true
		if num < 0
			num = 0

		if current
			sub[current].text 'store'+current
			sub[current].attr 'style', ''
			sub[current].attr 'id', ''
			last_slash.text('/')
		last_slash.text '/*/' if greater

		if sub[num] 
			sub[num].text code_field.val()
			sub[num].attr 'style', 'color: '+select_color
			sub[num].attr 'id', 'current-url-pos'
		current = num

	set_current picker.val()

	on_picker_change = (e) ->
		if picker.val() < 0 or !parseInt(picker.val())
			picker.val(0)
		set_current picker.val()

	picker.keyup on_picker_change
	picker.change on_picker_change

	on_code_field_change = (e) ->
		$('#current-url-pos').text code_field.val()

	code_field.keyup on_code_field_change
	code_field.change on_code_field_change
