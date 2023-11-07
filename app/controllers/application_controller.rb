class ApplicationController < ActionController::API
    before_action :authorize

    def authorize
        encoded_token = request.headers["Token"]
        decoded_token = Base64.decode64(encoded_token)
        data = decoded_token.split("-")

        is_valid = false
        @user = User.find_by(username: data[0])
        is_valid = @user.auth(data[1]) if @user

        is_match_secret = BCrypt::Password.new(data[2]) == ENV["SECRET"]
        
        return render(json: { message: "Invalid Token" }, status: :unauthorized) if !is_match_secret && !is_valid
    end
end
