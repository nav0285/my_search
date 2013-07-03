class SearchController < ApplicationController 

 def index
    @name=params[:q]
    @name.gsub!(' ','+')  
    session[:name] = @name 
    @facebook = HTTParty.get("http://www.bing.com/search?q=#{session[:name]}%3Afacebook")
    @@redis.set("facebook:#{session[:name]}","#{@facebook}")
    @twitter = HTTParty.get("http://www.bing.com/search?q=#{session[:name]}%3Atwitter")
    @@redis.set("twitter:#{session[:name]}","#{@twitter}")
    @linkedin = HTTParty.get("http://www.bing.com/search?q=#{session[:name]}%3Alinkedin")
    @@redis.set("linkedin:#{session[:name]}","#{@linkedin}")
    @@redis.set("#{session[:name]}","#{@twitter}+#{@facebook}+#{@linkedin}")
    @doc = Nokogiri::HTML(@@redis.get("#{session[:name]}"))
  end

 def facebook
   @doc = Nokogiri::HTML(@@redis.get("facebook:#{session[:name]}"))
   render :index  
 end
 
 def twitter
   @doc = Nokogiri::HTML(@@redis.get("twitter:#{session[:name]}"))
   render :index  
 end
 
 def linkedin
   @doc = Nokogiri::HTML(@@redis.get("linkedin:#{session[:name]}"))
   render :index  
 end

end
