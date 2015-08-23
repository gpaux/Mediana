module Jekyll
  
  class WeightedPagesGenerator < Generator
    safe true

    def generate(site)
      site.config['weighted_pages'] = site.pages.sort_by { |a| 
        a.data['weight'] ? a.data['weight'] : site.pages.length }
    end

  end

end