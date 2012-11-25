class Bank < ActiveRecord::Base
  attr_accessible :bankname, :day, :month, :paykind, :payment, :payreason, :putkind, :putreason, :putting, :year
end
