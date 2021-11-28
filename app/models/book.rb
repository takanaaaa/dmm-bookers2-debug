class Book < ApplicationRecord

	validates :title, presence: true
	validates :body, presence: true, length: {maximum: 200}

	scope :created_today, -> { where(created_at: Time.zone.now.all_day) }
	scope :created_yesterday, -> { where(created_at: 1.day.ago.all_day) }
	scope :created_this_week, -> { where(created_at: 6.day.ago.beginning_of_day..Time.zone.now.end_of_day) }
	scope :created_last_week, -> { where(created_at: 2.week.ago.beginning_of_day..1.week.ago.end_of_day) }

	belongs_to :user
	has_many :favorites, dependent: :destroy
	has_many :favorited_users, through: :favorites, source: :user
	has_many :book_comments, dependent: :destroy
	has_many :view_counts, dependent: :destroy
	has_many :tag_maps, dependent: :destroy
	has_many :tags, through: :tag_maps

  def self.search(search, word)
    if search == "forward_match"
      @book = Book.where("title LIKE?", "#{word}%")
    elsif search == "backward_match"
      @book = Book.where("title LIKE?", "%#{word}")
    elsif search == "perfect_match"
      @book = Book.where("#{word}")
    elsif search == "partial_match"
      @book = Book.where("title LIKE?", "%#{word}%")
    else
      @book = Book.all
    end
  end

  def save_tag(sent_tags)
    current_tags = self.tags.pluck(:tag_name) unless self.tags.nil?
    old_tags = current_tags - sent_tags
    new_tags = sent_tags - current_tags

    old_tags.each do |old|
      self.book_tags.delete Tag.find_by(tag_mame: old)
    end
    new_tags.each do |new|
      new_book_tag = Tag.find_or_create_by(tag_name: new)
      self.tags << new_book_tag
    end
  end
end


