Spree::TaxonsController.class_eval do

  def show
    @taxon = Spree::Taxon.find_by_permalink!(params[:id])
    return unless @taxon

    @searcher = build_searcher(params.merge(:taxon => @taxon.id))
    @products = @searcher.retrieve_products
    @taxonomies = get_taxonomies
  end

  def accurate_title
    return super unless params[:action] == 'show'
    "#{@taxon.name} - #{current_store.title}"
  end

end
