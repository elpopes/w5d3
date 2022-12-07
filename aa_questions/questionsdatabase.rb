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
    attr_accessor :user_id, :question_id
    def initialize(options)
        @user_id = options["user_id"]
        @question_id = options["question_id"]
    end

    def create
        QuestionsDataBase.instance.execute(<<-SQL, user_id, question_id)
            INSERT INTO
                question_follows(user_id, question_id)
            VALUES
                (?, ?)
        SQL

        id = QuestionsDataBase.instance.last_insert_row_id     
    end

# THIS IS JUST TO GET ANOTHER PUSH GOING
end

class Reply
    attr_accessor :id, :question_id, :parent_reply_id, :user_id, :body
    def initialize(options)
        @id = options['id']
        @question_id = options['question_id']
        @parent_reply_id = options['parent_reply_id']
        @user_id = options['user_id']
        @body = options['body']
    end

    def create
        QuestionsDataBase.instance.execute(<<-SQL, id, question_id, parent_reply_id, user_id, body)
        INSERT INTO
            replies
        VALUES
            (?, ?, ?, ?, ?)
        SQL

        id = QuestionsDataBase.instance.last_insert_row_id
    end
end

class QuestionLike
    
end