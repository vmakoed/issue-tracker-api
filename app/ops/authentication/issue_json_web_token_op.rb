# frozen_string_literal: true

module Authentication
  class IssueJsonWebTokenOp < ::Subroutine::Op
    field :email
    field :password

    validates :email, :password, presence: true
    validate :validate_password_correct

    outputs :token

    protected

    def perform
      issue_token

      output :token, @token
    end

    def validate_password_correct
      return if authenticate_user

      errors.add(:password, 'is incorrect')
    end

    def authenticate_user
      @user = User.find_by(email: email)
      @user.authenticate(password)
    end

    def issue_token
      @token = Authentication::EncodeJsonWebTokenOp.submit!(user_id: @user.id)
                                                   .token
    end
  end
end
