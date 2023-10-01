require 'rails_helper'

RSpec.describe Admin, type: :model do
  describe 'validations' do
    context 'initial validations' do
      it { is_expected.to validate_presence_of(:firstname).on(:create) }
      it { is_expected.to validate_presence_of(:lastname).on(:create) }
      it { is_expected.to validate_presence_of(:username).on(:create) }
      it { is_expected.to validate_presence_of(:email).on(:create) }
      it { is_expected.to validate_presence_of(:password).on(:create) }
      it { is_expected.to validate_presence_of(:password_confirmation).on(:create) }
    end

    context 'further validations' do
      it 'validates correct email' do
        valid_email = "test.user@example.com"
        expect(valid_email).to match(URI::MailTo::EMAIL_REGEXP)
      end

      it 'invalidates incorrect email' do
        invalid_email = 'wrong_email'
        expect(invalid_email).not_to match(URI::MailTo::EMAIL_REGEXP)
      end
    end
  end

end
