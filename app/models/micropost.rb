class Micropost < ApplicationRecord
  MICROPOST_PARAMS = %i(content image).freeze

  belongs_to :user

  has_one_attached :image

  scope :create_post_at, ->{order(created_at: :desc)}

  delegate :name, to: :user, prefix: true

  validates :user_id, presence: true
  validates :content, presence: true, length: {maximum:
    Settings.micropost.content.max_length}
  validates :image, content_type: {in: %w(image/jpeg image/gif image/png),
                                   message: I18n.t("errors.messages.invalid_pic")},
    size: {less_than: Settings.files.pic_size.megabytes,
           message: I18n.t("errors.messages.less_than_mb", count: Settings.files.pic_size)}

  def display_image
    image.variant(resize_to_limit: [Settings.files.pic_resize, Settings.files.pic_resize])
  end
end
