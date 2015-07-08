class Beverage

  attr_accessor :brewery, :name, :abv, :ibu, :style, :id, :hash

  def initialize
    @brewery =""
    @name = ""
    @abv = ""
    @ibu = ""
    @style = ""
    @id = ""
    @hash = Hash.new
  end

end

class Search

  attr_accessor :user_beer, :abvs, :ibus, :styles, :chosen_ones

  def get_data(beer_name)
    brewery_db = BreweryDB::Client.new do |config|
      config.api_key = "4f7bf24d4106c5da74ca6a05b276a883"
    end
    beer_in = Beverage.new
    first_fifty = brewery_db.beers.all(name: "#{beer_name}").first(1)
    result = (first_fifty[0]).to_h
    beer_in.name = result["id"]
    beer_in.name = result["name"]
    beer_in.abv = result["abv"].to_f
    beer_in.ibu = result["ibu"].to_i
    beer_in.style = result["style"]["id"]
    self.user_beer = beer_in
  end

  def smart_search
    brewery_db = BreweryDB::Client.new do |config|
      config.api_key = "4f7bf24d4106c5da74ca6a05b276a883"
    end
    self.chosen_ones = []
    ibu_low = (self.user_beer.ibu.to_i - 1)
    ibu_high = (self.user_beer.ibu.to_i + 1)
    abv_low = (self.user_beer.abv.to_f - 0.1)
    abv_high = (self.user_beer.abv.to_f + 0.1)
    while self.chosen_ones.size <= 10
      result = brewery_db.beers.all(abv: "#{abv_low},#{abv_high}", ibu: "#{ibu_low},#{ibu_high}", styleId: "#{self.user_beer.style}", withBreweries: "Y").first(20)
      result.each do |x|
        beer_in = Beer.new
        hash = x.to_h
        beer_in.id = hash["id"]
        beer_in.name = hash["name"]
        beer_in.abv = hash["abv"]
        beer_in.ibu = hash["ibu"]
        style = hash["style"]
        unless style.nil?
          beer_in.style = style["id"]
        end
        beer_in.hash = hash
        brewery = hash["breweries"]
        unless brewery.nil?
          beer_in.brewery = brewery[0].to_h["name"]
        end
        if self.user_beer.id != beer_in.id && self.chosen_ones.include?(beer_in) != true
          self_include = true
          self.chosen_ones.each do |x|
            if x.id == beer_in.id
              self_include = false
            end
          end
          if self_include
            self.chosen_ones.push(beer_in)
          end
        end
        ibu_low -= 1
        ibu_high += 1
        abv_low -= 0.1
        abv_high += 0.1
      end
    end
  end
end