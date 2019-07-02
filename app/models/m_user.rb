class MUser < ApplicationRecord
    #has_many :tchannelmsg, dependent: :destroy
    attr_accessor :remember_token, :activation_token, :reset_token
    before_save   :downcase_email
    before_create :create_activation_digest
    validates :user_name,  presence: {message: "を入力してください"}, 
    length: { maximum: 50, message: "50文字より短い名前を入力してください" }
    #validates :user_name,  presence: true, length: { maximum: 50 }
    
    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
    #validates :email, presence: true, length: { maximum: 255 },
                      #format: { with: VALID_EMAIL_REGEX },
                      #uniqueness: { case_sensitive: false }
    validates_presence_of   :email, :message => 'を入力してください',
    length: { maximum: 255, message: "が無効です" },
    format: { with: VALID_EMAIL_REGEX },
    uniqueness: { case_sensitive: false }
    #validates :email,  presence: {message: "を入力してください"}, 
                      #length: { maximum: 255, message: "が無効です" },
                      #format: { with: VALID_EMAIL_REGEX },
                      #uniqueness: { case_sensitive: false }
  
    has_secure_password validations:false
  
    #validates_presence_of :password, length: { minimum: 6 }
  
    validates :password,  presence: {message: "を入力してください"}, 
    length: { minimum: 6, message: "が無効です" }
  
    # Returns the hash digest of the given string.
    def MUser.digest(string)
      cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                    BCrypt::Engine.cost
      BCrypt::Password.create(string, cost: cost)
    end
  
    # Returns a random token.
    def MUser.new_token
      SecureRandom.urlsafe_base64
    end 
    
    #def forget
      #update_attribute(:remember_digest, nil)
    #end
  
    # Returns true if the given token matches the digest.
    def authenticated?(attribute, token)
      digest = send("#{attribute}_digest")
      return false if digest.nil?
      BCrypt::Password.new(digest).is_password?(token)
    end
    
  # Activates an account.
   
  def activate
    update_attribute(:activated,    true)
    update_attribute(:activated_at, Time.zone.now)
  end
  
  # Sends activation email.
  def send_activation_email
    MUserMailer.account_activation(self).deliver_now
  end
  
    private
  
    # Converts email to all lower-case.
    def downcase_email
      self.email = email.downcase
    end
  
    # Creates and assigns the activation token and digest.
    def create_activation_digest
      self.activation_token  = MUser.new_token
      self.activation_digest = MUser.digest(activation_token)
    end
   end
  