# == Schema Information
#
# Table name: products
#
#  id          :bigint           not null, primary key
#  name        :string           not null
#  price       :decimal(10, 2)   not null
#  description :string           not null
#  category    :string           not null
#  photo_url   :string
#  condition   :string           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  user_id     :bigint           not null
#
class Product < ApplicationRecord
  searchkick

  CATEGORIES = %w[
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

  CONDITIONS = %W[ new like_new used ].freeze
  LISTING_TYPE = %w[ sell rent ].freeze
  LISTING_FEE = 0.30

  has_many_attached :photos
  has_many :favorited_products, class_name: 'FavoriteProduct'
  has_many :favorited_by, through: :favorited_products, source: :user

  belongs_to :user

  delegate :username, to: :user, allow_nil: true

  validates :name, presence: true
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :condition, presence: true
  validates :category, inclusion: {
    in: CATEGORIES,
    message: ->(object, data) { I18n.t(:invalid_category_type, scope: 'errors', value: data[:value]) }
  }
  validates :photos,
            content_type: ['image/png', 'image/jpg', 'image/jpeg'],
            limit: { max: 5, message: 'You can upload up to 5 pictures only'}
  validates :listing_type, inclusion: {
    in: LISTING_TYPE,
    message: ->(object, data) { I18n.t(:invalid_listing_type, scope: 'errors', value: data[:value]) }
  }

  scope :filter_by_category, ->(category) { where(category: category) if category.present? }
  scope :filter_by_condition, ->(condition) { where(condition: condition) if condition.present? }
  scope :newest_first, -> { order(created_at: :desc) }
  scope :oldest_first, -> { order(created_at: :asc) }
  scope :price_ascending, -> { order(price: :asc) }
  scope :price_descending, -> { order(price: :desc) }

  def rent?
    listing_type == 'rent'
  end
end
