class Checking < Account
  def rate
  end
  
  private
  
  def set_type
    self.account_type = "Checking"
    # I know it's not a type, but a Checking should never have a rate.
    self.monthly_account_rate = 0
  end
end
