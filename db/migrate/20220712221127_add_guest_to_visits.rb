class AddGuestToVisits < ActiveRecord::Migration[7.0]
  def change
    add_reference :visits, :guest
  end
end
