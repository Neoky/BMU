class Bill < ActiveRecord::Base
  belongs_to :user
  belongs_to :account
  belongs_to :payee_account, class_name: "Account"
  validates :user, :account, :payee_name, :payee_street, 
            :payee_city, :payee_state, :payee_zip, :payee_account, 
            :amount_string, :amount, :pay_date, presence: true
  validates :amount_string, format: { 
            with: /\A(?=.)^\$?(([1-9][0-9]{0,2}(,[0-9]{3})*)|[0-9]+)?(\.[0-9]{1,2})?$\z/,
            message: " is invalid.",
            multiline: true}
  validates :payee_zip, length: { is: 5, wrong_length: " should be 5 numbers long."}
  validates :payee_zip, numericality: { only_integer: true }
  #validates :is_recurring, in: [true,false]
  validate :custom_validation?
  attr_accessor :amount_string
  before_validation :convert_amount

  def bills(offset)
    @bills = Bill.find(offset)
  end
  
  def custom_validation?
    errors.add(:account_id, " must not be from a Mortgage, Market, or Savings account.") if !self.account.nil? && self.account.account_type != "Checking" && self.account.account_type != "Credit" 
    errors.add(:account_id, " must be one of you own.") if !self.account.nil? && self.account.user_id != self.user_id
    errors.add(:pay_date, " can't be in the past.") if self.pay_date < Date.yesterday
    errors.add(:pay_date, " can not be past the 28th of the month.") if self.pay_date.day > 28
    errors.add(:is_recurring, " must not be blank.") if self.is_recurring == 1 || self.is_recurring == 0
  end
  
  def convert_amount
    match = ""
    for i in self.amount_string.scan(/\d\.*/)
      match += i
    end
    self.amount = match.to_f
  end
  
  def pay
    to_transfer = Transfer.new(from_account_id: self.account_id, to_account_id: self.payee_account_id, amount_string: self.amount.to_s, user_id: self.user_id, transaction_type: 'Bill Deposit')
    from_transfer = Transfer.new(from_account_id: self.account_id, to_account_id: self.payee_account_id, amount_string: self.amount.to_s, user_id: self.user_id, transaction_type: 'Bill Withdrawal')
    Transfer.transfer(to_transfer, from_transfer)
  end
  
  def pay_once
    bills = Bill.where(pay_date: Date.today).where(is_recurring: false)
    for bill in bills
      bill.pay
    end
  end
  
  def pay_recurring
    bills = Bill.where("extract(DAY FROM bills.pay_date) = :pay_date", pay_date: Date.today.day).
                 where("is_recurring = :is_recurring", is_recurring: true)
    for bill in bills
      bill.pay
    end
  end
  
  def pay_all
    pay_once
    pay_recurring
  end
end
