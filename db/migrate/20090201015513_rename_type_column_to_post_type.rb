class RenameTypeColumnToPostType < ActiveRecord::Migration
  def self.up
    remove_column :posts, :type
    add_column :posts, :post_type, :string
  end

  def self.down
    remove_column :posts, :post_type
    add_column :posts, :type, :string
  end
end
