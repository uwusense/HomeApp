# == Schema Information
#
# Table name: products
#
#  id           :bigint           not null, primary key
#  name         :string           not null
#  price        :decimal(10, 2)   not null
#  description  :string           not null
#  photo_url    :string
#  condition    :string           not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  user_id      :bigint           not null
#  category_id  :bigint           not null
#
class Product < ApplicationRecord
  CATEGORIES = %w[
    new_in
    furniture
    decor
    lightning
    textiles
    tools
    building_materials
    hardware
    plumbing
    electrical
    heating_cooling
    doors_windows
  ].freeze

  belongs_to :user

  delegate :username, to: :user, allow_nil: true

  validates :name, presence: true
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :condition, presence: true
  validates :category, inclusion: { in: CATEGORIES, message: "%{value} is not a valid category" }

  scope :filter_by_category, ->(category) { where(category: category) if category.present? }
  scope :filter_by_condition, ->(condition) { where(condition: condition) if condition.present? }
  scope :newest_first, -> { order(created_at: :desc) }
  scope :oldest_first, -> { order(created_at: :asc) }
  scope :price_ascending, -> { order(price: :asc) }
  scope :price_descending, -> { order(price: :desc) }
end
