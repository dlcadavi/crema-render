class Visit < ApplicationRecord
  belongs_to :guest
  belongs_to :acyear


  def set_months
    if self.hosting_end_date and self.hosting_start_date
      meses = ((self.hosting_end_date - self.hosting_start_date).to_f)/30
      self.update_column :months, (( meses * 2.0).round / 2.0)
    else
      self.update_column :months, nil
    end
  end

  def set_annualfee
    if self.fee and self.months
      self.update_column :annualfee, (self.months * self.fee)
    else
      self.update_column :annualfee, nil
    end
  end

end
