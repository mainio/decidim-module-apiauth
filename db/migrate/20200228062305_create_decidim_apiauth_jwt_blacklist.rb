# frozen_string_literal: true

class CreateDecidimApiauthJwtBlacklist < ActiveRecord::Migration[5.2]
  def change
    create_table :decidim_apiauth_jwt_blacklists do |t|
      t.string :jti, null: false
      t.datetime :exp, null: false
    end
    add_index :decidim_apiauth_jwt_blacklists, :jti
  end
end
