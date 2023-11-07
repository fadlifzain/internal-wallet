class AuthController < ApplicationController
    skip_before_action :authorize, only: [:login]

    def login
        user = User.find_by(username: login_params[:username])
        begin
            user.auth(login_params[:password])
        rescue Exception => e
            return render json: { message: e.to_s }, status: :unauthorized
        end

        user.reload

        return render json: { message: "Login successful", token: user.token}, status: :ok
    end

    private

    def login_params
        params.permit(:username, :password)
    end
end
