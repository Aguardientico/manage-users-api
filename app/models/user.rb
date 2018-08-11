class User < ApplicationRecord
  include Authenticable
  before_create :set_hashed_id

  validates :first_name, :last_name, presence: true, unless: :is_registering
  validates :email, presence: true, uniqueness: true
  validates :hashed_id, uniqueness: true

  attr_accessor :is_registering

  def self.search(term, page = nil)
    users = User.all
    if term
      term = "%#{term}%"
      users = User.where("first_name ILIKE :term OR last_name ILIKE :term OR job_title ILIKE :term", term: term)
    end
    users.page(page)
  end

  def as_json(options = {})
    super(options.merge only: %i[first_name last_name job_title email hashed_id is_admin])
  end

  protected

  def set_hashed_id
    loop do
      self.hashed_id = SecureRandom.uuid
      break unless User.where(hashed_id: hashed_id).exists?
    end
  end
end
