class CreateIpGets < ActiveRecord::Migration
  def change
    create_table :ip_gets do |t|

      t.timestamps
    end
  end
end
