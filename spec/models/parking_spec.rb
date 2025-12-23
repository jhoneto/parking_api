require 'rails_helper'

RSpec.describe Parking, type: :model do
  describe 'validations' do
    context 'with valid attributes' do
      subject { build(:parking) }

      it { is_expected.to be_valid }
    end

    describe 'plate' do
      context 'when nil' do
        subject { build(:parking, plate: nil) }

        it { is_expected.not_to be_valid }
      end

      context 'when blank' do
        subject { build(:parking, plate: '') }

        it { is_expected.not_to be_valid }
      end

      context 'when in valid format AAA-9999' do
        subject { build(:parking, plate: 'ABC-1234') }

        it { is_expected.to be_valid }
      end

      context 'when format is invalid without hyphen' do
        subject { build(:parking, plate: 'ABC1234') }

        it { is_expected.not_to be_valid }
      end

      context 'when format is invalid with lowercase letters' do
        subject { build(:parking, plate: 'abc-1234') }

        it { is_expected.not_to be_valid }
      end

      context 'when format is invalid with wrong pattern' do
        subject { build(:parking, plate: '123-ABCD') }

        it { is_expected.not_to be_valid }
      end

      context 'when format has less than 3 letters' do
        subject { build(:parking, plate: 'AB-1234') }

        it { is_expected.not_to be_valid }
      end

      context 'when format has less than 4 numbers' do
        subject { build(:parking, plate: 'ABC-123') }

        it { is_expected.not_to be_valid }
      end
    end

    describe 'entry_time' do
      context 'when nil' do
        subject { build(:parking, entry_time: nil) }

        it { is_expected.not_to be_valid }
      end

      context 'when present' do
        subject { build(:parking, entry_time: Time.current) }

        it { is_expected.to be_valid }
      end
    end
  end

  describe 'default values' do
    subject { Parking.new }

    it 'sets paid to false by default' do
      expect(subject.paid).to be false
    end

    it 'does not set exit_time by default' do
      expect(subject.exit_time).to be_nil
    end
  end

  describe 'factories' do
    context 'default factory' do
      subject { build(:parking) }

      it { is_expected.to be_valid }
    end

    context 'with_exit trait' do
      subject { build(:parking, :with_exit) }

      it 'has exit_time set' do
        expect(subject.exit_time).not_to be_nil
      end
    end

    context 'paid trait' do
      subject { build(:parking, :paid) }

      it 'is marked as paid' do
        expect(subject.paid).to be true
      end
    end
  end
end
