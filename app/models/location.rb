class Location < ApplicationRecord
  belongs_to :stay, optional: true

  validates :stay_id, presence: true

  after_create :update_total_fee, :update_stay_annual_fee
  after_save :update_total_fee, :update_stay_annual_fee
  after_destroy :update_stay_annual_fee

  private

  def update_total_fee
    update_location_months
    if self.months and self.fee
      self.update_column :totalfee, self.months * self.fee
    else
      self.update_column :totalfee, 0
    end
  end

  def update_stay_annual_fee
    @stay = Stay.find_by_id(self.stay_id)
    @stay.set_annualfee
    @stay.set_fee
    @stay.set_monthsfee
  end

  def update_location_months
    if self.end_location_date and self.start_location_date
      meses = ((self.end_location_date - self.start_location_date).to_f)/30
      self.update_column :months, (( meses * 2.0).round / 2.0)
    else
      self.update_column :months, nil
    end
  end

end
