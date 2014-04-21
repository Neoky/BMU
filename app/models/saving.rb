class Saving < Account

  validates :monthly_account_rate, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 1}

  def rate
    intrest = self.current_balance * self.monthly_account_rate
    intrest = self.current_balance + intrest
    self.update_attribute(:current_balance, intrest)
  end

  private

  def set_type
    self.account_type = "Saving"
  end
end
