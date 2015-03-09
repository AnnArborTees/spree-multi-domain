$(document).ready ->
  $('#taxon_id').off 'change'
  $('#taxon_id').on 'change', (e) ->
    el = $('#taxon_products')
    $.ajax
      url: Spree.routes.taxon_products_api,
      data:
        id: e.val
      success: (data) ->
        el.empty()
        if data.products.length == 0
          $('#sorting_explanation').hide()
          $('#taxon_products').html("<h4>" + Spree.translations.no_results + "</h4>")
        else
          for product in data.products
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
