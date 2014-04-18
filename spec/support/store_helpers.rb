module StoreHelpers
  def display_product_called(name)
    have_selector('a.info[itemprop=name]', text: name)
  end
end