class User < ApplicationRecord
  authenticates_with_sorcery!
  mount_uploader :avatar, AvatarUploader

  has_many :test_results, dependent: :destroy
  # フォローしている関連付け
  has_many :active_relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  # フォローされている関連付け
  has_many :passive_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
  # フォローしているユーザーを取得
  has_many :followings, through: :active_relationships, source: :followed
  # フォロワーを取得
  has_many :followers, through: :passive_relationships, source: :follower

  has_many :active_notifications, class_name: 'Notification', foreign_key: 'visitor_id', dependent: :destroy
  has_many :passive_notifications, class_name: 'Notification', foreign_key: 'visited_id', dependent: :destroy

  has_many :entries
  has_many :messages
  has_many :rooms, through: :entries

  validates :first_name, presence: true, length: { maximum: 255 }
  validates :last_name, presence: true, length: { maximum: 255 }
  validates :nickname, presence: true
  validates :grade_and_class, presence: true
  validates :email, uniqueness: true, presence: true
  validates :introduction, length: { maximum: 255 }
  
  validates :password, length: { minimum: 3 }, if: -> { new_record? || changes[:crypted_password] }
  validates :password, confirmation: true, if: -> { new_record? || changes[:crypted_password] }
  validates :password_confirmation, presence: true, if: -> { new_record? || changes[:crypted_password] }
  validates :reset_password_token, uniqueness: true, allow_nil: true

  enum role: { general: 0, admin: 1 }

  def own?(object)
    id == object.user_id
  end

  # 指定したユーザーをフォローする
  def follow(user)
    active_relationships.create(followed_id: user.id)
  end
  
  # 指定したユーザーのフォローを解除する
  def unfollow(user)
    active_relationships.find_by(followed_id: user.id).destroy
  end
  
  # 指定したユーザーをフォローしているかどうかを判定
  def following?(user)
    followings.include?(user)
  end


  def full_name
    "#{last_name} #{first_name}"
  end

  def average_achievement_rate
    test_results.average(:achievement_rate)
  end

  def create_notification_follow!(current_user)
    temp = Notification.where(["visitor_id = ? and visited_id = ? and action = ? ",current_user.id, id, 'follow'])
    if temp.blank?
      notification = current_user.active_notifications.new(
        visited_id: id,
        action: 'follow'
      )
      notification.save if notification.valid?
    end
  end
end
