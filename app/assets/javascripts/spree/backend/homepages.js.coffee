$(document).ready ->
  window.productTemplate = Handlebars.compile($('#product_template').text())
  $('#homepage_products').sortable()
  $('#homepage_products').on "sortstop", (event, ui) ->
    $.ajax
      url: Spree.routes.classifications_api,
      method: 'PUT',
      data:
        product_id: ui.item.data('product-id'),
        homepage_id: $('#homepage_id').val(),
        position: ui.item.index()

  if $('#homepage_id').length > 0
    $('#homepage_id').select2
      dropdownCssClass: "homepage_select_box",
      placeholder: Spree.translations.find_a_homepage,
      ajax:
        url: Spree.routes.homepages_search,
        datatype: 'json',
        data: (term, page) ->
          per_page: 50,
          page: page,
          q:
            name_cont: term
        results: (data, page) ->
          more = page < data.pages
          results: data['homepages'],
          more: more
      formatResult: (homepage) ->
        homepage.pretty_name
      formatSelection: (homepage) ->
        homepage.pretty_name

  $('#homepage_id').on "change", (e) ->
    el = $('#homepage_products')
    $.ajax
      url: Spree.routes.homepage_products_api,
      data:
        id: e.val
      success: (data) ->
        el.empty()
        if data.products.length == 0
          $('#sorting_explanation').hide()
          $('#homepage_products').html("<h4>" + Spree.translations.no_results + "</h4>")
        else
          for product in data.products
            if product.master.images[0] != undefined && product.master.images[0].small_url != undefined
              product.image = product.master.images[0].small_url
            el.append(productTemplate({ product: product }))
          $('#sorting_explanation').show()


