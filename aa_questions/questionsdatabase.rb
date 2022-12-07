require 'sqlite3'
require 'singleton'

class QuestionsDataBase < SQLite3::Database
    include Singleton

    def initialize
        super('questions.db')
        self.type_translation = true
        self.results_as_hash = true
    end
end
require "byebug"
class User

    def self.find_by_id(id)
        user_hash = QuestionsDataBase.instance.execute(<<-SQL, id)

            SELECT 
                *
            FROM
                users
            WHERE
                id = ?;
        SQL
        User.new(user_hash.first)
    end

    def self.find_by_name(fname, lname)
        user_hash = QuestionsDataBase.instance.execute(<<-SQL, fname, lname)
            SELECT
                *
            FROM
                users
            WHERE
            fname = ? AND lname = ?;
        SQL

        User.new(user_hash.first)
    end
    
    attr_accessor :id, :fname, :lname
    
    def initialize(options)
        # debugger
        @id = options['id']
        @fname = options['fname']
        @lname = options['lname']
    end

    def create
        raise "#{self} already in database" if @id
        QuestionsDataBase.instance.execute(<<-SQL, @fname, @lname)
            INSERT INTO
                users (fname, lname)
            VALUES
                (?, ?)
        SQL
        id = QuestionsDataBase.instance.last_insert_row_id
    end





end

class Question

    attr_accessor :id, :title, :body, :author_id # TR

    def initialize(options)
        @id = options["id"]
        @title = options["title"]
        @body = options["body"]
        @author_id = options["author_id"]
    end

    def create                      # TEST WITHOUT @ for parameters becasue attr_accessor
        raise "#{self} is already in database" if @id
        QuestionsDataBase.instance.execute(<<-SQL, title, body, author_id)
            INSERT INTO
                questions (title, body, author_id)
            VALUES
                (?, ?, ?)
            SQL
        id = QuestionsDataBase.instance.last_insert_row_id


    end

end

class QuestionFollow


end

class Reply

end

class QuestionLike
    
end