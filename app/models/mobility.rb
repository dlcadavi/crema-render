class Mobility < ApplicationRecord
  belongs_to :stay, optional: true


  validates :stay_id, presence: true

  after_create :update_mobility_months, :update_annual_fee
  after_save :update_mobility_months, :update_annual_fee

  private

  def update_annual_fee
    @stay = Stay.find_by_id(self.stay_id)
    @stay.set_annualfee
  end

  def update_mobility_months
    if self.end_mobility_date and self.start_mobility_date
      meses = ((self.end_mobility_date - self.start_mobility_date).to_f)/30
      self.update_column :months, (( meses * 2.0).round / 2.0)
    else
      self.update_column :months, nil
    end
  end

end
