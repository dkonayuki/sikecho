class CreateEducationsAndPeriodsJoinTable < ActiveRecord::Migration
  def change
    create_table :educations_periods do |t|
      t.belongs_to :education
      t.belongs_to :period
    end
  end
end
