class Micropost < ApplicationRecord
  MICROPOST_PARAMS = %i(content image).freeze
  belongs_to :user
  has_one_attached :image

  delegate :name, to: :user, prefix: true

  validates :user_id, presence: true
  validates :content, presence: true, length: {maximum: Settings.micropost
                                                                .length.max}
  validates :image, content_type: {in: Settings.image_type,
                                   message: :invalid_format},
                    size: {less_than: Settings.max_image_storage_size.megabytes,
                           message: :required_size}

  scope :recent_posts, ->{order created_at: :desc}

  def display_image
    image.variant resize_to_limit: Settings.image_resize
  end
end
