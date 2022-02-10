class AddIndexToMusics < ActiveRecord::Migration[6.0]
  #index를 만드는 도중에는 write를 못 하게 lock하는 것을 방지
  disable_ddl_transaction!

  def change
    add_index :musics, :searchable, using: :gin, algorithm: :concurrently
  end
end
