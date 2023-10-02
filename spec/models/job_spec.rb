require 'rails_helper'

RSpec.describe Job, type: :model do
  describe 'validations' do
    context 'initial validations' do
      it { is_expected.to validate_presence_of(:job_name).on(:create) }
      it { is_expected.to validate_presence_of(:job_description).on(:create) }
      it { is_expected.to validate_presence_of(:job_requirements).on(:create) }
      it { is_expected.to validate_presence_of(:job_headcount).on(:create) }
      it { is_expected.to validate_presence_of(:job_salary).on(:create) }
      it { is_expected.to validate_presence_of(:job_currency).on(:create) }
      it { is_expected.to validate_presence_of(:job_location).on(:create) }
      it { is_expected.to validate_presence_of(:job_type).on(:create) }
      it { is_expected.to validate_presence_of(:deadline).on(:create) }
    end
  end

  describe 'associations' do
    it { is_expected.to have_many(:job_histories) }
    it { is_expected.to belong_to(:employer) } 
    it { is_expected.to belong_to(:employee).optional } 

  end

end
