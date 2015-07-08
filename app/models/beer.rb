class Beer
  include ActiveModel::Model 
  attr_accessor :search, :string

  validates_presence_of :search
end