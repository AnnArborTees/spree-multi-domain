Spree::Api::TaxonsController.class_eval do
  def index
    if taxonomy
      @taxons = taxonomy.root.children
    else
      if params[:ids]
        @taxons = Spree::Taxon.accessible_by(current_ability, :read).where(id: params[:ids].split(','))
      else
        @taxons = Spree::Taxon.accessible_by(current_ability, :read).order(:taxonomy_id, :lft)

        if params[:store_ids] && !params[:store_ids].empty?
          @taxons = @taxons.joins(:taxonomy).merge(
            Spree::Taxonomy
              .joins(:stores)
              .where(spree_stores: { id: params[:store_ids] })
          )
        end

        @taxons = @taxons.ransack(params[:q]).result
      end
    end

    @taxons = @taxons.page(params[:page]).per(params[:per_page])
    respond_with(@taxons)
  end
end
