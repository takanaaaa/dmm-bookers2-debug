class Tag < ApplicationRecord
  has_many :tag_maps, dependent: :destroy
  has_many :books, through: :tag_maps

  def self.search(search, word)
    if search == "forward_match"
      @tag = Tag.where("tag_name LIKE?", "#{word}%")
    elsif search == "backward_match"
      @tag = Tag.where("tag_name LIKE?", "%#{word}")
    elsif search == "perfect_match"
      @tag = Tag.where("#{word}")
    elsif search == "partial_match"
      @tag = Tag.where("tag_name LIKE?", "%#{word}%")
    else
      @tag = Tag.all
    end
  end
end

