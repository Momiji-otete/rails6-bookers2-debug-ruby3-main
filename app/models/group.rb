class Group < ApplicationRecord
  has_many :group_users, dependent: :destroy
  belongs_to :owner, class_name: 'User' #わからなかったやつ

  has_many :users, through: :group_users

  has_one_attached :group_image

  validates :name, presence: true, uniqueness: true
  validates :introduction, presence: true


  def get_group_image
  (group_image.attached?) ? group_image : 'no_image.jpg'
  end

  def is_owned_by?(user) #なにこれ
    owner.id == user.id
  end

  def joined_in_by?(user)
    group_users.exists?(user_id: user.id)
  end
end


