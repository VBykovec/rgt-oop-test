#coding: utf-8
module Library
    class Book
        include Enumerable
        attr_reader :book_id, :book_name, :order_count
        @@next_book_id = 0
        def initialize(name)
            @order_count = 0
            @book_name = name
            @book_id = @@next_book_id
            @@next_book_id += 1
        end 
        def increase_order 
            @order_count += 1
        end
        def <=>(book)
           (self.order_count)<=>(book.order_count)
        end
        
    end

    class BookOrder
        attr_accessor :name, :order_date, :issue_date, :book_id
        def initialize(name, book, issue_date, order_date)
            @name = name
            @order_date = Time.now
            @book_id = book.book_id if book.is_a? Book
        end
    end

    class Library
        attr_reader :min_period, :books, :book_orders

        def initialize(book_names)
            @not_satisfied = 0
            @satisfied = 0
            @min_period = 10
            @book_orders = []
            @books=[]
            book_names.each do |book_name|
                @books << Book.new(book_name)
            end
        end

        def order_book(user_name, book_name)
            time_start = Time.now
            book = @books.find {|book| book.book_name == book_name}
            time_end = Time.now + rand()

            @min_period = (@min_period > (time_end - time_start)) ? time_end - time_start : @min_period

            if book
                @satisfied += 1
                book.increase_order
                @book_orders << BookOrder.new(user_name, book, time_start, time_end)
            else
                @not_satisfied +=1
            end
        end

        def not_satisfied
            @not_satisfied
        end 
        
        def most_popular_book
            @books.max
        end

        def often_take_book
            users = @book_orders.map(&:name).uniq
            users_orders = {}
            users.each do |user|
              users_orders[user] = @book_orders.find_all{|u| user == u.name}.count
            end
            max_count = users_orders.values.max
            users_orders.rassoc max_count
        end

        def users_for_three_popular
            users = []
            @books.sort.reverse[0..2].each do |book|
                users << @book_orders.find_all{|order| order.book_id == book.book_id}.map(&:name).uniq
            end
            users.flatten.uniq
        end
    end
end

books = (1..10).to_a.map {|b| "book#{b}"}
users = (1..5).to_a.map{|u| "user_#{u}"}  

library = Library::Library.new(books)

library.order_book('user1', 'book1')
library.order_book('user2', 'book1')
library.order_book('user3', 'book1')
library.order_book('user4', 'book1')


library.order_book('user1', 'book5')
library.order_book('user2', 'book5')


# добавили книги, которых нет в библиотеке
library.order_book('user1', 'book0')
library.order_book('user2', 'book0')
library.order_book('user3', 'book0')
library.order_book('user4', 'book0')

library.order_book('user5', 'book6')
library.order_book('user5', 'book6')
library.order_book('user5', 'book6')
library.order_book('user5', 'book6')
library.order_book('user5', 'book6')

library.order_book('user1', 'book6')
library.order_book('user1', 'book6')
library.order_book('user1', 'book6')
library.order_book('user1', 'book6')
library.order_book('user1', 'book6')

10.times {library.order_book('user1', 'book5')}
10.times {library.order_book('user2', 'book5')}
10.times {library.order_book('user1', 'book4')}
10.times {library.order_book('user2', 'book4')}


p "Всего книг в библиотеке: #{library.books.count}"
p "Не смогли выдать книгу #{library.not_satisfied} раз"
p "Самая популярная книга: #{library.most_popular_book.book_name}"
p "Самый читающий: #{library.often_take_book[0]}"
p "Пользователи, взявшие самые популярные 3 книги: #{library.users_for_three_popular.join(', ')}"
p "Минимальный период выдачи: #{library.min_period}c"
#P.S. никто книги не возвращал
