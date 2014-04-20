class Deposit < Transaction

  def deposit
    self.transaction_type = "Deposit"
    convert_amount
    #self.amount = self.amount_string.to_f # make sure amount is positive
    self.amount = '%.2f' % self.amount # rounds to two digits.

    account = Account.find(self.account_id)
    if account.account_type == 'Credit' or account.account_type == 'Mortgage'
      new_balance = account.current_balance - self.amount
    else
      new_balance = account.current_balance + self.amount
    end

    # Validates that the user_id entered is a valid id.
    user = User.find(self.user_id)
    # Validates that user either owns the account or the user is a teller.
    # Validates this is an active account.
    # Validates that this type of account can be deposited to.
    if (user.id != account.user_id && user.user_level != 2) || !account.is_active? #|| self.validate_transaction_on_account?
      return false
    end
    if user.user_level == 2
      self.description = "Deposit from teller."
    end
    Deposit.transaction do
      Account.transaction do
        self.save!
        #account.update_attribute(:balance_string, new_balance.to_s)
        account.current_balance= new_balance
        account.save!
        #raise ActiveRecord::Rollback unless self.valid? && account.valid?
      end
    end

    return true
  end
end
