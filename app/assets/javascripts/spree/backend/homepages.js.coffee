window.thumbnail_for = (product) ->
  for image in product.master.images
    return image if image.thumbnail
  product.master.images[0]

$(document).ready ->
  window.productTemplate = Handlebars.compile($('#product_template').text())
  $('#homepage_products').sortable()
  $('#homepage_products').on "sortstop", (event, ui) ->
    $.ajax
      url: "/api/homepage_products/update",
      method: 'PUT',
      data:
        product_id: ui.item.data('product-id'),
        homepage_id: $('#homepage_id').val(),
        position: ui.item.index()

  if $('#homepage_id').length > 0
    $('#homepage_id').select2
      dropdownCssClass: "homepage_select_box",
      placeholder: 'Select a homepage',
      ajax:
        url: Spree.routes.search_admin_homepages,
        datatype: 'json',
        data: (term, page) ->
          per_page: 50,
          page: page,
          q:
            name_cont: term
        results: (data, page) ->
          results: data.map (r) ->
            id: r.id,
            text: r.name

  $('#homepage_id').on "change", (e) ->
    $('#edit_homepage_link').prop('href', "/admin/homepages/#{e.val}/edit")
    $('#edit_homepage_link').show()

    el = $('#homepage_products')
    $.ajax
      url: "/admin/homepages/#{e.val}/products"
      datatype: 'json'
      success: (data) ->
        el.empty()
        if data.length == 0
          $('#sorting_explanation').hide()
          $('#homepage_products').html(
            "<h4>" + Spree.translations.no_results + "</h4>"
          )
        else
          for product in data
            thumbnail = window.thumbnail_for(product)
            if thumbnail != undefined && thumbnail.small_url != undefined
              product.image = thumbnail.small_url
            el
              .append(productTemplate({ product: product }))
              .find('img')
              .css
                height: '120px'
                width: 'auto'
          $('#sorting_explanation').show()
