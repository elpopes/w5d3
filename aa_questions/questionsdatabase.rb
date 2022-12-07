require 'sqlite3'
require 'singleton'
require "byebug"

class QuestionsDataBase < SQLite3::Database
    include Singleton

    def initialize
        super('questions.db')
        self.type_translation = true
        self.results_as_hash = true
    end
end

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

    def authored_questions
        Question.find_by_author_id(self.id)
    end

    def authored_replies
        Reply.find_by_user_id(self.id)
    end

end

class Question

    def self.find_by_id(id)
        user_hash = QuestionsDataBase.instance.execute(<<-SQL, id)

            SELECT 
                *
            FROM
                questions
            WHERE
                id = ?;
        SQL
        Question.new(user_hash.first)
    end

    def self.find_by_author_id(author_id)
        question_hash = QuestionsDataBase.instance.execute(<<-SQL, author_id)
            SELECT
                *
            FROM
                questions
            Where
                author_id = ?
            SQL
        arr = []
        question_hash.each do |question|
            arr << Question.new(question)
        end
        arr
    end

    attr_accessor :id, :title, :body, :author_id # TR

    def initialize(options)
        # debugger
        @id = options["id"]
        @title = options["title"]
        @body = options["body"]
        @author_id = options["author_id"]
    end

    def create                     
        raise "#{self} is already in database" if @id
        QuestionsDataBase.instance.execute(<<-SQL, title, body, author_id)
            INSERT INTO
                questions (title, body, author_id)
            VALUES
                (?, ?, ?)
            SQL
        id = QuestionsDataBase.instance.last_insert_row_id
    end

    def author
        User.find_by_id(@author_id)
    end

    def replies
        Reply.find_by_question_id(@id)
    end

end

class QuestionFollow
   
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

end

class Reply
    def author
        User.find_by_id(@id)
    end
    def question
        Question.find_by_id(@id)
    end

    def self.find_by_question_id(question_id)
        reply_hash = QuestionsDataBase.instance.execute(<<-SQL, question_id)
            SELECT 
                *
            FROM 
                replies
            WHERE
                question_id = ?
        SQL
        arr = []
        reply_hash.each do |reply|
            arr << Reply.new(reply)
        end
        arr
    end

    def self.find_by_user_id(user_id)
        id_hash = QuestionsDataBase.instance.execute(<<-SQL, user_id)
        
            SELECT
                *
            FROM
                replies
            WHERE
                user_id = ?
        SQL
        arr = []
        id_hash.each do |id|
            arr << Reply.new(id)
        end
        arr
    end

    def self.find_by_id(id)
        user_hash = QuestionsDataBase.instance.execute(<<-SQL, id)

            SELECT 
                *
            FROM
                replies
            WHERE
                id = ?;
        SQL
        Reply.new(user_hash.first)
    end
    
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

    attr_accessor :user_id, :question_id
    
    def initialize(options)
        @user_id = options["user_id"]
        @quesion_id = optoins["question_id"]
    end

    def create
        QuestionsDataBase.instance.execute(<<-SQL, user_id, question_id)
            INSERT INTO
                question_likes
            VALUES
                (?, ?)
            SQL
        id = QuestionsDataBase.instance.last_insert_row_id
    end
    
end