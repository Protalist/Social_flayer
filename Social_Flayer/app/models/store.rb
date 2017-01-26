require "net/http"
require "uri"
require "json"

class Store < ApplicationRecord
  belongs_to :owner, class_name: 'User'

  has_many :products, dependent: :destroy
  has_many :works, dependent: :destroy
  has_many :admin, :through => :works, :source => 'User'
  has_many :comments
  has_many :follow_stores
  has_many :followers, :through => :follow_stores, :source => 'user'

  acts_as_votable

  validates_uniqueness_of :name, :scope => :owner_id
  validates :name , presence: true
  validates :location , presence: true


  def distance_from(location)
    url="https://maps.googleapis.com/maps/api/distancematrix/json?units=imperial&origins=#{self.location}&destinations=#{location}&key=AIzaSyA9DIhdJpFjMX2Kl7W2qf4pjYivfJah8y8"
    uri = URI.parse(url)
    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Get.new(uri.request_uri)
    http.use_ssl = true
    response = http.request(request)
    data_hash = JSON.parse(response.body)
    check=data_hash["rows"][0]["elements"][0]["status"].to_s
    print "LEGGI QUA:"+ check
    if(check!="NOT_FOUND" && check!="ZERO_RESULTS")
      return data_hash["rows"][0]["elements"][0]["distance"]["text"].split[0].to_f
    end

  end

  def self.search(params)
    stores=Store.left_outer_joins(:products).distinct
    stores.each do |c|
      puts c.name
    end
    if params
      if  (params[:type] != nil && params[:type] != "")
        stores=stores.where("type_p LIKE ?", "%#{params[:type]}%")
      end
      if(params[:name] != nil && params[:name] != "")
        stores=stores.where(["stores.name LIKE ?","%#{params[:name]}%"])
      end
    end
    return stores
  end

end
