class SetDefaultValueForReviewStatus < ActiveRecord::Migration
  def up
    change_column :items, :review_status, :string,
                  :null => false,
                  :default => "not-ready"
  end

  def down
    change_column :items, :review_status, :string,
                  :null => true,
                  :default => null
  end
end
