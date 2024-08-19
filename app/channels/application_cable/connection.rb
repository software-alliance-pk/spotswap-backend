# app/channels/application_cable/connection.rb
module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      begin
        if request.headers['Authorization'].present?
          header = request.headers['Authorization']
          header = header.split(' ').last if header
          begin
            @decoded = JsonWebToken.decode(header)
            @current_user = User.find_by_id(@decoded[:user_id]) || User.find_by_email(@decoded[:email])
          rescue ActiveRecord::RecordNotFound => e
            logger.info "Record Not Found: #{e.message}"
            reject_unauthorized_connection
          rescue JWT::DecodeError => e
            logger.info "JWT Decode Error: #{e.message}"
            reject_unauthorized_connection
          end
        else
          self.current_user = find_verified_admin
        end
      rescue
        puts "connection is not created"
      end
    end

    private

    def find_verified_admin
      if verified_user = env['warden'].user
        verified_user
      else
        reject_unauthorized_connection
      end
    end

      def find_verified_user
       puts " testing cookiescookies.encrypted[:user_id]: #{cookies.encrypted[:user_id].inspect}"
        if verified_user = User.find_by(id: cookies.encrypted[:user_id])
          verified_user
        else
          reject_unauthorized_connection
        end
      end
  end
end
