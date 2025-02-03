require "sinatra"
require "sinatra/reloader"
require "dotenv/load"
require "http"
require "json"

get("/") do
  list_url = "https://api.exchangerate.host/list?access_key=#{ENV.fetch("EXCHANGE_API")}"
  @list_results= HTTP.get(list_url).to_s
  @list_format = JSON.parse(@list_results)
  currencies = @list_format.fetch("currencies")
  @list_currencies = currencies.keys
  erb(:homepage)
end

get("/:currency_choice") do 
  @choice = params.fetch("currency_choice").to_s
  list_url = "https://api.exchangerate.host/list?access_key=#{ENV.fetch("EXCHANGE_API")}"
  @list_results= HTTP.get(list_url).to_s
  @list_format = JSON.parse(@list_results)
  currencies = @list_format.fetch("currencies")
  @list_currencies = currencies.keys
  erb(:conversion_choices)
end

get("/:currency_choice/:conversion_choice") do 
  @choice = params.fetch("currency_choice").to_s
  @target = params.fetch("conversion_choice").to_s

  @conversion_url = "https://api.exchangerate.host/convert?from=#{@choice}&to=#{@target}&amount=1&access_key=#{ENV.fetch("EXCHANGE_API")}"
  conversion_results = HTTP.get(@conversion_url)
  @conversion_format = JSON.parse(conversion_results)

  info = @conversion_format.fetch("info")
  @quote = info.fetch("quote")

  erb(:converted)
end
