$.fn.storeAutocomplete = function() {
  this.select2({
    minimumInputLength: 1,
    multiple: true,
    initSelection: function(element, callback) {
      $.get(Spree.routes.store_search, { ids: element.val() }, function(data) {
        callback(data)
      })
    },
    ajax: {
      url: Spree.routes.store_search,
      datatype: 'json',
      data: function(term, page) {
        return { q: term }
      },
      results: function(data, page) {
        return { results: data }
      }
    },
    formatResult: function(store) {
      return store.store.name;
    },
    formatSelection: function(store) {
      return store.store.name;
    },
    id: function(store) {
      return store.store.id
    }
  });
}

$(document).ready(function () {
  $('.store_picker').storeAutocomplete();

  $('#store_select').select2({
    dropdownAutoWidth: true
  });
  $('#store_select').on('select2-selected', function(e) {
    if (e.choice) {
      var ids = $(e.choice.element[0]).data('taxonomies');
      var odd = true;

      $('tr[data-hook="taxonomies_row"]').each(function() {
        var id = parseInt($(this).attr('id').match(/\d+/)[0]);
        var shown = false;

        for (var i = 0; i < ids.length; i++) {
          if (ids[i] == id) {
            $(this).show();
            $(this).removeClass('even');
            $(this).removeClass('odd');
            $(this).addClass(odd ? 'odd' : 'even');
            odd = !odd;
            shown = true;
          } else if (!shown) {
            $(this).hide();
          }
        }
      });
    }
  });
})
