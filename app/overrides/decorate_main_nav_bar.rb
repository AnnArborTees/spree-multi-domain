Deface::Override.new(
	virtual_path: "spree/shared/_main_nav_bar",
	name:         "Adding store homepage link based on curernt store",
	replace_contents: "li#home-link",
	text: '<%= link_to Spree.t(:home), store_home_path %>'
	)
