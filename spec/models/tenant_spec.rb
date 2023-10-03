require 'rails_helper'

RSpec.describe Tenant, type: :model do
  describe 'validations' do
    context 'initial validations' do
      it { is_expected.to validate_presence_of(:company_name).on(:create) }
      it { is_expected.to validate_presence_of(:firstname).on(:create) }
      it { is_expected.to validate_presence_of(:lastname).on(:create) }
      it { is_expected.to validate_presence_of(:company_address).on(:create) }
      it { is_expected.to validate_presence_of(:company_email).on(:create) }
      it { is_expected.to validate_presence_of(:contact_number).on(:create) }
      it { is_expected.to validate_presence_of(:license).on(:create) }
      it { is_expected.to validate_presence_of(:subscription).on(:create) }
    end
  end

  describe 'associations' do
    it { is_expected.to have_many(:owners) }
    it { is_expected.to have_many(:employees) }
    it { is_expected.to have_many(:employers) }
  end
end
