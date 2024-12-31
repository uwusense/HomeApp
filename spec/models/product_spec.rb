# == Schema Information
#
# Table name: products
#
#  id           :bigint           not null, primary key
#  name         :string           not null
#  price        :decimal(10, 2)   not null
#  description  :string           not null
#  category     :string           not null
#  condition    :string           not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  user_id      :bigint           not null
#  listing_type :string           default("sell"), not null
#
require 'rails_helper'

RSpec.describe Product, type: :model do
  describe 'associations' do
    it { should belong_to(:user) }
    it { should have_many(:favorited_products) }
    it { should have_many(:favorited_by).through(:favorited_products).source(:user) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:price) }
    it { should validate_numericality_of(:price).is_greater_than_or_equal_to(0) }
    it { should validate_presence_of(:condition) }

    describe 'photo validation' do
      let(:product) { build(:product) }

      it 'allows up to 5 photos' do
        product.photos.attach(io: File.open(Rails.root.join('spec', 'files', 'sample_image.jpg')), filename: 'image1.jpg', content_type: 'image/jpg')
        product.photos.attach(io: File.open(Rails.root.join('spec', 'files', 'sample_image.jpg')), filename: 'image2.jpg', content_type: 'image/jpg')
        expect(product).to be_valid
        expect(product.photos.size).to eq(2)
      end

      it 'validates photos count not to exceed 5' do
        6.times do |i|
          product.photos.attach(io: File.open(Rails.root.join('spec', 'files', 'sample_image.jpg')), filename: "image#{i}.jpg", content_type: 'image/jpg')
        end
        expect(product).not_to be_valid
        expect(product.errors[:photos]).to include('You can upload up to 5 pictures only')
      end
    end
  end

  describe 'scopes' do
    let!(:product1) { create(:product, created_at: 1.day.ago, price: 10.00) }
    let!(:product2) { create(:product, created_at: 2.days.ago, price: 20.00) }
    let!(:product3) { create(:product, created_at: 3.days.ago, price: 5.00) }

    it 'orders by newest first' do
      expect(Product.newest_first).to eq([product1, product2, product3])
    end

    it 'orders by oldest first' do
      expect(Product.oldest_first).to eq([product3, product2, product1])
    end

    it 'orders by price ascending' do
      expect(Product.price_ascending).to eq([product3, product1, product2])
    end

    it 'orders by price descending' do
      expect(Product.price_descending).to eq([product2, product1, product3])
    end
  end
end
