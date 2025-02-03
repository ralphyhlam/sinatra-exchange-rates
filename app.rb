require "sinatra"
require "sinatra/reloader"
require "dotenv/load"
require "http"
require "json"

get("/") do
  template = "https://api.exchangerate.host/list?access_key="
  list_url = "https://api.exchangerate.host/list?access_key=#{ENV.fetch("EXCHANGE_API")}"
  @list_results= HTTP.get(list_url).to_s
  @list_format = JSON.parse(@list_results)
  currencies = @list_format.fetch("currencies")
  @list_currencies = currencies.keys
  erb(:homepage)
end

get("/:currency_choice") do 
  @choice = params.fetch("currency_choice")

  erb(:conversion_choices)
end
