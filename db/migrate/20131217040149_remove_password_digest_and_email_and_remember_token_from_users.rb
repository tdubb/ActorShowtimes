class RemovePasswordDigestAndEmailAndRememberTokenFromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :remember_token, :string
    remove_column :users, :password_digest, :string
    remove_column :users, :email, :string
  end
end
