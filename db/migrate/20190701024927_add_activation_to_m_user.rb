class AddActivationToMUser < ActiveRecord::Migration[5.2]
  def change
    add_column :m_users, :activation_digest, :string
    add_column :m_users, :activated, :boolean
    add_column :m_users, :activated_at, :datetime
  end
end
