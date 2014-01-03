class ChartImagesController < ApplicationController
  def create
    send_data Base64.decode64(chart_data), :type => 'image/png', :disposition => 'inline', :filename => 'chart.png'
  end
  alias :index :create

  private

  def chart_data
    cache_key = params.flatten.to_s.parameterize.hash
    # read from cache for performance
    @chart_data = Rails.cache.read(cache_key)
    if @chart_data.nil?
      image ||= ChartImage.new(input: params[:input], width: params[:width])
      @chart_data = image.data
      Rails.cache.write(cache_key, image.data)
    end
    @chart_data
  end

end
