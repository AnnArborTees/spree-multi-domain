module Spree
  module Api
    module ApiHelpers
      if defined? @@image_attributes
        @@image_attributes << :thumbnail
      end
    end
  end
end
