require "httparty"

class LatestStockPrice
    def initialize
        @base_url = ENV["LATEST_STOCK_HOST"]
        @api_key = ENV["LATEST_STOCK_KEY"]
    end

    def get_price(indices, identifier = [])
        query = {
            Indices: indices,
            Identifier: identifier.join(",")
        }

        response = HTTParty.get("https://#{@base_url}/price", query: query, headers: header)

        unless response.success?
            Rails.logger.fatal "[LatestStockPrice][Price][#{response.code}]#{response["message"]}"
            raise "LatestStockPrice #{response.message}"
        end

        response
    end

    def get_price_all(identifier = [])
        query = {
            Identifier: identifier.join(",")
        }

        response = HTTParty.get("https://#{@base_url}/any", query: query, headers: header)

        unless response.success?
            Rails.logger.fatal "[LatestStockPrice][PriceAll][#{response.code}]#{response["message"]}"
            raise "LatestStockPrice #{response.message}"
        end

        response
    end

    private

    def header
        {
            "Content-Type": "application/json",
            "X-RapidAPI-Key": @api_key,
            "X-RapidAPI-Host": @base_url
        }
    end
end