#coding: utf-8

require 'digest/sha1'
module MailSort
  class Mail
    attr_reader :city, :street, :hous, :appartment, :destination, :value, :hash
    def initialize(city, street, hous, appartment, destination, value)
        @city, @street, @hous, @appartment, @destination, @value = city, street, hous, appartment, destination, value
        @hash = [@city, @street, @hous, @appartment, @destination].map{|value| Digest::SHA1.hexdigest(value.to_s)}.join()
    end
  end

  class MailStore
    def initialize(mails)
      @mail = mails
    end

    def to_city(city)
      @mail.find_all{|mail| mail.city == city }.count
    end

    def value_b10
      @mail.find_all{|mail| mail.value > 10 }.count
    end

    def most_popular
        counts_hash = {}
        @mail.each do |m|
            counts_hash[m.hash] = counts_hash[m.hash].to_i + 1
        end
        max_hash=counts_hash.max_by {|k,v| v}
        adress = @mail.find{|m| m.hash == max_hash[0]}
    end
  end
end

adresses = [['Днепропетровск','Гагарина',4,502,'верх',10],
            ['Днепропетровск','Гагарина',4,502,'верх',10],
            ['Днепропетровск','Гагарина',4,502,'верх',10],
            ['Днепропетровск','Гагарина',4,502,'верх',10],
            ['Днепропетровск','Гагарина',4,502,'верх',10],
            ['Днепропетровск','Гагарина',4,502,'верх',10],
            ['Днепропетровск','Гагарина',4,502,'верх',10],
            ['Днепропетровск','Гагарина',4,502,'верх',10],
            ['Днепропетровск','Гагарина',4,502,'верх',10],
            ['Днепродзержинск','Гагарина',5,502,'верх',12],
            ['Днепродзержинск','Гагарина',5,502,'верх',12],
            ['Днепродзержинск','Гагарина',5,502,'верх',12],
            ['Днепродзержинск','Гагарина',5,502,'верх',12],
            ['Днепродзержинск','Гагарина',5,502,'верх',12],
            ['Днепродзержинск','Гагарина',5,502,'верх',12],
            ['Днепродзержинск','Гагарина',5,502,'верх',12]]
mails = adresses.map{|adr| MailSort::Mail.new(*adr)}
mail_store = MailSort::MailStore.new(mails)

p mail_store.to_city 'Днепропетровск'
p mail_store.value_b10
p mail_store.most_popular
