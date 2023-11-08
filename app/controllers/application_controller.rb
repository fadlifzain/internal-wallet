class ApplicationController < ActionController::API
    before_action :authorize

    private
    def authorize
        encoded_token = request.headers["Token"]

        begin
            decoded_token = Base64.decode64(encoded_token)
        rescue => e
            return render(json: { message: "Invalid Token" }, status: :unauthorized)
        end

        data = decoded_token.split("-")

        is_valid = false
        @@user = User.find_by(token: encoded_token.gsub("\\n", "\n"))

        if @@user
            is_valid = is_valid && data[0].length == 5
            is_valid = data[1] == @@user.username
            is_valid = is_valid && @@user.authenticate(data[2])
            is_valid = is_valid && data[3].length == 5
        end

        is_match_secret = data[4] == ENV["SECRET"]
        
        return render(json: { message: "Invalid Token" }, status: :unauthorized) if !is_match_secret && !is_valid
    end
end
